#!/usr/bin/env bash
# Geliştirme: uygulamayı tarayıcıda çalıştırır.
#
#   bash tool/dev.sh                    # Chrome'da aç (ENV=mock: sahte veri, Firebase yok)
#   bash tool/dev.sh --env emulator     # Firebase emülatörüne bağlan (backend fazı)
#   bash tool/dev.sh --env prod         # gerçek Firebase projesine bağlan (dikkat: gerçek veri)
#   bash tool/dev.sh --port 5000        # sabit port (varsayılan: Flutter rastgele seçer)
#   bash tool/dev.sh --server           # tarayıcı açma; yalnızca web sunucusu (başka cihazdan bakmak için)
#   kalan argümanlar flutter run'a geçer, ör: bash tool/dev.sh --profile
#
# ENV değeri uygulamaya --dart-define=ENV=<değer> ile geçer; lib/core/env/app_environment.dart okur.
# Çalışırken: r = hot reload, R = hot restart, q = çık.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
cd "$ROOT"

ENV_NAME="mock"; PORT=""; DEVICE="chrome"
EXTRA=()
while [ $# -gt 0 ]; do
  case "$1" in
    --env) ENV_NAME="${2:-}"; shift 2 || { echo "--env değer ister" >&2; exit 2; } ;;
    --port) PORT="${2:-}"; shift 2 || { echo "--port değer ister" >&2; exit 2; } ;;
    --server) DEVICE="web-server"; shift ;;
    -h|--help) sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) EXTRA+=("$1"); shift ;;
  esac
done

case "$ENV_NAME" in
  mock|emulator|prod) ;;
  *) echo "geçersiz --env: '$ENV_NAME' (mock | emulator | prod)" >&2; exit 2 ;;
esac
if [ -n "$PORT" ] && ! printf '%s' "$PORT" | grep -Eq '^[0-9]+$'; then echo "geçersiz --port: '$PORT'" >&2; exit 2; fi

ARGS=(-d "$DEVICE" "--dart-define=ENV=$ENV_NAME")
[ -n "$PORT" ] && ARGS+=("--web-port=$PORT")
[ "$DEVICE" = "web-server" ] && ARGS+=("--web-hostname=0.0.0.0")

echo "▸ flutter run ${ARGS[*]} ${EXTRA[*]+${EXTRA[*]}}"
exec flutter run "${ARGS[@]}" ${EXTRA[@]+"${EXTRA[@]}"}
