# Mimari

Kuralların kısa hali [`CLAUDE.md`](../CLAUDE.md) içindedir; bu belge yapıyı ve nedenlerini açıklar.
Kararların kaynağı: [`decisions.md`](decisions.md).

## 1. Katmanlar

```
features/  ──►  product/  ──►  core/  ──►  tf_data
    │                                        ▲
    └────────────────────────────────────────┘
```

Ok "import eder" demektir. Tersi yasaktır.

| Katman | Ne içerir | Neyi import edebilir |
|---|---|---|
| `lib/features/<f>/` | Bir yüzün ekranları ve view model'leri | `product`, `core`, `tf_data` |
| `lib/product/` | Tema token'ları, ikonlar, yönlendirme, ortak widget'lar, extension ve mixin'ler | `core`, `tf_data` |
| `lib/core/` | Başlatma, DI, ortam, hata/log, oturum, sabitler | `tf_data` |
| `packages/tf_data/` | Modeller, sonuç ve hata tipleri, servisler, repository'ler | yalnızca Firebase SDK ve Dart |

**Kompozisyon kökü** bu kuralın bilinçli istisnasıdır; parçaları birbirine bağlayan yer burasıdır:
`lib/main.dart`, `lib/core/bootstrap/*`, `lib/core/di/project_dependency.dart`,
`lib/core/env/app_environment.dart`, `lib/product/navigation/*`.

## 2. Klasör yapısı

```
gu_teknofest/
├── CLAUDE.md  CONTRIBUTING.md
├── .claude/                      settings.json, launch.json, skills/, agents/
├── .github/                      workflows/ci.yml, ISSUE_TEMPLATE/ (görev, hata, öneri), PULL_REQUEST_TEMPLATE.md
├── docs/                         analiz, architecture, decisions, packages, token-map
├── tool/                         betikler (tool/README.md)
├── assets/
│   ├── README.md                 logo ve yazı tipi notları
│   ├── fonts/                    Inter (400, 500, 600)
│   ├── images/                   logo.png
│   ├── icons/                    SVG ikonlar (ilk SVG ikonla birlikte oluşturulur)
│   └── mock/                     club_info.json, projects.json, events.json, members.json, gallery.json
├── packages/tf_data/
│   └── lib/
│       ├── tf_data.dart          dışa açılan tek dosya
│       └── src/
│           ├── constants/        koleksiyon, alan, depolama yolu, limit, önbellek
│           ├── core/             FirebaseResult, hata sözlükleri, sayfalama, önbellek, saat, soft delete
│           ├── models/           club_info, project, event, event_image, member, gallery_item, join_application
│           ├── repositories/     <alan>_repository (arayüz), mock_<alan>_repository, firebase_<alan>_repository
│           ├── services/         firestore, auth, storage
│           └── utils/            json_converters, retry_policy, login_throttle
├── lib/
│   ├── main.dart
│   ├── core/
│   │   ├── bootstrap/            app_bootstrap.dart, tf_app.dart
│   │   ├── constants/            app_constants.dart, app_durations.dart
│   │   ├── di/                   project_dependency.dart, project_dependency_mixin.dart, app_provider_mixin.dart
│   │   ├── env/                  app_environment.dart
│   │   ├── error/                app_logger.dart, app_error_handler.dart
│   │   └── session/              session_view_model.dart, session_state.dart
│   ├── product/
│   │   ├── theme/                tf_colors, tf_spacing, tf_radius, tf_sizes, tf_typography, tf_shadows,
│   │   │                         tf_gradients, tf_motion, tf_breakpoints, tf_theme, tf_theme_extension
│   │   ├── icon/                 tf_icons.dart, tf_icon.dart
│   │   ├── extension/            build_context_x, build_context_l10n_x, build_context_responsive_x, string_x
│   │   ├── form/                 form_field_error.dart
│   │   ├── mixin/                external_link_mixin, form_validation_mixin
│   │   ├── navigation/           app_router.dart, not_found_view.dart, routes/app_routes.dart
│   │   └── widget/               tf_section_frame, tf_coming_soon, tf_button, tf_logo, tf_max_width_box
│   ├── features/
│   │   ├── landing/
│   │   │   ├── provider/         bölüm başına view_model + state (bölümler yazıldıkça)
│   │   │   └── view/             landing_view.dart, landing_section_id.dart, mixin/, section/, widget/
│   │   ├── auth/                 (sonraki tur)
│   │   └── admin/                (sonraki tur; gecikmeli yüklenir)
│   └── l10n/                     app_tr.arb
└── test/                         flutter_test_config.dart, helpers/, fakes/, core/, product/,
                                  features/, data/
```

