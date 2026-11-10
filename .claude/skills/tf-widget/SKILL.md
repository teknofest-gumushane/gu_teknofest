---
name: tf-widget
description: Yeni ya da değişen bir ortak widget (lib/product/widget) yazarken kullan. Önce mevcut widget'ları tarama, tüm durumlar, token kullanımı, Semantics, klavye ve odak, dokunma hedefi, test adımlarını verir.
---

# tf-widget — widget yazma

**Tekrarlı widget yasak** (`CLAUDE.md §7`, `§12`). Kod yazmadan önce `lib/product/widget/`'ı tara (`ls`, `grep`); benzeri varsa onu **genişlet**.

## Karar: nereye?

| Soru | Yer |
|---|---|
| Birden çok bölüm ya da ekran kullanıyor / kullanabilir mi? | `lib/product/widget/tf_<ad>.dart` (sınıf `Tf<Ad>`) |
| Yalnızca tek feature'a özgü, yeniden kullanılmayacak | `lib/features/<f>/view/widget/` |

Ayrı bir arayüz paketi yoktur (D-02). `lib/product` feature import etmez (B07); `tf_data` modellerini alabilir. Token'lar `lib/product/theme/`, ikonlar `lib/product/icon/`.

## Şablon

```dart
final class TfTag extends StatelessWidget {              // örnek iskelet
  const TfTag({required this.label, this.onPressed, this.selected = false, super.key});

  final String label;              // metni çağıran verir (context.l10n.*)
  final VoidCallback? onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final tf = context.tf;         // Theme.of(context) yok
    return Semantics(button: onPressed != null, selected: selected, label: label, child: …);
  }
}
```

## Zorunlu

1. **Tüm durumlar** (`CLAUDE.md §7`): varsayılan · üzerine gelme · odak · devre dışı · yükleniyor — widget için anlamlı olanların hepsi.
2. **Token:** renk `tf.colors.*`, boşluk `TfSpacing` / `TfGap` / `TfInsets`, köşe `TfRadius`, yazı `tf.text.*`, süre ve eğri `TfMotion`, ölçü `TfSizes`, gölge `TfShadows`. Sayı, renk, süre literali yok (`tool/check_hardcode.sh`). Eksik token → `lib/product/theme/` + `docs/token-map.md`.
3. **Klavye ve odak (web):** Tab ile ulaşılır, Enter / Space ile çalışır; görünür odak çerçevesi (`TfSizes.focusRing`); tıklanabilir öğede el imleci; üzerine gelme geçişi `TfMotion.fast`.
4. **Dokunma hedefi** en az `TfSizes.tapTarget`.
5. **Sabit genişlik / yükseklik yok:** en küçük ölçü + `Flexible` / ellipsis; 320 px'te taşma yok (`tf-responsive`).
6. **`Semantics`:** etiket, rol, durum; yalnızca ikon içeren düğmede etiket zorunlu.
7. **Metin yok:** widget metni parametre alır; ARB'yi çağıran bağlar (`tf-l10n`).
8. **İkon:** `TfIcons.*` (D-11); `Icons.*` yok. Ağ görseli: `TfNetworkImage` (D-12).
9. **Hareket:** Flutter yerleşikleri (D-13) + `TfMotion`; `MediaQuery.disableAnimations` açıksa animasyon atlanır.
10. **Test:** `test/product/widget/tf_<ad>_test.dart` — durumlar + `Semantics` + klavye / odak + 320 px taşma (`tf-testing`).

## Yapma

❌ Aynı işi yapan ikinci widget · ❌ `Theme.of(context)` · ❌ `Color(0x…)` · ❌ `EdgeInsets.all(12)` · ❌ `SizedBox(width: 390)` · ❌ widget içinde sabit metin · ❌ widget içinde `GetIt` · ❌ ekran içinde inline özel buton / kart · ❌ feature view'ında düz `StatefulWidget`.
