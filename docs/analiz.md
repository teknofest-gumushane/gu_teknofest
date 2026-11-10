# mauteknofest.com — Teknik Analiz ve Gereksinimler

İnceleme tarihi: 10 Kasım 2026
Kaynak: https://mauteknofest.com (React + Tailwind, REST API `/api` altında)
Hedef: aynı özelliklerle Flutter web sürümü; önce front (sahte veriyle), sonra Firebase.

## Özet

Site üç parçadan oluşuyor:

1. **Genel sayfa** — tek sayfa, kaydırmalı, 8 bölüm.
2. **Admin paneli** — `/admin` altında, menüde linki yok, 6 ekran.
3. **Veri katmanı** — genel sayfa içeriği API'den okuyor, admin paneli yazıyor.

## 1. Genel sayfa

| Bölüm | İçerik | Veri |
|---|---|---|
| Bekleme ekranı | Dönen simge + "Yükleniyor..." | — |
| Üst menü | Logo, 6 bölüm linki, "Takıma Katıl" butonu. Yapışkan, kaydırınca küçülüyor. 1024px altında hamburger menü | Sabit |
| Hero | Gradyan arka plan, başlık, alt metin, 2 buton, cam efektli kartta 4 istatistik (üye, aktif üye, proje, başvuru açık/kapalı) ve "Güncel" rozeti | API |
| Hakkımızda | 2 metin bloğu, 5 maddelik onay işaretli liste, ikonlu 4 kart | Sabit |
| Projeler | Etiket filtreleri (tek seçim, "Tümü" dahil), arama kutusu (ad + açıklamada arar), 3 sütunlu kartlar (görsel, etiketler, ad, açıklama) | API |
| Etkinlikler | Solda yaklaşanlar (boş durum mesajıyla), sağda kendi içinde kaydırılan geçmiş listesi (tarih, ad, saat · konum - mekan, açıklama) | API |
| Galeri | 3 sütunlu görsel ızgarası, üzerine gelince başlık | API |
| Ekibimiz | Üye kartları (foto, ad, ünvan, açıklama), "Ekibe Katıl" butonu, e-posta linki | API |
| Sosyal medya | 4 ikon buton: Instagram, WhatsApp, YouTube, LinkedIn (yeni sekmede açılır) | Sabit |
| Alt bilgi | Üniversite ve kulüp logoları, kampüs görseli, adres, e-posta, telif satırı, bilgilendirme notu | Sabit |

Izgara sütunları: 640px altı 1, 640px+ 2, 1024px+ 3.

## 2. Açılır pencereler ve yüzen parçalar

### Takıma Katıl formu

Üst menüdeki ve ekip bölümündeki butondan açılır. Arka plan karartılır ve bulanıklaşır.

| Alan | Tür | Zorunlu | İpucu metni |
|---|---|---|---|
| Ad | metin | evet | — |
| Soyad | metin | evet | — |
| Sınıf | metin | evet | "Örn. 2. sınıf" |
| Bölüm | metin | evet | "Örn. Bilgisayar Mühendisliği" |
| E-posta | e-posta | evet | — |
| Telefon | telefon | evet | "+90 ..." |
| Kendinizden kısaca bahsedin | çok satırlı | hayır | — |

Orijinalde başvuru veritabanına yazılmıyor; EmailJS ile kulüp e-postasına gönderiliyor.

### Etkinlik görsel penceresi

Geçmiş etkinlikteki "Görselleri görmek için tıklayın" satırından açılır. Üstte tarih · konum, başlık, açıklama; altta görsel, ileri/geri okları, "1 / 7" sayacı. Esc ile kapanır.

### Galeri penceresi

Görsele tıklayınca açılır. Büyük görsel, başlık, açıklama, ileri/geri okları, kapat butonu. Esc ile kapanır.

### AI Asistan

