# Tasarım Referansı

> Bir görevi yaparken **neye bakarak doğrulayacağını** gösterir: görünen her görev için bir taslak çizim.
> Taslaklar [`docs/tasarim/`](tasarim/) altındadır; dosya adı görev numarasıyla başlar.
> Kurallar: [`CLAUDE.md`](../CLAUDE.md). Davranışın tamamı: ilgili issue.

Bu taslaklar **bizim çizimlerimizdir**: bizim renklerimizle (`lib/product/theme/tf_colors.dart`) ve bizim
kararlarımıza göre çizildi. Örnek aldığımız sitenin ekran görüntüleri depoda yoktur ve eklenmez; o
görüntülerde başka bir kulübün logosu, metinleri ve üyelerinin fotoğrafları var (`CLAUDE.md §12`).

---

## 1. Nasıl okunur

- Solda **masaüstü** (1024 px ve üstü), sağda **telefon** (640 px altı) yerleşimi durur. Ortak parça
  taslaklarında (butonlar, metin alanı gibi) çerçeve yerine **durum tablosu** vardır.
- **Turuncu numaralar** alttaki notlara gönderme yapar. Numarası çizimde olmayan not genel kuraldır.
- Taslak **şematiktir**: yerleşimi, sırayı ve durumları gösterir; piksel ölçüsü vermez.

| Çizimde gördüğün | Anlamı |
|---|---|
| Gri çubuklar | Metin satırları (içeriği önemli değil) |
| Üstünde yazı olan renkli kutu | Görsel. Sahte veride gerçekten böyle çizilir (D-28) |
| Kesik çizgili alan | İçeriği henüz olmayan ya da isteğe bağlı alan |
| "Örnek …" ile başlayan metin | Yer tutucu; gerçek içerik sonra gelir |
| Koyu yarı saydam zemin | Pencere açıkken arkadaki karartma (bulanıklık yok, D-33) |

**Çelişki olursa:** davranış için **issue**, ölçü ve renk için **token'lar** ([`token-map.md`](token-map.md))
geçerlidir. Taslak yalnızca bakılacak şeydir; taslağa uysun diye koda sayı ya da renk yazılmaz.

---

## 2. Taslaklar

