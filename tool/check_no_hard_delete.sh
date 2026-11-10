#!/usr/bin/env bash
# Hard delete denetimi: kayıt, dosya ve hesap silme çağrılarını yakalar (silme = soft delete).
#
#   bash tool/check_no_hard_delete.sh                  # lib/, packages/*/lib ve firebase/*.rules
#   bash tool/check_no_hard_delete.sh --files a.dart   # yalnızca verilen dosyalar (hook için)
#   bash tool/check_no_hard_delete.sh --list           # kural listesi
#   bash tool/check_no_hard_delete.sh --root <dizin>   # başka bir proje kökü (öz-test)
#
# Tek istisna alan temizlemedir (belge değil), gerekçesiyle:
#   // allow-field-delete: <gerekçe>      → FieldValue.delete()
# Belge, dosya ve hesap silme için satır içi istisna yoktur.
# Rules dosyalarında yalnızca tek satıra yazılmış `allow …;` ifadeleri denetlenir.
# Çıkış kodu: 0 temiz, 1 ihlal, 2 kullanım hatası.
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=tool/lib/scan.sh
. "$HERE/lib/scan.sh"
tf_init "$@"
if [ "$TF_HELP" = 1 ]; then sed -n '2,13p' "$0" | sed 's/^# \{0,1\}//'; exit 0; fi

W='(^|[^A-Za-z0-9_])'
WD='(^|[^A-Za-z0-9_.])'
E='([^A-Za-z0-9_]|$)'
FIELD='FieldValue\.delete *\( *\)'
DENY='allow +[a-z, ]+: *if +false *;'   # açıkça reddeden ifade serbest

tf_rule HD01 all   ".delete(…) yasak (Firestore/Storage/Auth) → softDelete / restore" \
  "\.delete *\(" "$FIELD"
tf_rule HD02 all   "deleteDoc/deleteApp/recursiveDelete/deleteUser yasak" \
  "${W}(deleteDoc|deleteDocument|deleteApp|recursiveDelete|deleteUser|deleteAll)${E}"
tf_rule HD03 all   "delete* adlı metot yasak (repository/servis arayüzünde silme yok) → softDelete* / restore*" \
  "${WD}delete[A-Z][A-Za-z0-9_]* *\("
tf_rule HD04 all   "delete adlı üye yasak: Future<…> delete( / void delete(" \
  "(Future|FutureOr) *<[^;{]*> +delete *\(|${W}void +delete *\("
tf_rule HD05 all   "FieldValue.delete() yalnızca alan temizlemede ve gerekçeli: // allow-field-delete: <gerekçe>" \
  "${W}${FIELD}" "" "allow-field-delete"

tf_rule HD20 rules "Rules: \`allow write\` delete'i de kapsar → ayrı create / update kullan" \
  "${W}allow +[a-z, ]*write[a-z, ]*[:;]" "$DENY"
tf_rule HD21 rules "Rules: koşulsuz \`allow …;\` (herkese açık) yasak" \
  "${W}allow +[a-z, ]+;"
tf_rule HD22 rules "Rules: \`allow delete\` yalnızca \`if false\` olabilir" \
  "${W}allow +[a-z, ]*delete[a-z, ]*:" "$DENY"

tf_report check_no_hard_delete
