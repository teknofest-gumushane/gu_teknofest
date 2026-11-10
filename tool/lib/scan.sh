#!/usr/bin/env bash
# Ortak tarama yardımcıları. check_*.sh betikleri `source` eder; tek başına çalıştırılmaz.
#
# Taşınabilirlik: bash 3.2 (macOS) ve BSD awk / mawk / gawk ile çalışır. Bu yüzden desenlerde
# \b, \s, \d, \w, [[:space:]] ve sekme kullanılmaz (dart format zaten yalnızca boşluk üretir).
#
# Sağladıkları:
#   tf_init "$@"                      argümanları ayrıştırır, köke geçer, taranacak dosyaları toplar
#   tf_rule ID KAPSAM MESAJ DESEN [SİL] [İŞARET]
#                                     kapsamdaki dosyalarda DESEN arar; eşleşmeyi ihlal olarak yazar
#   tf_report AD                      özet satırını yazar, ihlal varsa 1 ile çıkar
#
# Bir satır şu durumlarda ihlal sayılmaz:
#   - tamamı yorumsa (// ya da /// ile başlıyorsa)
#   - İŞARET verilmişse ve aynı satırda ya da hemen üstündeki yorum satırında
#     "// İŞARET: <gerekçe>" varsa (gerekçe zorunlu)

TF_ROOT=""; TF_LIST=0; TF_HELP=0; TF_FILES_MODE=0; TF_ALL=""; TF_VIOLATIONS=0; TF_SCANNED=0

tf_cleanup() { [ -n "$TF_ALL" ] && rm -f "$TF_ALL" "$TF_ALL".* 2>/dev/null; return 0; }

tf_init() {
  local here root_arg="" given=""
  here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  while [ $# -gt 0 ]; do
    case "$1" in
      --root) root_arg="${2:-}"; [ -n "$root_arg" ] || { echo "--root değer ister" >&2; exit 2; }; shift 2 ;;
      --list) TF_LIST=1; shift ;;
      --files)
        TF_FILES_MODE=1; shift
        while [ $# -gt 0 ]; do
          case "$1" in --*) break ;; *) given="$given$1
"; shift ;; esac
        done ;;
      -h|--help) TF_HELP=1; shift ;;
      *) echo "bilinmeyen argüman: $1" >&2; exit 2 ;;
    esac
  done

  if [ -n "$root_arg" ]; then TF_ROOT="$(cd "$root_arg" 2>/dev/null && pwd)"; else TF_ROOT="$(cd "$here/../.." && pwd)"; fi
  [ -n "$TF_ROOT" ] && [ -d "$TF_ROOT" ] || { echo "proje kökü bulunamadı: $root_arg" >&2; exit 2; }
  cd "$TF_ROOT" || exit 2

  TF_ALL="$(mktemp "${TMPDIR:-/tmp}/tf_scan.XXXXXX")" || exit 2
  trap tf_cleanup EXIT

  if [ "$TF_FILES_MODE" = 1 ]; then
    # Verilen yollar köke göre göreli hale getirilir; kök dışındakiler ve olmayanlar atlanır.
    printf '%s' "$given" | while IFS= read -r f; do
      [ -n "$f" ] || continue
      case "$f" in "$TF_ROOT"/*) f="${f#"$TF_ROOT"/}" ;; /*) continue ;; esac
      [ -f "$f" ] && printf '%s\n' "$f"
    done > "$TF_ALL"
  else
    {
      for d in lib packages/*/lib; do
        [ -d "$d" ] && find "$d" -type f -name '*.dart'
      done
      [ -d firebase ] && find firebase -type f -name '*.rules' ! -path '*/node_modules/*'
    } 2>/dev/null | sort > "$TF_ALL"
  fi

  # Üretilen dosyalar hiçbir zaman taranmaz.
  grep -vE '(\.g\.dart|\.gen\.dart|/app_localizations[^/]*\.dart|(^|/)firebase_options\.dart)$' "$TF_ALL" > "$TF_ALL.f" || true
  mv "$TF_ALL.f" "$TF_ALL"
  TF_SCANNED="$(wc -l < "$TF_ALL" | tr -d ' ')"
}

