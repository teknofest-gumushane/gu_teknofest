---
name: tf-feature
description: Bir feature dilimini (view model → state → view; veri yerel paket tf_data'dan) projenin katman, isimlendirme ve DI kurallarıyla kurar. Yeni feature klasörü, view model/state, repository arayüzü ya da sahte (mock) repository eklerken kullan.
---

# tf-feature — feature dilimi

Kurallar `CLAUDE.md §1–§4` ve `§9`'da; burası uygulama sırası ve yerleşimdir. Yapının nedeni: `docs/architecture.md §1–§3`.

## Dizin

```
lib/features/<feature>/              # landing | auth | admin (D-03)
  provider/  <x>_view_model.dart  <x>_state.dart      # (+ .g.dart üretilir, commit edilmez — D-18)
  view/      <x>_view.dart
             mixin/    <x>_view_mixin.dart            # ekran mantığı (kaydırma, form, odak…)
             section/  <x>_section.dart               # genel sayfanın bölümleri
             widget/   …                              # yalnızca bu feature'a özgü parçalar
packages/tf_data/lib/src/{models,repositories,services}/
test/features/<feature>/…   test/fakes/…   packages/tf_data/test/…
```

Feature'lar birbirini import etmez; ortak olan `lib/product/`'a çıkar. Yeni bir feature (yüz) açmak D-03'ü değiştirir → önce `tf-ask-user`.

## Sıra

1. **Model** (yoksa): `packages/tf_data/lib/src/models/<x>_model.dart` — `Equatable` + `json_serializable`, `BaseFields`; alanlar `docs/analiz.md §4`, JSON anahtarları `FirestoreFields` sabitlerinden. Test: JSON gidiş-dönüş.
2. **Repository arayüzü**: `…/repositories/<alan>_repository.dart` — her metot `FirebaseResult` döner, istisna fırlatmaz; **`delete*` yok** (`tf-soft-delete`). Arayüz Firebase SDK import etmez (B08). Dışa açılan her tip `tf_data.dart`'a eklenir.
3. **Sahte uygulama**: `mock_<alan>_repository.dart`, `assets/mock/<alan>.json` okur (D-01). `firebase_<alan>_repository` **şimdi yazılmaz** (backend fazı, D-26).
4. **DI kaydı**: `lib/core/di/project_dependency.dart` + `ProjectDependencyMixin`'e erişimci. Hangi uygulamanın kaydedileceğine `AppEnvironment` bakar; ekran bunu bilmez.
5. **Fake**: `test/fakes/fake_<alan>_repository.dart` — gerçek arayüzü uygular, bellekte tutar, hata döndürmeye ayarlanabilir. Mock kütüphanesi yok.
6. **State**: `final class XState extends Equatable`; tüm alanlar `props` ve `copyWith`'te; varsayılanlar `const`.
7. **View model**: `@riverpod final class XViewModel extends _$XViewModel with ProjectDependencyMixin`; mutasyon yalnızca `state = state.copyWith(...)`; `switch` ile `FirebaseSuccess` / `FirebaseFailure`; hata → `isError` (kalıp: `CLAUDE.md §2`).
8. **View**: `ConsumerStatefulWidget` / `ConsumerWidget`; koşullu render **hata → yükleniyor → boş → dolu**; metin `context.l10n.*`, stil yalnızca token (`CLAUDE.md §6`).
9. **Bağlama**: genel sayfa bölümü ise `tf-section-from-site`; yeni adres ise `tf-navigation`.
10. **Üret + test**: `bash tool/codegen.sh`; state, view model ve view testleri (`tf-testing`); `bash tool/quality_gate.sh --fast`.

## Hızlı kontrol

- View model yalnızca `package:tf_data/tf_data.dart` import ediyor; `src/` yolu (B09) ve Firestore SDK tipi (`DocumentSnapshot`, `Timestamp`) yok.
- Feature → feature import yok (B05); `lib/features` Firebase SDK import etmiyor (B04); göreli import yok.
- View/widget dosyasında `GetIt` yok (HC13); feature view'ında düz `StatefulWidget` yok (HC14).
- Art arda tetiklemeye karşı `isFetching` koruması var.
- Hata ve boş durum için ARB metni var (`tf-l10n`); istisna yutulmuyor.
- "Şu an" gerekiyorsa `AppClock`'tan (tf_data); testte sahte saat.
- Ekran ve view model hangi uygulamanın (sahte / Firebase) çalıştığını bilmiyor (D-26).
- Listede olmayan paket gerekiyorsa dur → `docs/packages.md` + `tf-ask-user`.
