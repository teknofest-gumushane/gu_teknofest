---
name: tf-testing
description: Bu projede test yazma rehberi (widget, bölüm ve ekran, 320 / 768 / 1024 / 1440 genişlik denemesi, view model, state, model ve repository, yönlendirme, l10n). Test eklerken, testi düzeltirken ya da "test yaz" istendiğinde kullan.
---

# tf-testing

Kurallar `CLAUDE.md §10` (ayrıca `§2` ve `§3`'ün test maddeleri). Yardımcılar `test/helpers/`: `pumpApp` (tema + dil + `ProviderScope`), `TfTestSizes`. Fake'ler `test/fakes/`.

## İlkeler

- Davranışı test et (görünen metin, durum, kaydırma, açılan pencere); özel alanı değil.
- **Mock kütüphanesi yok** (`docs/packages.md` → "Bilinçli olarak yok"). El yazımı fake gerçek arayüzü uygular, bellekte tutar, hata döndürmeye ayarlanabilir.
- GetIt her testte sıfırlanır ve fake'ler kaydedilir (`CLAUDE.md §3`).
- Ekranı elle `MaterialApp` kurarak değil `pumpApp` ile aç.
- Metin doğrulaması ARB üzerinden (üretilen `AppLocalizations`); metni teste kopyalama.
- Zaman `AppClock` ile enjekte edilir; gerçek zaman, gerçek ağ, bekleme (`sleep`) yok. Ağ görseli testte gerçek istek atmaz.
- Sonsuz animasyonda (bekleme simgesi) `pumpAndSettle` yok → `tester.pump(TfMotion.base)`.
- `skip:` yok; kırık testi silme, düzelt.
- Golden testi zorunlu değildir; belgeler istemedikçe ekleme.

## Hangi test, nerede

Yerleşim: `lib/x/y.dart → test/x/y_test.dart` (`test/core/`, `test/product/`, `test/features/`); paket için `packages/tf_data/lib/src/x/y.dart → packages/tf_data/test/x/y_test.dart`.

| Hedef | Test |
|---|---|
| Model (`tf_data`) | JSON gidiş-dönüş, `copyWith`, eşitlik, `BaseFields` |
| Repository / servis (`tf_data`) | `FirebaseResult`'ın iki dalı, soft delete alanları, silinen kayıt listede yok (`tf-soft-delete`) |
| State | `props` ve `copyWith` **her alanı** içeriyor (alan başına assert) |
| View model | `ProviderContainer` + fake repository: başlangıç, her mutasyon, hata → `isError`, art arda tetik |
| Ortak widget (`lib/product/widget`) | tüm durumlar + `Semantics` + klavye / odak + 320 px taşma |
| Bölüm / ekran | dört genişlik + dört durum (hata, yükleniyor, boş, dolu) + her etkileşimin sonucu |
| Açılır pencere | içerik, kapanma yolları (kapat düğmesi, Esc), ileri / geri, sayaç |
| Yönlendirme | bilinmeyen adres → `NotFoundView`, `redirect`, menü → bölüme kaydırma (`tf-navigation`) |

## Genişlik denemesi

320 / 768 / 1024 / 1440 px (`TfTestSizes`); **taşma = hata**. Bakılacaklar: 320'de tek sütun ve taşma yok · 768'de iki sütun, hamburger menü · 1024'te üç sütun, üst barda linkler · 1440'ta içerik `TfSizes.contentMaxWidth`'i aşmıyor (`tf-responsive`).

## Bölüm testi iskeleti

İmzalar için `test/helpers/` dosyalarını oku; aşağısı kalıbı gösterir.

```dart
void main() {
  group('ProjectsSection', () {
    late FakeProjectRepository repository;
    setUp(() { /* GetIt sıfırla, fake'i kaydet */ });

    for (final size in TfTestSizes.all) {
      testWidgets('taşma yok — $size', (tester) async {
        await tester.pumpApp(const ProjectsSection(), size: size);
        expect(tester.takeException(), isNull);
      });
    }
    testWidgets('hata → hata mesajı görünür', (tester) async { /* repository hata döner */ });
    testWidgets('boş liste → boş durum metni', (tester) async { /* … */ });
    testWidgets('etiket seçilince liste süzülür', (tester) async { /* … */ });
  });
}
```

## Bitmeden

Eksik test = iş bitmez (her view model ve state için test zorunlu, `CLAUDE.md §2`). Ara kontrol `bash tool/quality_gate.sh --fast`, commit öncesi tam kapı (`tf-quality-gate`). Boşlukları `tf-test-auditor` ajanı listeler.
