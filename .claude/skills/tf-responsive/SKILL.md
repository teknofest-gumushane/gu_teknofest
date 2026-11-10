---
name: tf-responsive
description: Responsive düzen kuralları (kırılma noktaları, context.isMobile / isTablet / isDesktop, TfSizes.contentMaxWidth, sabit genişlik yok). Bir bölümün ya da widget'ın düzenini yazarken, sütun sayısı belirlerken, taşma (overflow) hatası çıktığında ya da 320 / 768 / 1024 / 1440 denemesi yaparken kullan.
---

# tf-responsive

Kurallar `CLAUDE.md §4`; tablo `docs/architecture.md §5`; değerler `docs/token-map.md` → "Kırılma noktaları". Kaynak: `lib/product/theme/tf_breakpoints.dart`, `lib/product/extension/build_context_responsive_x.dart`.

## Kırılma noktaları

| Ad | Genişlik | Ekran kodunda | Sütun | Menü | Sayfa kenar boşluğu |
|---|---|---|---|---|---|
| mobil | < 640 px | `context.isMobile` | 1 | hamburger + çekmece | `TfSpacing.s16` |
| tablet | 640 – 1023 px | `context.isTablet` | 2 | hamburger + çekmece | `TfSpacing.s24` |
| masaüstü | ≥ 1024 px | `context.isDesktop` | 3 | üst barda linkler | `TfSpacing.s32` |

Token'lar: `TfBreakpoints.tablet` (640), `tabletLarge` (768), `desktop` (1024). Bölüm dikey boşluğu: mobil `TfSpacing.s80`, diğerleri `s96`. `display` ve `headline` yazı stilleri genişliğe göre küçülür (`docs/token-map.md` → Yazı).

## Kurallar

1. **Ekran kodu `context.isMobile / isTablet / isDesktop` kullanır.** `MediaQuery…width < 640` gibi sayıyla karşılaştırma yok. Yeni eşik gerekiyorsa `TfBreakpoints`'e eklenir ve `docs/token-map.md` güncellenir.
2. **Sabit genişlik yok:** `width: 390`, `SizedBox(width: 600)` yazılmaz (HC15). Esnek kur: `Expanded`, `Flexible`, `Wrap`, `LayoutBuilder`, en fazla genişlik kısıtı.
3. **İçerik en fazla `TfSizes.contentMaxWidth` (1152)** ve ortalı: `TfMaxWidthBox` (bölüm çerçevesi `TfSectionFrame` bunu zaten yapıyorsa ikinci kez sarmalama). Arka plan (gradyan, mor bant) tam genişlikte kalabilir; sınırlanan **içeriktir**.
4. **320 px'te taşma sıfır.** Uzun metin `Flexible` + `maxLines` / `TextOverflow.ellipsis` ya da sarma; yan yana düğmeler dar ekranda `Wrap` ile alt alta iner.
5. **Sabit yükseklik yok:** metin içeren kutuda en küçük ölçü; görselde `AspectRatio`.
6. **Izgara:** sütun sayısı kırılma noktasından (1 / 2 / 3), aralıklar `TfSpacing`'ten. Kart genişliği elle hesaplanmaz; düzen (`LayoutBuilder`, grid) belirler.
7. **Dokunma hedefi** her genişlikte en az `TfSizes.tapTarget`.
8. Çekmece genişliği `TfSizes.drawerWidth`; üst bar logosu `TfSizes.headerLogoLarge` → kaydırınca `headerLogoSmall` (`TfMotion.base`).

## Kalıp

```dart
final columns = context.isDesktop ? 3 : (context.isTablet ? 2 : 1);
final gutter = context.isMobile
    ? TfSpacing.s16
    : (context.isTablet ? TfSpacing.s24 : TfSpacing.s32);
```

Aynı seçim ikinci kez gerekiyorsa kopyalama; `build_context_responsive_x.dart`'a ya da ortak bir widget'a taşı (`tf-widget`).

## Taşma hatası çıktıysa

1. Hangi genişlikte? Testte dört genişliği tek tek dene (`TfTestSizes`).
2. `Row` içindeki metin `Expanded` / `Flexible` içinde mi?
3. Sayısal `width` / `height` ya da sabit oranlı kutu var mı?
4. Yatay boşluk mobil için `s16`'ya iniyor mu?
5. Düğme ve etiket sıraları `Wrap` mı?
6. Yazıyı token dışı küçültmek çözüm değildir; düzeni değiştir.

## Test

Her bölüm ve ortak widget 320 / 768 / 1024 / 1440 px'te denenir; taşma = hata (`CLAUDE.md §10`, `tf-testing`). Sütun sayısı ya da menü biçimi değişen yerde sınırın iki yanına da bakmak yararlıdır (639 ↔ 640, 1023 ↔ 1024).
