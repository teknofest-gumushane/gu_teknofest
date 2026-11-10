#!/usr/bin/env bash
# Kalite kapısı: tüm kontrolleri sırayla çalıştırır. Kırmızıyken commit yok.
#
#   bash tool/quality_gate.sh                 # tam kapı: format + codegen + analyze + taramalar + test (kapsam raporlu)
#   bash tool/quality_gate.sh --fast          # ara kontrol: codegen yok, test kapsamsız
#   bash tool/quality_gate.sh --static        # yalnızca statik: format + analyze + taramalar (codegen ve test yok)
#   ek: --check-format (biçimlendirmeyi uygulama, yalnızca doğrula; CI ve pre-commit bunu kullanır)
#       --verbose      (adım çıktılarını akıt)
#   ortam: TF_GATE_STATIC_ONLY=1 (flutter/dart adımlarını atla; yalnızca taramalar ve öz-test)
#
# Adımlar: format → codegen → analyze → araç öz-testi → sınırlar → hardcode → hard-delete → test → rules.
# --fast ve --static üretilmiş dosyaların güncel olduğunu varsayar; değilse önce: bash tool/codegen.sh
# Başarısız adımın logunun son satırları gösterilir; tam log: tool/.cache/gate-logs/.
# Not (Claude Code): Bash aracının varsayılan zaman aşımı 2 dk'dır; tam kapı için timeout=600000 ver.
# Çıkış kodu: 0 yeşil, 1 kırmızı, 2 kullanım hatası. bash 3.2 (macOS) uyumludur.

set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
cd "$ROOT" || exit 2

FAST=0; STATIC=0; CHECK_FMT=0
VERBOSE="${TF_GATE_VERBOSE:-0}"
STATIC_ONLY="${TF_GATE_STATIC_ONLY:-0}"

usage() { sed -n '2,15p' "$0" | sed 's/^# \{0,1\}//'; }

while [ $# -gt 0 ]; do
  case "$1" in
    --fast) FAST=1; shift ;;
    --static) STATIC=1; shift ;;
    --check-format) CHECK_FMT=1; shift ;;
    --verbose) VERBOSE=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "bilinmeyen argüman: $1" >&2; usage; exit 2 ;;
  esac
done
if [ "$FAST" = 1 ] && [ "$STATIC" = 1 ]; then echo "--fast ve --static birlikte kullanılamaz" >&2; exit 2; fi

MODE="full"; [ "$FAST" = 1 ] && MODE="fast"; [ "$STATIC" = 1 ] && MODE="static"

LOGDIR="$ROOT/tool/.cache/gate-logs"
mkdir -p "$LOGDIR" && rm -f "$LOGDIR"/*.log 2>/dev/null

if [ "$STATIC_ONLY" != 1 ]; then
  for t in flutter dart; do
    command -v "$t" >/dev/null 2>&1 || { echo "$t bulunamadı. Flutter SDK PATH'te olmalı (ya da TF_GATE_STATIC_ONLY=1)." >&2; exit 2; }
  done
fi

N=0; PASSED=0; FAILED=""; WARNINGS=""
T_START=$(date +%s)

# step <ad> <komut ...>
step() {
  local name="$1"; shift
  N=$((N + 1))
  local log; log="$LOGDIR/$(printf '%02d' "$N")-$name.log"
  local t0; t0=$(date +%s)
  local rc
  if [ "$VERBOSE" = 1 ]; then
    "$@" 2>&1 | tee "$log"; rc=${PIPESTATUS[0]}
  else
    "$@" >"$log" 2>&1; rc=$?
  fi
  local dt=$(( $(date +%s) - t0 ))
  if [ "$rc" -eq 0 ]; then
    printf '  ✓ %-18s %4ss\n' "$name" "$dt"
    PASSED=$((PASSED + 1))
    grep -E '^UYARI' "$log" 2>/dev/null | head -5 | sed 's/^/      /'
  else
    printf '  ✗ %-18s %4ss   log: tool/.cache/gate-logs/%s\n' "$name" "$dt" "$(basename "$log")"
    if [ "$VERBOSE" != 1 ]; then tail -n 40 "$log" | sed 's/^/      /'; fi
    FAILED="$FAILED $name"
  fi
  return 0
}
skip() { printf '  – %-18s atlandı (%s)\n' "$1" "$2"; }

# ── adım gövdeleri ─────────────────────────────────────────
fmt_dirs() { local d out=""; for d in lib test integration_test packages; do [ -d "$d" ] && out="$out $d"; done; printf '%s' "$out"; }

do_format() {
  local dirs; dirs="$(fmt_dirs)"
  [ -z "$dirs" ] && { echo "biçimlendirilecek dizin yok"; return 0; }
  if [ "$CHECK_FMT" = 1 ]; then
    # shellcheck disable=SC2086
    dart format --output=none --set-exit-if-changed $dirs
  else
    # shellcheck disable=SC2086
    dart format $dirs
  fi
}

do_analyze() {
  local rc=0 p
  flutter analyze --fatal-infos --fatal-warnings . || rc=1
  for p in packages/*/; do
    if [ -f "${p}pubspec.yaml" ]; then
      ( cd "$p" && flutter analyze --fatal-infos --fatal-warnings . ) || rc=1
    fi
  done
  return $rc
}

