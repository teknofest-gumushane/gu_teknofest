# Token Eşlemesi

Arayüzdeki her renk, boşluk, ölçü ve süre bir token'dır; ekran koduna sayı ya da renk yazılmaz
(`CLAUDE.md` §6). Değerlerin kaynağı referans sitenin analizidir ([`analiz.md`](analiz.md) §5).
Token'lar `lib/product/theme/` içinde tanımlıdır. Yeni token eklerken bu tabloyu da güncelle.

## Renkler — `context.tf.colors.*` (`TfColors`)

| Token | Değer | Kullanım |
|---|---|---|
| `brandPurple` | `#682D8B` | Üst bar, alt bilgi, gradyan başlangıcı |
| `primary` | `#2F97C1` | Butonlar, linkler, etiketler, odak çerçevesi |
| `deep` | `#1B3C73` | Başlıklar, koyu metin, gradyan bitişi |
| `accent` | `#F47A1F` | Bölüm üst etiketleri, üzerine gelme, rozetler |
| `surface` | `#F8F9FA` | Sayfa arka planı |
| `card` | `#FFFFFF` | Kartlar, pencereler, çekmece |
| `text` | `#0F172A` | Gövde metni |
| `textMuted` | `#1B3C73` %70 | İkincil metin |
| `textSubtle` | `#1B3C73` %60 | Açıklama, ipucu |
| `onBrand` | `#FFFFFF` | Mor / gradyan üstündeki metin |
| `onBrandMuted` | `#FFFFFF` %80 | Mor üstünde ikincil metin, menü linkleri |
| `headerBackground` | `#682D8B` %95 | Yapışkan üst bar |
| `border` | `#2F97C1` %20 | Kart ve alan kenarlıkları |
| `divider` | `#E2E8F0` | Ayırıcı çizgiler |
| `glass` | `#FFFFFF` %10 | Mor üstündeki yarı saydam yüzeyler |
| `glassBorder` | `#FFFFFF` %30 | Bunların kenarlığı |
| `scrim` | `#0F172A` %80 | Pencere ve çekmece arkası karartma |
| `shadow` | `#2B4F87` %35 | Yumuşak gölge rengi |
| `danger` | `#DC2626` | Hata durumu |
| `success` | `#16A34A` | Başarı durumu |

Hero gradyanı: `TfGradients.hero` — sol üstten sağ alta `brandPurple → primary → deep`.

## Boşluk — `TfSpacing.*`

| Token | Değer | | Token | Değer |
|---|---|---|---|---|
| `s2` | 2 | | `s24` | 24 |
| `s4` | 4 | | `s32` | 32 |
| `s8` | 8 | | `s40` | 40 |
| `s12` | 12 | | `s48` | 48 |
| `s16` | 16 | | `s64` | 64 |
| `s20` | 20 | | `s80` | 80 |
| | | | `s96` | 96 |

Hazır boşluk widget'ları: `TfGap.h8`, `TfGap.w16` gibi (`SizedBox` yerine).
Sayfa kenar boşluğu: mobil `s16`, tablet `s24`, masaüstü `s32`. Bölüm dikey boşluğu: mobil `s80`, diğer `s96`.

## Köşe — `TfRadius.*`

| Token | Değer | Kullanım |
|---|---|---|
| `sm` | 8 | Küçük etiketler |
| `md` | 12 | Alanlar, küçük kartlar |
| `lg` | 16 | Kartlar |
| `xl` | 24 | Büyük kartlar, pencereler, görseller |
| `pill` | 999 | Butonlar, etiketler |

## Ölçü — `TfSizes.*`

| Token | Değer | Kullanım |
|---|---|---|
| `contentMaxWidth` | 1152 | İçerik en fazla genişliği |
| `headerLogoLarge` | 72 | Üst bar logosu, sayfa başında |
| `headerLogoSmall` | 44 | Üst bar logosu, kaydırınca |
| `notFoundLogo` | 160 | Bulunamadı sayfasındaki logo |
| `logoPlateContentFactor` | 0.72 | Beyaz daire zeminli logoda görselin daireye oranı |
| `tapTarget` | 44 | En küçük dokunma alanı, ikon butonlar |
| `iconSm` / `iconMd` / `iconLg` | 16 / 20 / 24 | İkon boyutları |
| `drawerWidth` | 320 | Çekmece menü genişliği |
| `borderThin` | 1 | Kenarlık kalınlığı |
| `focusRing` | 2 | Odak çerçevesi kalınlığı |

## Yazı — `context.tf.text.*` (`TfTypography`)

Yazı tipi Inter (gömülü). Ağırlıklar: 400, 500, 600.

| Token | Boyut / satır | Ağırlık | Kullanım |
|---|---|---|---|
| `display` | 60 / 64 (tablet 48 / 52, mobil 36 / 40) | 600 | Ana başlık |
| `headline` | 36 / 44 (mobil 30 / 38) | 600 | Bölüm başlığı |
| `title` | 20 / 28 | 600 | Kart başlığı, marka adı |
| `bodyLarge` | 18 / 28 | 400 | Giriş metni |
| `body` | 16 / 26 | 400 | Gövde |
| `bodySmall` | 14 / 22 | 400 | İkincil metin |
| `label` | 14 / 20 | 600 | Buton, menü linki |
| `eyebrow` | 13 / 18, harf aralığı 2.6 | 600 | Bölüm üst etiketi (büyük harf) |
| `caption` | 12 / 16 | 500 | Küçük not |

Referans sitede ana başlık 700 ağırlığındadır; Inter Bold dosyası eklenene kadar 600 kullanılır
(`decisions.md` → Açık konular).

## Gölge — `TfShadows.*`

| Token | Değer |
|---|---|
| `soft` | `0 20 45 -20`, renk `shadow` |
| `header` | `0 4 16 -8`, renk `shadow` |

## Hareket — `TfMotion.*`

| Token | Değer | Kullanım |
|---|---|---|
| `fast` | 150 ms | Üzerine gelme, renk geçişi |
| `base` | 300 ms | Üst bar küçülmesi, çekmece |
| `slow` | 600 ms | Kartların aşağıdan belirmesi |
| `scroll` | 500 ms | Menüden bölüme kaydırma |
| `standard` | `easeOutCubic` | Varsayılan eğri |
| `emphasized` | `easeInOutCubic` | Kaydırma |

## Kırılma noktaları — `TfBreakpoints.*`

| Token | Değer |
|---|---|
| `tablet` | 640 |
| `tabletLarge` | 768 |
| `desktop` | 1024 |
