#!/usr/bin/env bash
# İlk kurulum: taze klonu çalışır hale getirir. Tekrar çalıştırmak zararsızdır.
#
#   bash tool/setup.sh
#
# Adımlar: araç kontrolü (flutter, dart, git) → flutter pub get + kod üretimi → git hook kurulumu → araç öz-testi.
# Bittiğinde: bash tool/dev.sh ile uygulamayı açabilirsin.
# Çıkış kodu: 0 başarılı, sıfırdan farklı = başarısız adım.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
cd "$ROOT"

case "${1:-}" in
  -h|--help) sed -n '2,8p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
  "") ;;
  *) echo "bilinmeyen argüman: $1" >&2; exit 2 ;;
esac

say() { printf '\n▸ %s\n' "$*"; }

say "Araçlar denetleniyor"
for t in flutter dart git; do
  command -v "$t" >/dev/null 2>&1 || { echo "$t bulunamadı; kurup PATH'e ekle." >&2; exit 1; }
done
flutter --version | head -1

say "Bağımlılıklar ve kod üretimi"
bash tool/codegen.sh

say "Git hook'ları"
bash tool/install_hooks.sh

say "Araç öz-testi"
bash tool/test/run.sh | tail -1

say "Kurulum tamam. Uygulamayı açmak için: bash tool/dev.sh"
