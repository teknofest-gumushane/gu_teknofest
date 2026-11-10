#!/usr/bin/env bash
# Kod üretimi: build_runner (kök + yerel paketler) ve gen-l10n.
#
#   bash tool/codegen.sh           # bir kez üret
#   bash tool/codegen.sh --watch   # dosya değiştikçe yeniden üret (yalnızca kök; Ctrl+C ile çık)
#   bash tool/codegen.sh --clean   # build_runner önbelleğini temizle, baştan üret
#
# Ne üretir: @riverpod view model'leri ve typed rotalar (*.g.dart), tf_data modelleri (*.g.dart),
#            ARB'den lib/l10n/app_localizations*.dart. Üretilen dosyalar commit edilmez (.gitignore).
# Ne zaman:  @riverpod / rota / @JsonSerializable / ARB değiştiğinde, dal değiştirince, taze klonda.
# Çıkış kodu: 0 başarılı, sıfırdan farklı = ilk başarısız adımın kodu.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
cd "$ROOT"

MODE="build"
for a in "$@"; do
  case "$a" in
    --watch) MODE="watch" ;;
    --clean) MODE="clean" ;;
    -h|--help) sed -n '2,11p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "bilinmeyen argüman: $a" >&2; exit 2 ;;
  esac
done

echo "== flutter pub get"
flutter pub get

has_runner() { grep -q '^ *build_runner:' "$1/pubspec.yaml" 2>/dev/null; }
run_runner() {
  local dir="$1"
  echo "== build_runner ($dir)"
  case "$MODE" in
    watch) ( cd "$dir" && dart run build_runner watch --delete-conflicting-outputs ) ;;
    clean) ( cd "$dir" && dart run build_runner clean && dart run build_runner build --delete-conflicting-outputs ) ;;
    *)     ( cd "$dir" && dart run build_runner build --delete-conflicting-outputs ) ;;
  esac
}

# Önce paketler: kök, paketlerin ürettiği koda bağımlı olabilir. --watch engelleyici olduğu için en sonda.
for p in packages/*/; do
  p="${p%/}"
  if [ -f "$p/pubspec.yaml" ] && has_runner "$p"; then
    if [ "$MODE" = "watch" ]; then
      echo "== build_runner ($p) — izleme kipinde paketler bir kez üretilir"
      ( cd "$p" && dart run build_runner build --delete-conflicting-outputs )
    else
      run_runner "$p"
    fi
  fi
done

if [ -f l10n.yaml ]; then
  echo "== flutter gen-l10n"
  flutter gen-l10n
else
  echo "== gen-l10n atlandı (l10n.yaml yok)"
fi

if has_runner "."; then run_runner "."; fi
echo "codegen: tamam"
