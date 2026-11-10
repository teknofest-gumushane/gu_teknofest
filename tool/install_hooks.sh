#!/usr/bin/env bash
# Git hook'larını kurar: git'e hook klasörü olarak tool/hooks gösterilir (dosya kopyalanmaz).
#
#   bash tool/install_hooks.sh            # kur
#   bash tool/install_hooks.sh --remove   # kaldır (git varsayılanına dön)
#
# Kurulan hook: pre-commit → bash tool/quality_gate.sh --static --check-format
# Ayar yalnızca bu klona yazılır (git config core.hooksPath); her geliştirici bir kez çalıştırır.
# Çıkış kodu: 0 (git deposu değilse de 0; yalnızca uyarır).
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
cd "$ROOT"

REMOVE=0
case "${1:-}" in
  --remove) REMOVE=1 ;;
  -h|--help) sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
  "") ;;
  *) echo "bilinmeyen argüman: $1" >&2; exit 2 ;;
esac

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "UYARI: burası henüz bir git deposu değil; hook kurulmadı. 'git init' sonrası yeniden çalıştır."
  exit 0
fi

if [ "$REMOVE" = 1 ]; then
  git config --unset core.hooksPath 2>/dev/null || true
  echo "install_hooks: kaldırıldı (git varsayılan hook klasörüne döndü)"
  exit 0
fi

chmod +x tool/hooks/pre-commit tool/hooks/post_edit.sh 2>/dev/null || true
git config core.hooksPath tool/hooks
echo "install_hooks: kuruldu (core.hooksPath = tool/hooks)"
