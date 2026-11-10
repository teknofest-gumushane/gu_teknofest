#!/usr/bin/env bash
# Claude Code PostToolUse hook'u (Edit | Write): yazılan dosyada hardcode, hard delete ve
# katman sınırı taraması yapar. İhlal varsa 2 ile çıkar ve ihlali stderr'e yazar; Claude Code
# bunu modele geri besler, böylece hata aynı turda düzeltilir.
#
# Girdi: stdin'de hook JSON'u (tool_input.file_path). Elle denemek için:
#   echo '{"tool_input":{"file_path":"lib/main.dart"}}' | bash tool/hooks/post_edit.sh
# Bağlama: .claude/settings.json → hooks.PostToolUse (örnek: tool/README.md).
# bash 3.2 uyumlu. jq varsa onu, yoksa sed'i kullanır.
set -u
HOOK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOL_DIR="$(cd "$HOOK_DIR/.." && pwd)"
ROOT="${CLAUDE_PROJECT_DIR:-$(cd "$TOOL_DIR/.." && pwd)}"

INPUT="$(cat 2>/dev/null || true)"
[ -z "$INPUT" ] && exit 0

if command -v jq >/dev/null 2>&1; then
  FILE="$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty' 2>/dev/null || true)"
else
  FILE="$(printf '%s' "$INPUT" | sed -n 's/.*"file_path"[ ]*:[ ]*"\([^"]*\)".*/\1/p' | head -1)"
fi
[ -z "$FILE" ] && exit 0

case "$FILE" in
  "$ROOT"/*) REL="${FILE#"$ROOT"/}" ;;
  /*) exit 0 ;;                       # proje dışı mutlak yol
  *) REL="$FILE" ;;
esac
[ -f "$ROOT/$REL" ] || exit 0

RC=0
OUT=""
run() {
  local o
  o="$("$@" 2>&1)"
  if [ $? -ne 0 ]; then OUT="${OUT}${o}
"; RC=2; fi
}

case "$REL" in
  *.g.dart|*.gen.dart|lib/l10n/app_localizations*|*firebase_options.dart) exit 0 ;;
  tool/test/fixtures/*) exit 0 ;;
  lib/*.dart|packages/*/lib/*.dart)
    run bash "$TOOL_DIR/check_hardcode.sh" --root "$ROOT" --files "$REL"
    run bash "$TOOL_DIR/check_no_hard_delete.sh" --root "$ROOT" --files "$REL"
    run bash "$TOOL_DIR/check_boundaries.sh" --root "$ROOT" --files "$REL"
    ;;
  *.rules)
    run bash "$TOOL_DIR/check_no_hard_delete.sh" --root "$ROOT" --files "$REL"
    ;;
  packages/*/pubspec.yaml)
    run bash "$TOOL_DIR/check_boundaries.sh" --root "$ROOT"
    ;;
  *) exit 0 ;;
esac

if [ "$RC" -ne 0 ]; then
  {
    echo "Kalite hook'u: $REL dosyasında ihlal var. Düzelt (gerekçesiz susturma yok):"
    printf '%s' "$OUT"
    echo "Kural listesi: bash tool/check_hardcode.sh --list"
  } >&2
  exit 2
fi
exit 0
