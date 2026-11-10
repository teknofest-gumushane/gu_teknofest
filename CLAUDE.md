# CLAUDE.md — GÜ Teknofest

> Bu dosya projede iş yapan herkes (ve Claude) için **tek doğru kaynaktır**. `.claude/skills/*` ve
> `.claude/agents/*` bu dosyaya referans verir, kuralları tekrar etmez.
> Kilitli kararlar: [`docs/decisions.md`](docs/decisions.md). Mimari ayrıntı: [`docs/architecture.md`](docs/architecture.md).

**Proje:** Gümüşhane Üniversitesi Teknofest Kulübü web sitesi. Flutter web + Firebase, yalnız Türkçe.
**Referans:** özellik ve düzen olarak [mauteknofest.com](https://mauteknofest.com); ne yapılacağı
[`docs/analiz.md`](docs/analiz.md) içinde. İçerik (logo, metin, fotoğraf, ekip) bize aittir, oradan kopyalanmaz.
**Durum:** önce arayüz sahte veriyle yazılır; Firebase bağlantısı arayüz bitince yapılır (D-01).

---

## 0. Çalışma protokolü (her oturumun başında oku)

1. **Plan → onay → uygulama.** Birkaç adımlı her işte önce numaralı planı göster ve dur. Kullanıcı
   onaylamadan dosyaya ya da git'e dokunma (D-25).
2. **Belirsizlik = soru.** Tahmin etme. Seçenekli sorular `AskUserQuestion` açılır penceresiyle sorulur
   (`.claude/skills/tf-ask-user`). Düz metinle seçenekli soru sorma.
3. **Sapma yok.** Kilitli karar (D-xx) ve `docs/*` sözleşmeleri değişmez. Değiştirmek istiyorsan önce sor;
   onaylanırsa `docs/decisions.md`'ye işle (`tf-decision-log`).
4. **Kapı yeşil değilse commit yok:** `bash tool/quality_gate.sh` (§11).
5. **Akış: issue → dal → PR** (D-27; `tf-issue`, `tf-branch`, `tf-pr`). `main`'e doğrudan commit yalnızca proje sahibinin
   açık talimatıyla (D-19). Commit, push, issue ve PR yalnızca kullanıcı isteyince; birleştirmeyi Claude kendiliğinden yapmaz.
6. Kullanıcıya **Türkçe** yaz. Kısa ol: ne yaptın, sonuç, sıradaki adım.

---

## 1. Mimari

**Feature-first + paylaşılan `product/` katmanı + bir yerel paket.** Ayrıntı: `docs/architecture.md`.

```
repo/
├── pubspec.yaml                 # uygulama + workspace: [packages/tf_data]
├── packages/tf_data/            # modeller, FirebaseResult, servisler, repository'ler, soft delete
├── lib/
│   ├── main.dart
│   ├── core/                    # bootstrap, DI, env, hata/log, oturum, sabitler
│   ├── product/                 # theme (token), icon, navigation, widget, responsive, mixin, extension
│   ├── features/<feature>/      # provider/ + view/ (mixin/, section/, widget/)
│   └── l10n/                    # app_tr.arb (+ üretilen)
├── assets/                      # fonts, images, icons, mock
├── test/  tool/  docs/
```

Feature'lar yüz bazlıdır (D-03): `landing` (genel sayfa), `auth` (admin girişi), `admin` (panel).

**Katman kuralı (tek yön):** `view → view model → repository (arayüz: tf_data) → service → Firebase SDK`.

- `tf_data` Flutter widget'ı içermez. View model Firestore SDK tiplerini görmez.
- Feature'lar birbirini import etmez; ortak olan `product/`'a çıkar.
- `lib/core` ve `lib/product` feature import etmez. İstisna kompozisyon köküdür: `lib/main.dart`,
  `lib/core/bootstrap/*`, `lib/core/di/project_dependency.dart`, `lib/core/env/app_environment.dart`,
  `lib/product/navigation/*`.
- Firebase SDK yalnızca `tf_data` içinden import edilir. Paket dışından `package:tf_data/src/…` yasak;
  yalnızca `package:tf_data/tf_data.dart`.
- Göreli import yok; her zaman `package:` yolu.

Bu kuralları `tool/check_boundaries.sh` denetler.

İsimlendirme: `*_view_model.dart`, `*_state.dart`, `*_view.dart`, `*_section.dart`, `*_mixin.dart`,
`*_model.dart`, `*_repository.dart`, `*_service.dart`. Sınıflar `XViewModel`, `XState`, `XView`, `XModel`.

---

## 2. State — Riverpod `@riverpod` Notifier (Freezed yok, AsyncValue yok)

```dart
part 'projects_view_model.g.dart';

@riverpod
final class ProjectsViewModel extends _$ProjectsViewModel with ProjectDependencyMixin {
  @override
  ProjectsState build() => const ProjectsState();

  Future<void> fetch() async {
    state = state.copyWith(isFetching: true, isError: false);
    final result = await projectRepository.fetchProjects();
    state = switch (result) {
      FirebaseSuccess(:final data) => state.copyWith(projects: data, isFetching: false),
      FirebaseFailure() => state.copyWith(isFetching: false, isError: true),
    };
  }
}

final class ProjectsState extends Equatable {
  const ProjectsState({this.projects = const [], this.isFetching = false, this.isError = false});
  final List<ProjectModel> projects;
  final bool isFetching;
  final bool isError;
  @override
  List<Object?> get props => [projects, isFetching, isError];
  ProjectsState copyWith({List<ProjectModel>? projects, bool? isFetching, bool? isError}) =>
      ProjectsState(
        projects: projects ?? this.projects,
        isFetching: isFetching ?? this.isFetching,
        isError: isError ?? this.isError,
      );
}
```

- Mutasyon **daima** `state = state.copyWith(...)`.
- İstisnayı yutma; `isError` bayrağına çevir. `props` ve `copyWith` **tüm alanları** içerir.
- Her view model ve state için test zorunlu.

## 3. DI — GetIt + Riverpod

- Servis ve repository'ler GetIt'te: `lib/core/di/project_dependency.dart`. Hangi uygulamanın (sahte ya da
  Firebase) kaydedileceğini `AppEnvironment` belirler; ekran kodu bunu bilmez.
- View model içinde `ProjectDependencyMixin` (`projectRepository`, `eventRepository`, …).
- **View/widget dosyasında `GetIt` yasak.** Widget'ta ortak state için `AppProviderMixin`.
- Testte GetIt sıfırlanır, el yazımı fake'ler kaydedilir (`test/fakes/`). Mock kütüphanesi yok.

## 4. View

- `ConsumerStatefulWidget` / `ConsumerWidget`. İş mantığı view model ya da view mixin'inde.
- Koşullu render sırası: **hata → yükleniyor → boş → dolu**.
- Genel sayfanın her bölümü `TfSectionFrame` içinde başlar (üst etiket, başlık, alt metin, içerik).
- Responsive: `context.isMobile / isTablet / isDesktop` ve `TfBreakpoints`; sabit genişlik yok.
  İçerik en fazla `TfSizes.contentMaxWidth` genişliğindedir. 320 px'te taşma sıfır.

## 5. Yönlendirme

- `@TypedGoRoute` + `GoRouteData`; üretilen `*.g.dart` commit edilmez. Rotalar `lib/product/navigation/`.
- Temiz adresler (`usePathUrlStrategy`). Zorunlu kimlikler path parametresidir.
- Yetki yönlendirmesi router'da (`redirect`); view'dan auth kararı verilmez.
- `/admin` altı gecikmeli yüklenir (D-04).
- Genel sayfa tek sayfadır: menü öğeleri rota değiştirmez, ilgili bölüme kaydırır.

## 6. Stil — sert kurallar (`tool/check_hardcode.sh` reddeder)

| Yasak | Yerine |
|---|---|
| `Color(0x…)`, `Colors.red` (tema dosyaları hariç) | `context.tf.colors.*` |
| `Theme.of(context)` doğrudan | `context.tf.*` |
| `EdgeInsets.all(12)`, `SizedBox(height: 8)` sayısal | `TfSpacing.*` / `TfGap.*` / `TfInsets.*` |
| `BorderRadius.circular(12)` | `TfRadius.*` |
| `TextStyle(fontSize: …)`, `FontWeight.*` view'da | `context.tf.text.*` |
| `Duration(milliseconds: 200)`, `Curves.*` view'da | `TfMotion.*` |
| `width: 44`, `size: 24` gibi sayısal ölçü | `TfSizes.*` |
| `Text('Projeler')`, UI metni | `context.l10n.*` (ARB) |
| `Icons.*` doğrudan | `TfIcons.*` (D-11) |
| `print(`, `debugPrint(` (logger dışında) | `AppLogger` |
| `Navigator.push` | go_router |
| `.withOpacity(0.5)` | renk token'ı |
| URL ve e-posta sabiti | `AppConstants` |
| Düz `StatefulWidget` feature view'larında | `ConsumerStatefulWidget` |

- Eksik token gerekiyorsa **çağrı yerine değil, token katmanına** eklenir ve `docs/token-map.md` güncellenir.
- Satır içi istisna: `// ignore-hardcode: <gerekçe>` (gerekçe zorunlu).
- Serbest bölgeler: `lib/product/theme/`, `lib/product/icon/`, `lib/core/constants/`, `lib/core/error/`.

## 7. Widget'lar

- Önce `lib/product/widget/`'a bak; varsa onu kullan. Yeni ortak widget oraya eklenir.
- Her widget: tüm durumlar (varsayılan, üzerine gelme, odak, devre dışı, yükleniyor), `Semantics` etiketi, test.
- Web'de klavye ile gezilebilirlik ve görünür odak çerçevesi zorunlu.

## 8. Yerelleştirme

- `context.l10n.<anahtar>`. Yalnız `lib/l10n/app_tr.arb` (D-09). Yeni metin: önce ARB'ye, sonra kullanım.
- Çoğul ve parametre ICU ile; string birleştirme yok. Tarih ve sayı `intl` ile.
- ARB değişince: `bash tool/codegen.sh`.

## 9. Veri

- Servis erişimi yalnızca `tf_data` içinden; sonuç tipi `FirebaseResult`.
- **Soft delete (D-10):** silinen = `isDeleted: true` + `deletedAt` + `deletedBy`. Okuma sorguları
  `isDeleted == false` süzer. `.delete(` çağrısı ve `delete*` adlı metot yok (`tool/check_no_hard_delete.sh`).
- Arayüz fazında repository'lerin `mock_*` uygulamaları `assets/mock/*.json` okur.
- Yetki arayüzde gizlemekle değil, güvenlik kurallarında sağlanır (backend fazı).
- Gerçek projeye yazan komut (`firebase deploy` dahil) **kullanıcı onayı olmadan çalıştırılmaz**.

## 10. Test

- Widget → widget testi. View model → `ProviderContainer` + fake repository. Model/repository → birim test.
- Ekranlar 320 / 768 / 1024 / 1440 genişliklerinde denenir; taşma = hata (`test/helpers/`).
- Yardımcılar: `pumpApp` (tema + dil + `ProviderScope`), `TfTestSizes`.

## 11. Kalite kapısı ve commit

```
bash tool/quality_gate.sh            # tam kapı (commit öncesi şart)
bash tool/quality_gate.sh --fast     # ara kontrol
bash tool/quality_gate.sh --static   # yalnızca statik
```

format → codegen → analyze (`--fatal-infos`) → araç öz-testi → sınırlar → hardcode → hard-delete → test.
Tüm betikler: [`tool/README.md`](tool/README.md).

- Commit ve PR başlığı: Conventional Commits, açıklama Türkçe. Üretilen dosyalar commit edilmez (D-18).
- Dal adı `<tür>/<issue-no>-<kısa-ad>`; PR `main`'e, şablonla, `Closes #no` ile; birleştirme squash, CI yeşil + bir onay (D-27).
- Aynı kapı her push ve PR'da CI'de de çalışır (`.github/workflows/ci.yml`).
- Kod üreten bir şey değiştiyse (`@riverpod`, rota, model, ARB): `bash tool/codegen.sh`.

## 12. Yapma listesi

❌ Hard delete · ❌ hardcode · ❌ tekrarlı widget · ❌ view'da `GetIt` · ❌ Freezed / AsyncValue ·
❌ `google_fonts` · ❌ doğrudan `Icons.*` · ❌ listede olmayan paket (önce sor) · ❌ onaysız `firebase deploy` ·
❌ kilitli kararı sormadan değiştirme · ❌ kırmızı kapıyla commit · ❌ `--no-verify` · ❌ üretilen dosyayı commit ·
❌ onaysız uygulama · ❌ düz metinle seçenekli soru · ❌ referans siteden içerik kopyalama · ❌ `git push --force` ·
❌ onaysız issue / PR açma ya da birleştirme · ❌ bir PR'da birden çok issue.

## 13. Dosya haritası

| Ne | Nerede |
|---|---|
| Referans site analizi, veri modeli, renk paleti | `docs/analiz.md` |
| Mimari ve klasör yapısı | `docs/architecture.md` |
| Kilitli kararlar | `docs/decisions.md` |
| İzin verilen paketler | `docs/packages.md` |
| Token eşlemesi (renk, boşluk, yazı) | `docs/token-map.md` |
| Ekip için kurulum ve akış | `CONTRIBUTING.md` |
| Ekip rehberi: mimari, yapay zekâ ile geliştirme, skill ve agent kullanımı | `docs/ekip-rehberi.md` |
| Betikler ve kullanımları | `tool/README.md` |
| Skill, agent, hook | `.claude/skills/*`, `.claude/agents/*`, `.claude/settings.json` |
| Issue ve PR şablonları, CI | `.github/ISSUE_TEMPLATE/*`, `.github/PULL_REQUEST_TEMPLATE.md`, `.github/workflows/ci.yml` |