- Sağ altta yüzen sohbet kutusu; başlık, karşılama mesajı, saat damgası, mesaj alanı, "Gönder" butonu.
- Küçültülebiliyor; 640px altında kapalı başlıyor.
- Alt bilgi görünür olunca yuvarlak logo balonuna dönüşüyor.
- Koda göre gerçek bir yapay zekâ bağlı değil: tek bir hazır "şu anda hizmet veremiyoruz" cevabı tanımlı. (Mesaj gönderilerek denenmedi.)

## 3. Admin paneli

Giriş yapılmadı; ekranlar ve alanlar sitenin kodundan okundu.

| Rota | Ekran | Yapılabilenler |
|---|---|---|
| `/admin/login` | Giriş | E-posta + şifre. Yetkisiz istekte oturum silinip girişe yönlendiriliyor |
| `/admin` | Dashboard | İstatistik kartları (yaklaşan/geçmiş etkinlik, aktif/toplam üye, proje sayısı, başvuru durumu), hızlı işlem butonları |
| `/admin/events` | Etkinlikler | Ekle/düzenle/sil, görsel yönetimi, "geçmişe taşı" |
| `/admin/members` | Üyeler | Ekle/düzenle/sil, profil fotoğrafı, sıralama, aktif/pasif |
| `/admin/projects` | Projeler | Ekle/düzenle/sil, görsel, etiket ekleme, durum, sıralama |
| `/admin/gallery` | Galeri | Görsel ekle (toplu dahil)/düzenle/sil, başlık, açıklama |
| `/admin/settings` | Ayarlar | Kulüp logosu, toplam/aktif üye sayısı, başvurular açık/kapalı, şifre değiştirme |

Form alanları:

- **Etkinlik:** ad (zorunlu), açıklama, tarih ve saat, konum, mekan. Görseller: PNG/JPG/GIF, en çok 5MB.
- **Üye:** ad soyad (zorunlu), ünvan, açıklama, sıralama, aktif mi. Foto: jpeg/png/gif/webp, en çok 10MB.
- **Proje:** ad (zorunlu), açıklama, görsel, etiketler, durum, sıralama.
- **Galeri:** görsel (zorunlu), başlık, açıklama.

Her silme işleminde onay sorusu, her işlem sonunda başarı/hata bildirimi var.

## 4. Veri modeli

Orijinal API'nin döndürdüğü alanlar (sahte veriyi buna göre şekillendirin):

| Kayıt | Alanlar |
|---|---|
| Kulüp bilgisi (tek kayıt) | `logo_image`, `num_of_member`, `num_of_active_member`, `num_of_project`, `is_applicatable` |
| Proje | `name`, `description`, `image_path`, `tags[]`, `status`, `display_order` |
| Etkinlik | `name`, `description`, `event_time`, `location`, `place`, `images[]` |
| Etkinlik görseli | `image_path`, `title`, `description`, `event_id`, `event_type` |
| Üye | `name`, `title`, `description`, `image_path`, `display_order`, `is_active` |
| Galeri | `title`, `description`, `image_path`, `display_order` |

Hepsinde `id`, `created_at`, `updated_at` var. Proje durumunda sitede yalnızca `active` değeri görüldü; diğer değerler bilinmiyor.

Orijinal API uçları:

- Genel (okuma): `/club-info`, `/projects`, `/projects/meta/tags`, `/events/coming`, `/events/past`, `/members`, `/gallery`
- Admin: `/auth/login`, `/auth/me`, `/auth/change-password`, her kayıt türü için ekle/güncelle/sil, `/events/coming/{id}/move-to-past`, `/members/{id}/toggle-active`, `/gallery/bulk`, `/upload/single`, `/upload/multiple`, `/club-info/dashboard-stats`

### Firebase eşlemesi (öneri)

| İhtiyaç | Firebase karşılığı |
|---|---|
| İçerik kayıtları | Firestore: `clubInfo`, `projects`, `events`, `members`, `gallery` |
| Başvurular | Firestore: `applications` (EmailJS yerine) |
| Görseller | Storage |
| Admin girişi | Auth (e-posta + şifre) |
| Yetki | Güvenlik kuralları: herkes okur, yalnızca admin yazar; `applications` için herkes yazar, yalnızca admin okur |

