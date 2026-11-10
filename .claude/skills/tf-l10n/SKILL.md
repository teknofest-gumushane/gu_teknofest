---
name: tf-l10n
description: ARB tabanlı yerelleştirme kuralları (yalnız Türkçe, lib/l10n/app_tr.arb). Arayüze metin eklerken, ARB anahtarı eklerken ya da değiştirirken, çoğul / parametre / tarih-sayı biçimi veya Türkçe büyük-küçük harf konularında kullan.
---

# tf-l10n

Kurallar `CLAUDE.md §8`; karar D-09 (şimdilik yalnız Türkçe). Tek dosya: `lib/l10n/app_tr.arb`. İngilizce ARB **yok**, dil eşitliği denetimi **yok**; ikinci dil istenirse önce `tf-ask-user`.

## Kurallar

1. **Arayüzde string literal yok** (HC09). Her metin `context.l10n.<anahtar>`.
2. **Önce ARB, sonra kullanım.** ARB değişince `bash tool/codegen.sh`; üretilen `lib/l10n/app_localizations*.dart` commit edilmez (D-18).
3. **Anahtar adı** camelCase ve bölüm önekli: `heroTitle`, `projectsSearchHint`, `eventsUpcomingEmpty`. Dosyadaki mevcut anahtarların kalıbını izle; bağlam `@anahtar.description` içine yazılır.
4. **Parametre / çoğul ICU:** `{count, plural, =0{…} one{…} other{…}}`; yer tutucular `@anahtar.placeholders` ile tipli. **String birleştirme yok.**
5. **Tarih / saat / sayı** `intl` ile, yerel ayar `tr`; elle biçimlendirme yok.
6. **Türkçe büyük / küçük harf:** `İ ı I i` yüzünden `toUpperCase()` / `toLowerCase()` doğrudan kullanılmaz; Türkçe duyarlı yardımcı `lib/product/extension/string_x.dart`'ta durur (yoksa oraya eklenir). Projeler bölümündeki arama eşleşmesi bununla yapılır. Büyük harfli üst etiket gibi metinleri kodda çevirmek yerine ARB'ye istenen biçimde yaz.
7. **İçerik bizimdir:** referans sitenin metinleri ARB'ye kopyalanmaz (`CLAUDE.md §12`). Kesinleşmemiş içerik (kulüp adı gibi) için `docs/decisions.md` → "Açık konular".
8. **URL ve e-posta ARB'ye girmez** → `AppConstants` (HC18).
9. **Veri metni ARB'ye girmez:** proje adı, etkinlik açıklaması, üye adı `tf_data` modelinden gelir (arayüz fazında `assets/mock/*.json`).
10. **Erişilebilirlik etiketleri de ARB'de:** `Semantics` etiketi, `tooltip`, ipucu metni.

## Yeni metin ekleme

```jsonc
// lib/l10n/app_tr.arb
"eventsUpcomingEmpty": "Yaklaşan etkinlik yok",
"@eventsUpcomingEmpty": { "description": "Etkinlikler bölümü, yaklaşanlar listesi boşken" },

"galleryCounter": "{current} / {total}",
"@galleryCounter": {
  "description": "Görsel penceresindeki sayaç",
  "placeholders": { "current": { "type": "int" }, "total": { "type": "int" } }
}
```

Sonra `bash tool/codegen.sh` → `context.l10n.eventsUpcomingEmpty`, `context.l10n.galleryCounter(1, 7)`.

**ICU tuzakları:** plural dal metni (`=0{bugün}`) yer tutucu değildir, `placeholders`'a yazılmaz; plural sayacı `int` / `num` tipindedir; `l10n.yaml`'da `use-escaping` açıksa `'{q}'` tırnak içinde **literaldir** — düz tırnak için `''` yaz (ya da tipografik “ ” kullan).

## Test

Metin doğrulaması literal kopyalayarak değil üretilen `AppLocalizations` üzerinden · çoğul biçimleri (0 / 1 / n) · parametreli metinler · Türkçe harf dönüşümü (`ISPARTA → ısparta`, `İSTANBUL → istanbul`, `istanbul → İSTANBUL`) · uzun metinle 320 px'te taşma (`tf-testing`).
