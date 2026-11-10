# Kilitli Kararlar

Bu listedeki kararlar kullanıcıyla alınmıştır ve sormadan değiştirilmez. Yeni karar ya da değişiklik:
kullanıcıya sor, onaylanırsa buraya işle (tarih + gerekçe). Kurallar: [`CLAUDE.md`](../CLAUDE.md).

| No | Karar | Gerekçe | Tarih |
|---|---|---|---|
| D-01 | Önce arayüz sahte veriyle yazılır; Firebase bağlantısı arayüz bitince yapılır. | Ekip arayüze paralel başlayabilsin; backend kararları arayüzü bekletmesin. | 2026-11-10 |
| D-02 | Mimari: feature-first + `product/` katmanı + yerel paket `packages/tf_data`. Arayüz token'ları pakette değil `lib/product/theme` içinde. | `gu_kulupler` düzeni korunur; bu ölçekte ayrı bir arayüz paketi fazla yük. | 2026-11-10 |
| D-03 | Feature'lar yüz bazlı: `landing`, `auth`, `admin`. | Feature'lar birbirini import etmez kuralı bozulmaz; admin kodu ziyaretçi paketinden ayrılır. | 2026-11-10 |
| D-04 | Admin paneli aynı uygulamada, `/admin` altında, gecikmeli yüklenir. | Tek derleme ve tek yayın; ziyaretçi admin kodunu indirmez. | 2026-11-10 |
| D-05 | State: Riverpod `@riverpod` Notifier + Equatable state. Freezed ve `AsyncValue` yok. | `gu_kulupler` ile aynı kalıp; skill ve agent'lar değişmeden taşınır. | 2026-11-10 |
| D-06 | DI: GetIt + `ProjectDependencyMixin`. | Aynı. | 2026-11-10 |
| D-07 | Yönlendirme: typed go_router (`go_router_builder`). | Aynı. | 2026-11-10 |
| D-08 | Lint: `very_good_analysis`, `--fatal-infos`. | Aynı. | 2026-11-10 |
| D-09 | Metinler ARB'de, şimdilik yalnız Türkçe. | "Metin koda yazılmaz" kuralı korunur; ikinci dil tek dosyayla eklenir. | 2026-11-10 |
| D-10 | Silme soft delete'tir (`isDeleted`, `deletedAt`, `deletedBy`). Hard delete yok. | Taşınan `firestore_service` buna göre yazılmış; yanlışlıkla silme geri alınabilir. | 2026-11-10 |
| D-11 | İkonlar: Flutter'da hazır `IconData` varsa o, yoksa SVG (`flutter_svg`). İkisi de tek kayıt defterinin (`TfIcons`) arkasında; ekran kodunda doğrudan `Icons.*` yok. | Hazır olanı yeniden çizmemek; kullanımı tek yerden yönetmek. | 2026-11-10 |
| D-12 | Ağ görselleri paketsiz: `Image.network` üzerine `TfNetworkImage`. `cached_network_image` yok. | Web'de önbelleği tarayıcı tutar. | 2026-11-10 |
| D-13 | Animasyonlar Flutter yerleşikleriyle; `flutter_animate` yok. | Referans sitedeki animasyonlar basit. | 2026-11-10 |
| D-14 | Takıma Katıl formu Firestore `applications` koleksiyonuna yazar; admin paneline "Başvurular" ekranı eklenir. EmailJS ve `http` yok. | Başvurular kayıt altında olur; Firebase dışı HTTP gerekmez. | 2026-11-10 |
| D-15 | Admin panelinde görsel seçme: `image_picker`. | `gu_kulupler` ile aynı; web'de çoklu seçim destekler. | 2026-11-10 |
| D-16 | `firebase_app_check` backend fazında eklenir. | Form girişsiz yazma yolu açıyor; spam riski gerçek. | 2026-11-10 |
| D-17 | AI asistan kutusu şimdilik kapsam dışı. | Kullanıcı kararı; referans sitede de yalnızca sabit cevap veriyor. | 2026-11-10 |
| D-18 | Üretilen dosyalar (`*.g.dart`, `app_localizations*.dart`) commit edilmez; CI önce kod üretir. | `gu_kulupler` ile aynı. | 2026-11-10 |
| D-19 | Commit doğrudan `main`'e; yan dal ve PR yok. Conventional Commits, açıklama Türkçe. | Kullanıcı kararı. | 2026-11-10 |
| D-20 | Yazı tipi Inter, projeye gömülü; `google_fonts` yok. | Ağ isteği olmadan aynı görünüm. | 2026-11-10 |
| D-21 | `source_helper` `<1.4.0` sabit. | 1.4.0, `go_router_builder` 4.5.0 ile çakışıyor; düzeltme Dart ≥3.13 istiyor. Dart 3.13'e geçince kaldırılır. | 2026-11-10 |
| D-22 | Şimdilik web yayını yok; site yerelde çalıştırılır. Yayın iş akışı sonraya kalır. | Kullanıcı kararı. | 2026-11-10 |
| D-23 | Altyapı turu: üst bar, çekmece menü, yer tutucu bölümler. Admin kabuğu sonraki tur. | Kullanıcı kararı. | 2026-11-10 |
| D-24 | ~~Logo özgündür; referans sitenin logosu kopyalanmaz. Kulübün resmi logosu gelirse onunla değişir.~~ → Logo, kullanıcının sağladığı resmi TEKNOFEST logosudur ("logo bu olacak"). Dosya olduğu gibi kullanılır: yeniden çizilmez, değiştirilmez; yalnızca küçültülür. Mor zeminde beyaz daire içinde gösterilir. Referans sitenin (başka bir kulübün) logosu yine kopyalanmaz. | Kullanıcı kararı; özgün çizim istenen logo değildi. TEKNOFEST logosu T3 Vakfı'nın tescilli markasıdır; kullanım izni ve kurumsal kimlik kuralları kulübün sorumluluğundadır (`assets/README.md`). | 2026-11-10 |
| D-25 | Birkaç adımlı işte önce plan gösterilir; kullanıcı onaylamadan uygulanmaz. Seçenekli sorular açılır pencereyle sorulur. | Kullanıcı kararı. | 2026-11-10 |
| D-26 | `tf_data`'da Firebase altyapısı (servisler, sonuç ve hata tipleri, soft delete) baştan kurulu durur ama arayüz fazında başlatılmaz. `firebase_*_repository` uygulamaları backend fazında, güvenlik kurallarıyla birlikte yazılır. | Backend'e geçiş ekran kodunu değiştirmesin. | 2026-11-10 |

## Açık konular

- **Inter Bold (700):** `gu_kulupler`'de yalnızca 400 / 500 / 600 ağırlıkları var. Referans sitede ana başlık 700.
  Kalın dosyası eklenene kadar başlıklarda 600 kullanılır.
- **Kulübün tam adı:** kesinleşene kadar "Gümüşhane Üniversitesi Teknofest Kulübü" kullanılır.
- **Tarayıcı ikonları:** `web/icons/*` logonun küçültülmüş halidir; maskelenebilir ikonlar için ayrı,
  kenar boşluklu bir sürüm hazırlanmadı.
- **Web yayın yeri:** D-22 kalkınca seçilecek (GitHub Pages ya da Firebase Hosting).
