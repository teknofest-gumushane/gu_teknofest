# Paket Kararları

Bu liste **izin verilen** paketlerdir. Listede olmayan bir paket gerekirse önce Flutter'ın kendisiyle ya da
`lib/product` ile çözülüp çözülemeyeceğine bak; çözülemiyorsa kullanıcıya sor (gerekçe + alternatif).
Kararlar: [`decisions.md`](decisions.md).

## Sürüm politikası

1. Sürüm elle yazılmaz: `flutter pub add <paket>` (dev için `dev:<paket>`). Sonra satır `pubspec.yaml`'da
   uygun kategoriye taşınır ve yanına amacı yazılır.
2. Sürümü sabitlemek ya da aşağı çekmek için gerekçe yazılır (örnek: aşağıdaki `equatable` satırı).
3. İşin ortasında yükseltme yapılmaz; güvenlik düzeltmeleri hariç.
4. Paket eklemek = aynı commit'te bu tabloya satır.

## Kök uygulama

| Paket | Amaç | Faz |
|---|---|---|
| `flutter_localizations` (sdk), `intl` | ARB metinleri, tarih ve sayı biçimi | arayüz |
| `flutter_riverpod`, `riverpod_annotation` | State (D-05) | arayüz |
| `equatable` (^2.1.0) | State eşitliği. 3.x değil: Firebase test paketleri ^2 ister | arayüz |
| `get_it` | DI (D-06) | arayüz |
| `go_router` | Yönlendirme (D-07) | arayüz |
| `material_ui` | Material bileşenleri (`MaterialApp`, tema, `Icons`…); Flutter 3.50'de çekirdekten bu pakete taşındı (D-32) | arayüz |
| `flutter_svg` | Hazır `IconData`'sı olmayan ikonlar ve logo (D-11) | arayüz |
| `url_launcher` | Sosyal medya ve e-posta bağlantıları | arayüz |
| `image_picker` | Admin panelinde görsel seçme (D-15) | arayüz |
| `tf_data` (yerel) | Veri katmanı | arayüz |
| `firebase_core` | Firebase başlatma | backend |
| `firebase_app_check` | Bot ve spam koruması (D-16) | backend |

## `packages/tf_data`

| Paket | Amaç |
|---|---|
| `cloud_firestore`, `firebase_auth`, `firebase_storage` | Servisler ve taşınan çekirdek tipler |
| `equatable`, `json_annotation`, `meta`, `collection` | Modeller ve yardımcılar |

Bu üç Firebase paketi arayüz fazında yalnızca derleme için bağımlılıktır; Firebase başlatılmaz (D-26).

## Geliştirme paketleri

| Paket | Nerede | Amaç |
|---|---|---|
| `build_runner` | kök, `tf_data` | Üreticileri çalıştırır |
| `riverpod_generator` | kök | `@riverpod` → `*.g.dart` |
| `go_router_builder` (^4.5.3) | kök | Typed rotalar → `*.g.dart`. 4.5.2 altı `source_helper` 1.4 ile derlenmez (D-21) |
| `json_serializable` | `tf_data` | Modellerin `fromJson` / `toJson` kodu |
| `very_good_analysis` | kök, `tf_data` | Lint (D-08) |
| `fake_cloud_firestore`, `firebase_auth_mocks`, `firebase_storage_mocks` | `tf_data` | Servis testleri |

## Bilinçli olarak yok

Freezed · `AsyncValue` / `hooks_riverpod` · `google_fonts` · `cached_network_image` · `flutter_animate` ·
`http` / `dio` (Firebase dışı HTTP yok) · `firebase_ai` · mock kütüphaneleri (`mocktail`, `mockito`) ·
`firebase_crashlytics` (web'i desteklemiyor) · `firebase_messaging` · `firebase_remote_config` ·
`firebase_analytics` · `provider` · `bloc` · `get` · `shared_preferences` (gerekince sorulur).