| Görev | Taslak | Ne gösteriyor |
|---|---|---|
| [#2](https://github.com/teknofest-gumushane/gu_teknofest/issues/2) | [`02-durum-gorunumleri.svg`](tasarim/02-durum-gorunumleri.svg) | Hata, yükleniyor ve boş görünümleri; açık ve mor zeminde |
| [#3](https://github.com/teknofest-gumushane/gu_teknofest/issues/3) | [`03-butonlar.svg`](tasarim/03-butonlar.svg) | `TfButton` ve `TfIconButton`: bütün görünümler ve durumlar |
| [#4](https://github.com/teknofest-gumushane/gu_teknofest/issues/4) | [`04-metin-alani.svg`](tasarim/04-metin-alani.svg) | `TfTextField`: varsayılan, odak, hata, devre dışı, çok satır, arama |
| [#5](https://github.com/teknofest-gumushane/gu_teknofest/issues/5) | [`05-kart-etiket-izgara.svg`](tasarim/05-kart-etiket-izgara.svg) | `TfCard`, `TfTag` ve `TfResponsiveGrid`'in sütun düzeni |
| [#7](https://github.com/teknofest-gumushane/gu_teknofest/issues/7) | [`07-pencere-kabugu.svg`](tasarim/07-pencere-kabugu.svg) | Pencere kabuğu: karartma, başlık satırı, kaydırılan gövde |
| [#8](https://github.com/teknofest-gumushane/gu_teknofest/issues/8) | [`08-gorsel-penceresi.svg`](tasarim/08-gorsel-penceresi.svg) | Görsel penceresi: görsel, başlık, önceki / sonraki, sayaç |
| [#11](https://github.com/teknofest-gumushane/gu_teknofest/issues/11) | [`11-hero.svg`](tasarim/11-hero.svg) | Hero: başlık, iki buton, dört istatistikli kart |
| [#12](https://github.com/teknofest-gumushane/gu_teknofest/issues/12) | [`12-hakkimizda.svg`](tasarim/12-hakkimizda.svg) | Hakkımızda: iki paragraf, beş madde, dört kart |
| [#13](https://github.com/teknofest-gumushane/gu_teknofest/issues/13) | [`13-projeler.svg`](tasarim/13-projeler.svg) | Projeler: etiket çipleri, arama, kart ızgarası |
| [#14](https://github.com/teknofest-gumushane/gu_teknofest/issues/14) | [`14-etkinlikler.svg`](tasarim/14-etkinlikler.svg) | Etkinlikler: yaklaşan ve geçmiş listeleri |
| [#15](https://github.com/teknofest-gumushane/gu_teknofest/issues/15) | [`15-etkinlik-gorsel-penceresi.svg`](tasarim/15-etkinlik-gorsel-penceresi.svg) | Etkinlik görsel penceresi ve onu açan düğme |
| [#16](https://github.com/teknofest-gumushane/gu_teknofest/issues/16) | [`16-galeri.svg`](tasarim/16-galeri.svg) | Galeri: görsel ızgarası, başlık şeridi, odak |
| [#17](https://github.com/teknofest-gumushane/gu_teknofest/issues/17) | [`17-ekibimiz.svg`](tasarim/17-ekibimiz.svg) | Ekibimiz: üye kartları, "Ekibe Katıl", e-posta bağlantısı |
| [#18](https://github.com/teknofest-gumushane/gu_teknofest/issues/18) | [`18-sosyal-medya.svg`](tasarim/18-sosyal-medya.svg) | Sosyal medya: dört düğme ve bugünkü boş hali |
| [#19](https://github.com/teknofest-gumushane/gu_teknofest/issues/19) | [`19-takima-katil-formu.svg`](tasarim/19-takima-katil-formu.svg) | Takıma Katıl formu: alanlar, hata, kapalı / başarılı / gönderilemedi |
| [#20](https://github.com/teknofest-gumushane/gu_teknofest/issues/20) | [`20-alt-bilgi.svg`](tasarim/20-alt-bilgi.svg) | Alt bilgi: bugün görünenler ve içerik gelince dolacak alanlar |

### Taslağı olmayan görevler

| Görev | Neden yok | Nereye bakılır |
|---|---|---|
| [#1](https://github.com/teknofest-gumushane/gu_teknofest/issues/1) Test iskeleti | Ekranda görünen bir şey yok | — |
| [#6](https://github.com/teknofest-gumushane/gu_teknofest/issues/6) Görsel gösterimi | Kendi ekranı yok | Renkli başlıklı kutu: `13-projeler.svg`, `16-galeri.svg` |
| [#9](https://github.com/teknofest-gumushane/gu_teknofest/issues/9) Kulüp bilgisi | Yalnızca view model | Sonucu `11-hero.svg`'deki kartta görünür |
| [#10](https://github.com/teknofest-gumushane/gu_teknofest/issues/10) İletişim ve ikonlar | Sabitler ve ikonlar | Kullanıldığı yerler: `17-ekibimiz.svg`, `18-sosyal-medya.svg`, `20-alt-bilgi.svg` |
| [#21](https://github.com/teknofest-gumushane/gu_teknofest/issues/21) Gerçek içerik | Yeni yerleşim yok | Yer tutucuların dolacağı yerler: `12`, `17`, `18`, `20` |
| [#22](https://github.com/teknofest-gumushane/gu_teknofest/issues/22) Belirme hareketi | Hareket çizimle gösterilemez | Issue'daki süre ve eğri token'ları |

Admin paneli ve admin girişi ekranlarının taslağı yoktur; o görevler yazılırken eklenecek.

---

## 3. İşini nasıl doğrularsın

1. Uygulamayı çalıştır: `bash tool/dev.sh`.
2. Görev numaranla başlayan taslağı aç (GitHub'da dosyaya tıklamak yeterli).
3. **Masaüstü** genişliğinde yerleşimi taslağın sol yanıyla karşılaştır: parçalar aynı sırada mı, sütun sayısı aynı mı?
4. Tarayıcıyı daralt (320 px'e kadar) ve **telefon** yerleşimini sağ yanla karşılaştır. Taşma olmamalı.
5. Alttaki **notları tek tek dene**: her not denenebilir bir davranıştır (üzerine gel, Tab ile dolaş, Esc'ye bas, boş ve hata durumunu gör).
6. Issue'daki **kabul ölçütlerini** işaretle. Taslak yardımcıdır; işin bittiğini kabul ölçütleri söyler.

Yapay zekâ ile çalışıyorsan istek cümlene taslağı da ekle:

```text
#13 numaralı görevi yapacağız. Issue'yu ve docs/tasarim/13-projeler.svg dosyasını oku
(içindeki "Notlar" dahil). Bana numaralı plan göster; onaylamadan dosyaya dokunma.
```

Renk ve ölçü taslaktan **okunmaz**: `context.tf.colors.*`, `TfSpacing`, `TfSizes` kullanılır (`CLAUDE.md §6`).

---

## 4. Örnek aldığımız siteden bilerek farklı yaptıklarımız

Düzen ve özellikler [mauteknofest.com](https://mauteknofest.com)'dan örnek alındı
([`analiz.md`](analiz.md)); aşağıdakiler bilerek farklıdır. Taslaklar bu farklarla çizildi.
Ayrıca tarih ve saatler her zaman Türkiye saatiyle gösterilir (D-34).

| Konu | Örnek sitede | Bizde | Kaynak |
|---|---|---|---|
| Bulanıklık | Üst menü, hero kartı ve pencere arkası bulanık | Bulanıklık yok; karartma ve yarı saydam renk | D-33 |
| İçerik | O kulübün logosu, metinleri, fotoğrafları, üyeleri | Hepsi bize ait; gelene kadar "Örnek …" yer tutucuları | `CLAUDE.md §12`, #21 |
| Görseller (sahte veri) | Gerçek fotoğraflar | Renkli, üstünde başlığı yazan kutu | D-28 |
| Görsel pencereleri | Sayaç yalnızca etkinlik penceresinde | Sayaç ikisinde de var; sol ve sağ ok tuşları da görseli değiştirir | #8 |
| Etkinlik görselleri | "Görselleri görmek için tıklayın" satırı | Görsel sayısını yazan düğme: "2 görseli gör" | #15 |
| Başvuru formu | E-posta servisiyle gönderiliyor | Repository üzerinden kaydedilir; başvurular kapalıyken "kapalı" bilgisi | D-35, #19 |
| Yapay zekâ asistanı | Sağ altta sohbet kutusu | Yapılmıyor | `analiz.md §2` |

---

## 5. Taslağı güncellemek

- Bir karar değişip yerleşimi etkilerse ilgili taslak **aynı PR'da** güncellenir; eski taslak yanlış yönlendirir.
- Dosya adı kalıbı değişmez: `<görev no, iki hane>-<kısa-ad>.svg`.
- Taslağa örnek siteden içerik (logo, metin, fotoğraf, kişi adı) ve gerçek kişi bilgisi konmaz.
- Yeni bir görünen görev açıldığında taslağı da bu klasöre eklenir ve bölüm 2'deki tabloya satırı yazılır.

---

## 6. Bütün taslaklar

Tek sayfada göz atmak için. Büyütmek için resme tıkla.

### #2 Durum görünümleri

![#2 Durum görünümleri taslağı](tasarim/02-durum-gorunumleri.svg)

### #3 Butonlar

![#3 Butonlar taslağı](tasarim/03-butonlar.svg)

### #4 Metin alanı

![#4 Metin alanı taslağı](tasarim/04-metin-alani.svg)

### #5 Kart, etiket ve ızgara

![#5 Kart, etiket ve ızgara taslağı](tasarim/05-kart-etiket-izgara.svg)

### #7 Pencere kabuğu

![#7 Pencere kabuğu taslağı](tasarim/07-pencere-kabugu.svg)

### #8 Görsel penceresi

![#8 Görsel penceresi taslağı](tasarim/08-gorsel-penceresi.svg)

### #11 Hero

![#11 Hero taslağı](tasarim/11-hero.svg)

### #12 Hakkımızda

![#12 Hakkımızda taslağı](tasarim/12-hakkimizda.svg)

### #13 Projeler

![#13 Projeler taslağı](tasarim/13-projeler.svg)

### #14 Etkinlikler

![#14 Etkinlikler taslağı](tasarim/14-etkinlikler.svg)

### #15 Etkinlik görsel penceresi

![#15 Etkinlik görsel penceresi taslağı](tasarim/15-etkinlik-gorsel-penceresi.svg)

### #16 Galeri

![#16 Galeri taslağı](tasarim/16-galeri.svg)

### #17 Ekibimiz

![#17 Ekibimiz taslağı](tasarim/17-ekibimiz.svg)

### #18 Sosyal medya

![#18 Sosyal medya taslağı](tasarim/18-sosyal-medya.svg)

### #19 Takıma Katıl formu

![#19 Takıma Katıl formu taslağı](tasarim/19-takima-katil-formu.svg)

### #20 Alt bilgi

![#20 Alt bilgi taslağı](tasarim/20-alt-bilgi.svg)
