#!/usr/bin/env bash
# Katman ve paket sınırı denetimi: kim kimi import edebilir.
#
#   bash tool/check_boundaries.sh                  # tüm proje (lib/ ve packages/*/lib)
#   bash tool/check_boundaries.sh --files a.dart   # yalnızca verilen dosyalar (hook için)
#   bash tool/check_boundaries.sh --list           # kural listesi
#   bash tool/check_boundaries.sh --root <dizin>   # başka bir proje kökü (öz-test)
#
# Kompozisyon kökü (feature view'larını ve Firebase SDK'sını import edebilir):
#   lib/main.dart, lib/core/bootstrap/*, lib/core/di/project_dependency.dart,
#   lib/core/env/app_environment.dart, lib/product/navigation/*
# Bu denetimde satır içi istisna yoktur. Göreli import'ları analyzer yakalar
# (always_use_package_imports); burada yalnızca package: yolları denetlenir.
# Çıkış kodu: 0 temiz, 1 ihlal, 2 kullanım hatası.
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=tool/lib/scan.sh
. "$HERE/lib/scan.sh"
tf_init "$@"
if [ "$TF_HELP" = 1 ]; then sed -n '2,14p' "$0" | sed 's/^# \{0,1\}//'; exit 0; fi

DATA="tf_data"
if [ "$TF_LIST" = 1 ]; then
  printf 'B03\t%s\n' "$DATA kaynağı Flutter arayüz kütüphanesi import edemez (material/widgets/cupertino…)"
  printf 'B04\t%s\n' "lib/features ve lib/product Firebase SDK'sını doğrudan import edemez (yalnızca $DATA üzerinden)"
  printf 'B05\t%s\n' "Bir feature başka bir feature'ı import edemez"
  printf 'B06\t%s\n' "$DATA pubspec'inde arayüz/rota/state paketi olamaz"
  printf 'B07\t%s\n' "lib/core ve lib/product (kompozisyon kökü dışı) lib/features import edemez; lib/core Firebase SDK import edemez"
  printf 'B08\t%s\n' "$DATA barrel'ı ve repository arayüzleri Firebase SDK import/export edemez"
  printf 'B09\t%s\n' "Paket dışından package:$DATA/src/ import edilemez (yalnızca package:$DATA/$DATA.dart)"
  exit 0
fi

APP="$(sed -n 's/^name: *\([A-Za-z0-9_]*\).*/\1/p' pubspec.yaml 2>/dev/null | head -1)"
FLUTTER_UI='^package:flutter/(material|widgets|cupertino|rendering|painting|gestures|animation)\.dart$'
FIREBASE='^package:(firebase_|cloud_firestore|cloud_functions)'
DATA_FORBIDDEN_DEP='^(flutter_svg|cached_network_image|go_router.*|.*riverpod.*|image_picker|flutter_localizations)$'

is_root() {
  case "$1" in
    lib/main.dart|lib/core/bootstrap/*|lib/core/di/project_dependency.dart|lib/core/env/app_environment.dart|lib/product/navigation/*) return 0 ;;
  esac
  return 1
}

# B06: veri paketinin bağımlılıkları.
PUB="packages/$DATA/pubspec.yaml"
if [ -f "$PUB" ]; then
  awk '
    /^[^ #]/ { sec = ($0 ~ /^dependencies:/) ? 1 : 0; next }
    sec && /^  [A-Za-z0-9_]+:/ { name = $1; sub(/:.*$/, "", name); printf "%d\t%s\n", NR, name }
  ' "$PUB" > "$TF_ALL.d"
  while IFS="$(printf '\t')" read -r ln dep; do
    if printf '%s' "$dep" | grep -Eq "$DATA_FORBIDDEN_DEP"; then
      tf_violation "$PUB" "$ln" B06 "$DATA içinde arayüz/rota/state paketi yasak" "$dep"
    fi
  done < "$TF_ALL.d"
fi

# Tüm import/export satırları: dosya <sekme> satır <sekme> yol
: > "$TF_ALL.i"
grep '\.dart$' "$TF_ALL" > "$TF_ALL.dart" || true
if [ -s "$TF_ALL.dart" ]; then
  tr '\n' '\0' < "$TF_ALL.dart" | xargs -0 awk '
    /^ *(import|export) +/ {
      line = $0
      sub(/^ *(import|export) +/, "", line)
      q = substr(line, 1, 1)
      rest = substr(line, 2)
      i = index(rest, q)
      if (i > 1) printf "%s\t%d\t%s\n", FILENAME, FNR, substr(rest, 1, i - 1)
    }
  ' > "$TF_ALL.i"
fi

while IFS="$(printf '\t')" read -r file ln imp; do
  [ -n "$imp" ] || continue
  in_data=0; case "$file" in packages/$DATA/lib/*) in_data=1 ;; esac

  # B03
  if [ "$in_data" = 1 ] && printf '%s' "$imp" | grep -Eq "$FLUTTER_UI"; then
    tf_violation "$file" "$ln" B03 "$DATA Flutter arayüz kütüphanesi import edemez" "$imp"
  fi

  is_fb=0; printf '%s' "$imp" | grep -Eq "$FIREBASE" && is_fb=1

  # B04
  if [ "$is_fb" = 1 ]; then
    case "$file" in
      lib/features/*|lib/product/*)
        is_root "$file" || tf_violation "$file" "$ln" B04 "Firebase SDK doğrudan import edilemez (yalnızca $DATA üzerinden)" "$imp" ;;
    esac
  fi

  # B05
  case "$file" in
    lib/features/*)
      own="${file#lib/features/}"; own="${own%%/*}"
      case "$imp" in
        "package:$APP/features/"*)
          other="${imp#package:"$APP"/features/}"; other="${other%%/*}"
          [ "$other" != "$own" ] && tf_violation "$file" "$ln" B05 "feature '$own' başka bir feature'ı ('$other') import edemez → ortak olanı lib/product'a taşı" "$imp" ;;
      esac ;;
  esac

  # B07
  case "$file" in
    lib/core/*|lib/product/*)
      if ! is_root "$file"; then
        case "$imp" in
          "package:$APP/features/"*) tf_violation "$file" "$ln" B07 "kompozisyon kökü dışında lib/features import edilemez" "$imp" ;;
        esac
        case "$file" in
          lib/core/*) [ "$is_fb" = 1 ] && tf_violation "$file" "$ln" B07 "lib/core Firebase SDK import edemez (kompozisyon kökü dışında)" "$imp" ;;
        esac
      fi ;;
  esac

  # B08
  if [ "$is_fb" = 1 ]; then
    case "$file" in
      packages/$DATA/lib/$DATA.dart)
        tf_violation "$file" "$ln" B08 "$DATA barrel'ı Firebase SDK import/export edemez" "$imp" ;;
      packages/$DATA/lib/src/repositories/firebase_*|packages/$DATA/lib/src/repositories/mock_*) ;;
      packages/$DATA/lib/src/repositories/*_repository.dart)
        tf_violation "$file" "$ln" B08 "repository arayüzü Firebase SDK import edemez (uygulama: firebase_*_repository.dart)" "$imp" ;;
    esac
  fi

  # B09
  if [ "$in_data" = 0 ]; then
    case "$imp" in
      "package:$DATA/src/"*) tf_violation "$file" "$ln" B09 "package:$DATA/src/ dışarıdan import edilemez → package:$DATA/$DATA.dart" "$imp" ;;
    esac
  fi
done < "$TF_ALL.i"

tf_report check_boundaries