# tf_in_scope KAPSAM YOL — yol kapsamdaysa 0.
tf_in_scope() {
  local p="$2"
  case "$1" in
    all)      case "$p" in lib/*.dart|packages/*/lib/*.dart) return 0 ;; esac ;;
    notheme)  case "$p" in lib/product/theme/*) return 1 ;; lib/*.dart|packages/*/lib/*.dart) return 0 ;; esac ;;
    noicon)   case "$p" in lib/product/icon/*) return 1 ;; lib/*.dart|packages/*/lib/*.dart) return 0 ;; esac ;;
    nologger) case "$p" in lib/core/error/*) return 1 ;; lib/*.dart|packages/*/lib/*.dart) return 0 ;; esac ;;
    noconst)  case "$p" in lib/core/constants/*|lib/product/theme/*) return 1 ;; lib/*.dart) return 0 ;; esac ;;
    ui)       case "$p" in lib/product/theme/*|lib/product/icon/*|lib/core/constants/*|lib/l10n/*) return 1 ;; lib/*.dart) return 0 ;; esac ;;
    viewish)  case "$p" in lib/features/*/view/*.dart|lib/product/widget/*.dart) return 0 ;; esac ;;
    features) case "$p" in lib/features/*.dart) return 0 ;; esac ;;
    rules)    case "$p" in *.rules) return 0 ;; esac ;;
  esac
  return 1
}

TF_AWK='
BEGIN { re = ENVIRON["TF_RE"]; strip = ENVIRON["TF_STRIP"]; mk = ENVIRON["TF_MARK"]; id = ENVIRON["TF_ID"]; msg = ENVIRON["TF_MSG"] }
FNR == 1 { prev_ok = 0 }
{
  raw = $0
  t = raw
  sub(/^ +/, "", t)
  if (t ~ /^\/\//) {
    prev_ok = 0
    if (mk != "" && t ~ ("^//+ *" mk ": *[^ ]")) prev_ok = 1
    next
  }
  if (t ~ /^\*/ || t ~ /^\/\*/) { prev_ok = 0; next }
  same_ok = 0
  if (mk != "" && raw ~ ("// *" mk ": *[^ ]")) same_ok = 1
  code = raw
  sub(/ +\/\/ .*$/, "", code)
  if (strip != "") gsub(strip, "", code)
  if (code ~ re && !same_ok && !prev_ok) {
    printf "%s:%d: [%s] %s\n    %s\n", FILENAME, FNR, id, msg, t
  }
  prev_ok = 0
}
'

# tf_rule ID KAPSAM MESAJ DESEN [SİL] [İŞARET]
#   SİL: eşleştirmeden önce satırdan silinecek desen (izinli biçimleri ayıklamak için).
tf_rule() {
  local id="$1" scope="$2" msg="$3" re="$4" strip="${5:-}" mark="${6:-}"
  if [ "$TF_LIST" = 1 ]; then printf '%s\t%s\n' "$id" "$msg"; return 0; fi
  local list="$TF_ALL.s" f out n
  : > "$list"
  while IFS= read -r f; do
    tf_in_scope "$scope" "$f" && printf '%s\n' "$f" >> "$list"
  done < "$TF_ALL"
  [ -s "$list" ] || return 0
  out="$(tr '\n' '\0' < "$list" | TF_RE="$re" TF_STRIP="$strip" TF_MARK="$mark" TF_ID="$id" TF_MSG="$msg" xargs -0 awk "$TF_AWK" 2>&1)"
  if [ -n "$out" ]; then
    printf '%s\n' "$out"
    n="$(printf '%s\n' "$out" | grep -c '^[^ ]')"
    TF_VIOLATIONS=$((TF_VIOLATIONS + n))
  fi
  return 0
}

# tf_violation DOSYA SATIR ID MESAJ METİN — awk dışı denetimler için tek ihlal yazar.
tf_violation() {
  printf '%s:%s: [%s] %s\n    %s\n' "$1" "$2" "$3" "$4" "$5"
  TF_VIOLATIONS=$((TF_VIOLATIONS + 1))
}

tf_report() {
  [ "$TF_LIST" = 1 ] && exit 0
  if [ "$TF_VIOLATIONS" -gt 0 ]; then
    echo "$1: $TF_VIOLATIONS ihlal ($TF_SCANNED dosya tarandı)"
    exit 1
  fi
  echo "$1: temiz ($TF_SCANNED dosya tarandı)"
  exit 0
}