## 3. Veri akışı

```
view ──watch──► view model ──► repository arayüzü ──► mock_*   (assets/mock/*.json)        arayüz fazı
                                                  └─► firebase_* ──► service ──► Firebase   backend fazı
```

- Hangi uygulamanın kaydedileceğini `lib/core/di/project_dependency.dart` belirler ve bunu
  `AppEnvironment`'a (`--dart-define=ENV=mock | emulator | prod`) bakarak yapar.
- Ekran ve view model kodu hangi uygulamanın çalıştığını bilmez. Backend'e geçiş bu yüzden ekran
  kodunu değiştirmez (D-26).
- Her repository çağrısı `FirebaseResult<T, E>` döner; istisna fırlatılmaz. View model iki dalı da
  `switch` ile ele alır.

## 4. Genel sayfa (landing)

Tek sayfadır. `LandingView` bölümleri dikey sırayla dizer; her bölüm kendi view model'ini izler.

```
LandingView
├── LandingHeader          yapışkan üst bar; ≥1024 px'te linkler, altında hamburger
├── LandingDrawer          <1024 px çekmece menü
├── HeroSection
├── AboutSection
├── ProjectsSection
├── EventsSection
├── GallerySection
├── TeamSection
├── SocialsSection
└── LandingFooter
```

- Menü öğeleri rota değiştirmez; `LandingViewMixin` içindeki bölüm anahtarlarıyla ilgili bölüme kaydırır.
- Bölüm kimlikleri tek yerde tanımlıdır: `LandingSectionId` (`hero`, `about`, `projects`, `events`,
  `gallery`, `team`, `socials`).
- Her bölüm `TfSectionFrame` ile başlar. İçeriği yazılmamış bölüm `TfComingSoon` gösterir.

## 5. Responsive

| Ad | Genişlik | Kullanım |
|---|---|---|
| mobil | < 640 px | tek sütun |
| tablet | 640 – 1023 px | iki sütun; hamburger menü |
| masaüstü | ≥ 1024 px | üç sütun; üst barda linkler |

İçerik genişliği en fazla 1152 px (`TfSizes.contentMaxWidth`). Değerler `TfBreakpoints` içindedir;
ekran kodu `context.isMobile / isTablet / isDesktop` kullanır.

## 6. Yönlendirme

| Adres | Ekran | Durum |
|---|---|---|
| `/` | `LandingView` | var |
| `/admin/login` | `AdminLoginView` | sonraki tur |
| `/admin/…` | admin paneli (gecikmeli) | sonraki tur |
| diğer | `NotFoundView` | var |

## 7. Arayüz fazından backend fazına

1. `tf_data` içinde `firebase_<alan>_repository` uygulamaları yazılır.
2. `firebase/` altında güvenlik kuralları, indeksler ve kural testleri eklenir.
3. Köke `firebase_core` ve `firebase_app_check` eklenir; `app_bootstrap.dart` Firebase'i başlatır.
4. `project_dependency.dart` `ENV=prod` için Firebase uygulamalarını kaydeder.

Ekran, view model ve test kodu bu geçişte değişmez.
