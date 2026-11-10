#!/usr/bin/env bash
# Hardcode denetimi: sabit renk, boşluk, yazı ölçüsü, süre, metin, ikon ve yasak çağrıları yakalar.
#
#   bash tool/check_hardcode.sh                    # tüm proje (lib/ ve packages/*/lib)
#   bash tool/check_hardcode.sh --files a.dart b.dart   # yalnızca verilen dosyalar (hook için)
#   bash tool/check_hardcode.sh --list             # kural listesi
#   bash tool/check_hardcode.sh --root <dizin>     # başka bir proje kökü (öz-test)
#
# Satır içi istisna (gerekçe zorunlu), aynı satırda ya da hemen üstündeki yorum satırında:
#   // ignore-hardcode: <gerekçe>
# Serbest bölgeler: lib/product/theme/ (token tanımları), lib/product/icon/ (TfIcons kayıt defteri),
#   lib/core/constants/ (süre ve adres sabitleri), lib/core/error/ (logger).
# Çıkış kodu: 0 temiz, 1 ihlal, 2 kullanım hatası.
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=tool/lib/scan.sh
. "$HERE/lib/scan.sh"
tf_init "$@"
if [ "$TF_HELP" = 1 ]; then sed -n '2,13p' "$0" | sed 's/^# \{0,1\}//'; exit 0; fi

SQ="'"
Q="[${SQ}\"]"                       # tek ya da çift tırnak
W='(^|[^A-Za-z0-9_])'               # sözcük başı
WD='(^|[^A-Za-z0-9_.])'             # sözcük başı, üye erişimi değil
NUM=' *-?[0-9]*\.?[0-9]*[1-9]'      # sıfırdan farklı sayı
M='ignore-hardcode'

tf_rule HC01 notheme  "Renk sabiti: Color(0x…)/Color.fromARGB → context.tf.colors.*" \
  "${W}Color\( *0x|${W}Color\.from(ARGB|RGBO)\(" "" "$M"
tf_rule HC02 notheme  "Material/Cupertino renk sabiti → context.tf.colors.* (Colors.transparent serbest)" \
  "${W}(Colors|CupertinoColors)\.[A-Za-z]" "Colors\.transparent" "$M"
tf_rule HC03 notheme  "Theme.of(context) doğrudan → context.tf.* extension" \
  "${W}Theme\.of\(" "" "$M"
tf_rule HC04 ui       "Sayısal boşluk: EdgeInsets → TfSpacing / TfInsets" \
  "EdgeInsets(Directional)?\.(all|only|symmetric|fromLTRB|fromSTEB)\(([^;]*[(:,])?${NUM}" "" "$M"
tf_rule HC06 ui       "Sayısal köşe yarıçapı → TfRadius.*" \
  "(BorderRadius\.(circular|all)|Radius\.circular)\(${NUM}" "" "$M"
tf_rule HC07 ui       "Yazı ölçüsü sabiti (fontSize/FontWeight/fontFamily/letterSpacing) → context.tf.text.*" \
  "${W}fontSize *: *[0-9.]|${W}FontWeight\.[a-z]|${W}fontFamily *:|${W}letterSpacing *: *-?[0-9.]" "" "$M"
tf_rule HC08 ui       "Süre/eğri sabiti → TfMotion.* (iş süreleri lib/core/constants içinde)" \
  "${W}Duration\( *(microseconds|milliseconds|seconds|minutes|hours|days) *: *[0-9]|${W}Curves\.[A-Za-z]" "" "$M"
tf_rule HC09 ui       "Arayüz metni koda yazılmış → context.l10n.* (ARB)" \
  "${W}Text\( *${Q}|${W}(hintText|labelText|helperText|errorText|tooltip|semanticsLabel|semanticLabel) *: *${Q}" "" "$M"
tf_rule HC10 noicon   "Icons.* doğrudan → TfIcons.* (kayıt defteri: lib/product/icon)" \
  "${W}(Icons|CupertinoIcons)\.[a-z_]" "" "$M"
tf_rule HC11 nologger "print/debugPrint → AppLogger" \
  "${WD}(print|debugPrint) *\(" "" "$M"
tf_rule HC12 all      "Navigator.push* yasak → go_router" \
  "${W}Navigator\.(push|pushNamed|pushReplacement|pushReplacementNamed|pushAndRemoveUntil|pushNamedAndRemoveUntil|popAndPushNamed)([^A-Za-z0-9_]|\$)|${W}Navigator\.of\([^)]*\)\.push" "" "$M"
tf_rule HC13 viewish  "View/widget katmanında GetIt yasak → ProjectDependencyMixin / AppProviderMixin" \
  "${W}GetIt([^A-Za-z0-9_]|\$)" "" "$M"
tf_rule HC14 features "Düz StatefulWidget/State yasak → ConsumerStatefulWidget / ConsumerState" \
  "extends +(StatefulWidget|State<)" "" "$M"
tf_rule HC15 ui       "Sayısal ölçü parametresi → token (TfSizes / TfSpacing / …)" \
  "${W}(width|height|size|minWidth|minHeight|maxWidth|maxHeight|radius|thickness|elevation|blurRadius|spreadRadius|strokeWidth|dimension|iconSize|top|bottom|left|right|horizontal|vertical) *:${NUM}" "" "$M"
tf_rule HC17 ui       "Opaklık sabiti (withOpacity/withValues(alpha:)/withAlpha/Opacity) → renk token'ı" \
  "\.withOpacity\(|\.withValues\( *alpha *: *[0-9.]|\.withAlpha\( *[0-9]|${W}Opacity\( *opacity *: *[0-9.]" "" "$M"
tf_rule HC18 noconst  "URL/e-posta sabiti → AppConstants" \
  "${Q}(https?://|mailto:)" "" "$M"

# HC00: istisna işareti gerekçesiz bırakılamaz.
if [ "$TF_LIST" = 1 ]; then
  printf 'HC00\t%s\n' "ignore-hardcode işaretinde gerekçe zorunlu"
else
  while IFS= read -r f; do
    case "$f" in *.dart) ;; *) continue ;; esac
    grep -nE "// *${M}" "$f" 2>/dev/null | grep -vE "// *${M}: *[^ ]" | while IFS=: read -r ln text; do
      printf '%s:%s: [HC00] %s\n    %s\n' "$f" "$ln" "ignore-hardcode işaretinde gerekçe zorunlu" "$(printf '%s' "$text" | sed 's/^ *//')"
    done
  done < "$TF_ALL" > "$TF_ALL.h"
  if [ -s "$TF_ALL.h" ]; then
    cat "$TF_ALL.h"
    TF_VIOLATIONS=$((TF_VIOLATIONS + $(grep -c '^[^ ]' "$TF_ALL.h")))
  fi
fi

tf_report check_hardcode
