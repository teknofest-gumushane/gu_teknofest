#!/usr/bin/env bash
# Web release derlemesi → build/web. Yayın iş akışı (web-deploy) bunu kullanır.
#
#   bash tool/build_web.sh                      # ENV=prod, kök adreste yayın
#   bash tool/build_web.sh --env mock           # sahte veriyle derle (önizleme / tasarım kontrolü)
#   bash tool/build_web.sh --base-href /alt/    # alt klasörde yayın (ör. GitHub Pages: /gu_teknofest/)
#   bash tool/build_web.sh --no-codegen         # kod üretimini atla (CI ayrı adımda yaptıysa)
#
# Çıktı build/web altındadır ve commit edilmez. Yerelde bakmak için:
#   (cd build/web && python3 -m http.server 8080)   → http://localhost:8080
# Çıkış kodu: 0 başarılı, sıfırdan farklı = başarısız adım.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
cd "$ROOT"

ENV_NAME="prod"; BASE_HREF="/"; CODEGEN=1
while [ $# -gt 0 ]; do
  case "$1" in
    --env) ENV_NAME="${2:-}"; shift 2 || { echo "--env değer ister" >&2; exit 2; } ;;
    --base-href) BASE_HREF="${2:-}"; shift 2 || { echo "--base-href değer ister" >&2; exit 2; } ;;
    --no-codegen) CODEGEN=0; shift ;;
    -h|--help) sed -n '2,11p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "bilinmeyen argüman: $1" >&2; exit 2 ;;
  esac
done

case "$ENV_NAME" in
  mock|emulator|prod) ;;
  *) echo "geçersiz --env: '$ENV_NAME' (mock | emulator | prod)" >&2; exit 2 ;;
esac
case "$BASE_HREF" in
  /|/*/) ;;
  *) echo "geçersiz --base-href: '$BASE_HREF' (/ ile başlayıp / ile bitmeli)" >&2; exit 2 ;;
esac

if [ "$CODEGEN" = 1 ]; then bash tool/codegen.sh; fi

echo "== flutter build web (ENV=$ENV_NAME, base-href=$BASE_HREF)"
flutter build web --release "--dart-define=ENV=$ENV_NAME" --base-href "$BASE_HREF"

SIZE="$(du -sh build/web | cut -f1)"
JS="$(du -h build/web/main.dart.js 2>/dev/null | cut -f1)"
echo "build_web: build/web hazır (toplam $SIZE, main.dart.js ${JS:-?})"