Orijinalde yaklaşan ve geçmiş etkinlikler ayrı tablolarda. Firestore'da tek `events` koleksiyonu tutup tarihe göre ayırmak "geçmişe taşı" işlemini gereksiz kılar.

## 5. Renk paleti ve tasarım ölçüleri

| Rol | Renk | Nerede |
|---|---|---|
| Mor | `#682D8B` | Üst menü (%95 opak), alt bilgi, gradyan başlangıcı |
| Mavi | `#2F97C1` | Butonlar, linkler, etiketler, odak çerçevesi |
| Lacivert | `#1B3C73` | Başlıklar ve metinler (%60–80 opak tonlarıyla) |
| Turuncu | `#F47A1F` | Bölüm üst etiketleri, hover, rozetler |
| Yüzey | `#F8F9FA` | Sayfa arka planı |
| Beyaz | `#FFFFFF` | Kartlar, pencereler |
| Gövde metni | `#0F172A` | Varsayılan metin rengi |

- **Hero gradyanı:** sol üstten sağ alta `#682D8B` → `#2F97C1` → `#1B3C73`.
- **Pencere arka planı:** koyu yarı saydam katman + bulanıklık.
- **Yazı tipi:** Inter. Ana başlık 60px kalın; gövde 16px; bölüm üst etiketleri büyük harf, aralıklı, turuncu.
- **Köşeler:** 12 / 16 / 24px ve tam yuvarlak butonlar.
- **Gölge:** `0 20px 45px -20px rgba(43,79,135,0.35)`.
- **Düzen:** en fazla 1152px içerik genişliği; kırılma noktaları 640 / 768 / 1024px.
- **Hareket:** kartlarda 0.6 sn aşağıdan belirme (20px), üzerine gelince 4px yükselme, bekleme simgesi.

## 6. Flutter için planı etkileyen noktalar

1. **Arama motoru görünürlüğü:** Flutter web sayfayı tuvale çizdiği için arama motorlarında zayıf indekslenir. Herkese açık bir kulüp sitesi için gerçek bir bedel.
2. **İlk açılış süresi:** Flutter web paketi React sürümünden ağır olur; bekleme ekranı daha uzun görünür.
3. **Bulanıklık efektleri:** üst menü, hero kartı ve pencereler arka plan bulanıklığı kullanıyor; Flutter web'de pahalı, sade bir yedek tasarım gerekebilir.
4. **Sayfa yönlendirme:** `/`, `/admin/login`, `/admin/...` için korumalı rotalar ve menüden bölüme kaydırma gerekiyor.
5. **Görseller:** galeri ve etkinlik görselleri için tembel yükleme ve önbellek.

## 7. Önerilen iş sırası (front)

1. Tema ve iskelet: renkler, font, responsive düzen, üst menü, alt bilgi, rotalar.
2. Sabit bölümler: hero, hakkımızda, sosyal medya.
3. Veri bölümleri sahte veriyle: projeler + filtre/arama, etkinlikler, galeri, ekip ve pencereleri.
4. Takıma Katıl formu ve asistan arayüzü.
5. Admin paneli arayüzü (7 rota).

Front bittikten sonra: Firebase bağlantısı (bölüm 4'teki eşleme).

## 8. Doğrulanmayanlar ve notlar

- Admin paneline giriş yapılmadı; ekranlar koddan okundu, görsel tasarımı görülmedi (yalnızca giriş ekranı görüldü).
- 640px altı mobil görünüm ekran görüntüsüyle kontrol edilmedi; davranış koddan biliniyor.
- Asistana mesaj gönderilmedi; hazır cevap davranışı koda dayanıyor.
- Logo, fotoğraflar, ekip bilgileri ve metinler Maltepe Üniversitesi Teknofest Kulübü'ne ait. Düzen ve özellikler örnek alınabilir; içerik kendi kulübünüze ait olmalı.