do_tests() {
  local rc=0 dir ran=0 cov=""
  [ "$MODE" = "full" ] && cov="--coverage"
  for dir in . packages/*; do
    [ -d "$dir/test" ] || continue
    [ -f "$dir/pubspec.yaml" ] || continue
    ran=1
    echo "== flutter test ($dir)"
    # shellcheck disable=SC2086
    ( cd "$dir" && flutter test $cov ) || rc=1
  done
  if [ "$ran" = 0 ]; then echo "HATA: hiç test dizini yok"; return 1; fi
  return $rc
}

do_rules() {
  if [ ! -d firebase/node_modules ]; then echo "HATA: firebase/node_modules yok — (cd firebase && npm ci)"; return 1; fi
  command -v firebase >/dev/null 2>&1 || { echo "HATA: firebase CLI yok (emülatör gerekli) — npm i -g firebase-tools"; return 1; }
  ( cd firebase && npm test )
}

# ── akış ───────────────────────────────────────────────────
echo "Kalite kapısı ($MODE)"

if [ "$STATIC_ONLY" = 1 ]; then
  skip format "TF_GATE_STATIC_ONLY"; skip codegen "TF_GATE_STATIC_ONLY"; skip analyze "TF_GATE_STATIC_ONLY"
else
  step format do_format
  if [ "$MODE" = "full" ]; then step codegen bash tool/codegen.sh; else skip codegen "--$MODE"; fi
  step analyze do_analyze
fi

step oz-test bash tool/test/run.sh
step sinirlar bash tool/check_boundaries.sh
step hardcode bash tool/check_hardcode.sh
step hard-delete bash tool/check_no_hard_delete.sh

if [ "$MODE" = "static" ]; then skip test "--static"
elif [ "$STATIC_ONLY" = 1 ]; then skip test "TF_GATE_STATIC_ONLY"
else step test do_tests; fi

if [ "$MODE" != "full" ]; then skip rules "--$MODE"
elif [ -f firebase/package.json ]; then step rules do_rules
else skip rules "firebase/package.json yok (backend fazı)"; fi

DT=$(( $(date +%s) - T_START ))
echo
if [ -n "$FAILED" ]; then
  echo "KIRMIZI — başarısız:$FAILED  ($PASSED/$N geçti, ${DT}s)"
  exit 1
fi
echo "YEŞİL — $PASSED/$N adım geçti (${DT}s)"
[ "$MODE" != "full" ] && echo "Not: --$MODE ara kontroldür; commit ve PR öncesi tam kapıyı çalıştır."
exit 0
