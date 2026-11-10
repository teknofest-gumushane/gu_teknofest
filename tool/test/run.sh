#!/usr/bin/env bash
# Araç öz-testi: denetim betiklerini temiz ve ihlalli sahte proje ağaçlarına karşı çalıştırır.
#
#   bash tool/test/run.sh            # tüm öz-testler
#   bash tool/test/run.sh --verbose  # denetim çıktılarını da göster
#
# Beklenen: fixtures/clean her denetimden 0 ile çıkar; fixtures/violating 1 ile çıkar ve
# aşağıda listelenen her kural kimliğini en az bir kez raporlar.
# Bir kuralın desenini değiştirdiysen önce bu betiği çalıştır.
# Çıkış kodu: 0 hepsi geçti, 1 en az biri kaldı.
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOL="$(cd "$HERE/.." && pwd)"
FIX="$HERE/fixtures"
VERBOSE=0
case "${1:-}" in
  --verbose) VERBOSE=1 ;;
  -h|--help) sed -n '2,10p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
  "") ;;
  *) echo "bilinmeyen argüman: $1" >&2; exit 2 ;;
esac

PASS=0; FAIL=0
ok()  { PASS=$((PASS + 1)); printf '  ✓ %s\n' "$1"; }
bad() { FAIL=$((FAIL + 1)); printf '  ✗ %s\n' "$1"; }

# expect_clean BETİK
expect_clean() {
  local out rc
  out="$(bash "$TOOL/$1" --root "$FIX/clean" 2>&1)"; rc=$?
  [ "$VERBOSE" = 1 ] && printf '%s\n' "$out" | sed 's/^/      /'
  if [ "$rc" -eq 0 ]; then ok "$1 temiz ağaçta 0 ile çıktı"
  else bad "$1 temiz ağaçta $rc ile çıktı"; printf '%s\n' "$out" | sed 's/^/      /'; fi
}

# expect_violations BETİK KURAL...
expect_violations() {
  local script="$1" out rc id; shift
  out="$(bash "$TOOL/$script" --root "$FIX/violating" 2>&1)"; rc=$?
  [ "$VERBOSE" = 1 ] && printf '%s\n' "$out" | sed 's/^/      /'
  if [ "$rc" -eq 1 ]; then ok "$script ihlalli ağaçta 1 ile çıktı"
  else bad "$script ihlalli ağaçta $rc ile çıktı (beklenen 1)"; fi
  for id in "$@"; do
    if printf '%s\n' "$out" | grep -q "\[$id\]"; then ok "$script $id yakaladı"
    else bad "$script $id yakalamadı"; fi
  done
}

# expect_list BETİK — --list her kuralı tek satırda yazar ve 0 ile çıkar.
expect_list() {
  local out rc
  out="$(bash "$TOOL/$1" --list 2>&1)"; rc=$?
  if [ "$rc" -eq 0 ] && [ -n "$out" ]; then ok "$1 --list çalışıyor"
  else bad "$1 --list başarısız ($rc)"; fi
}

echo "check_hardcode.sh"
expect_clean check_hardcode.sh
expect_violations check_hardcode.sh HC00 HC01 HC02 HC03 HC04 HC06 HC07 HC08 HC09 HC10 HC11 HC12 HC13 HC14 HC15 HC17 HC18
expect_list check_hardcode.sh

echo "check_boundaries.sh"
expect_clean check_boundaries.sh
expect_violations check_boundaries.sh B03 B04 B05 B06 B07 B08 B09
expect_list check_boundaries.sh

echo "check_no_hard_delete.sh"
expect_clean check_no_hard_delete.sh
expect_violations check_no_hard_delete.sh HD01 HD02 HD03 HD04 HD05 HD20 HD21 HD22
expect_list check_no_hard_delete.sh

echo "--files kipi"
out="$(bash "$TOOL/check_hardcode.sh" --root "$FIX/violating" --files lib/features/admin/view/admin_view.dart 2>&1)"; rc=$?
if [ "$rc" -eq 0 ]; then ok "check_hardcode.sh --files yalnızca verilen dosyayı taradı"
else bad "check_hardcode.sh --files beklenmedik ihlal buldu"; printf '%s\n' "$out" | sed 's/^/      /'; fi
out="$(bash "$TOOL/check_boundaries.sh" --root "$FIX/violating" --files lib/features/admin/view/admin_view.dart 2>&1)"; rc=$?
if [ "$rc" -eq 1 ] && printf '%s\n' "$out" | grep -q '\[B05\]'; then ok "check_boundaries.sh --files ihlali yakaladı"
else bad "check_boundaries.sh --files ihlali yakalamadı ($rc)"; fi

echo
echo "öz-test: $PASS geçti, $FAIL kaldı"
[ "$FAIL" -eq 0 ]
