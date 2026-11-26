---
name: tf-issue
description: GitHub issue açma kuralları (görev, hata, öneri şablonları). Yeni bir iş kalemi tanımlarken, "issue aç", "görevleri yaz", "task'ları çıkar", "issue'yu detaylandır" dendiğinde ya da bir hatayı / öneriyi kayda geçirirken kullan.
---

# tf-issue

Şablonlar `.github/ISSUE_TEMPLATE/` altındadır; boş issue kapalıdır. Akışın tamamı: **issue → dal (`tf-branch`) → PR (`tf-pr`)** (D-27, `CONTRIBUTING.md`).

## Hangi şablon

| Durum | Şablon | Başlık | Etiket |
|---|---|---|---|
| Kapsamı belli, yapılacak bir iş (bölüm, ekran, altyapı parçası) | `task.yml` | `[Görev] <alan>: <sonuç>` | `enhancement` |
| Beklendiği gibi çalışmayan bir şey | `bug_report.yml` | `[Hata] <ne oluyor>` | `bug` |
| Kapsamı henüz belli olmayan fikir | `feature_request.yml` | `[Öneri] <ne>` | `enhancement` |

Güvenlik açığı issue olarak açılmaz: yeni issue ekranındaki "Güvenlik açığı bildir" bağlantısı.

## İyi bir görev

Görev, **onu hiç görmemiş biri ya da bir yapay zekâ başka kimseye sormadan yapabilecek** kadar ayrıntılı yazılır. Issue, o işin şartnamesidir. Örnek: `gh issue view 13` (Projeler bölümü).

- **Bir görev = bir kişi = bir PR.** Tek PR ile kapanamayacak kadar büyükse böl.
- Başlık sonucu söyler: `[Görev] Projeler: etiket filtresi ve arama`. "Projeler bölümü üzerinde çalış" değil.
- **Adlar gerçek olsun.** Sınıf, dosya, alan, token ve ARB anahtarı adlarını yazmadan önce kodda doğrula (`grep`). Kodda olmayan bir ad ya bu görevin sözleşmesidir (o zaman imzasını yaz) ya da bağımlı bir görevden gelir (o zaman o görevi bağla). Üçü de değilse yazma.
- **Açık soru bırakma.** Görevde cevapsız soru olmaz: `tf-ask-user` ile sorulur ve **Karar** olarak yazılır. Karar gelmediyse görev açılmaz. Birden çok görevi etkileyen karar `docs/decisions.md`'ye de işlenir (`tf-decision-log`) ve görevde D numarasıyla anılır.
- **Metinler yazılı gelir.** Arayüz metni gereken görev, ARB anahtarlarını ve Türkçe metinlerini tablo halinde verir. İçerik (tanıtım metni, adres, kişi adı, görsel) **uydurulmaz**: yoksa "Örnek metin" yer tutucusu ya da boş değer yazılır ve içeriğin girilmesi ayrı bir görev olur. Referans siteden kopyalanacak içerik göreve yazılmaz (`CLAUDE.md §12`).
- **Kabul ölçütleri denetlenebilir** maddelerdir (kutucuklu). Her bölüm görevinde şunlar bulunur: dört durum (hata / yükleniyor / boş / dolu), 320 / 768 / 1024 / 1440'ta taşma yok, metinler ARB'de, token kullanımı, testler, kapı yeşil.
- **Dokunulacak dosyalar** yazılır; yeni olanlar `(yeni)` diye işaretlenir. İki görev aynı dosyaya dokunuyorsa (ör. ortak bir widget) birini diğerine bağla; aynı anda yürümesinler. İstisna: D-31'deki satır ekleme tipi ortak dosyalar (ARB, ikon ve ölçü kayıtları, token eşlemesi).
- **Kapsam dışı** yazılır: görevin sınırı, bitmiş sayılması için en önemli bilgidir.
- Referans: `docs/analiz.md` başlığı ve ilgili D-xx.

## Görev gövdesi

Başlıklar bu sırayla yazılır. Adlar formdaki (`task.yml`) alan adlarıyla aynıdır; `tf-pr-reviewer` gibi araçlar bu adlara bakar. 1 ve 14 formda yoktur; onları gövdeyi yazan ekler.

| # | Başlık | İçinde ne olur |
|---|---|---|
| 1 | *(yapay zekâ notu, alıntı bloğu)* | Aşağıdaki sabit metin |
| 2 | `### Ne yapılacak?` | İki üç cümleyle sonuç. "Nasıl" değil "ne" |
| 3 | `### Şu anki durum` | Koddaki ilgili dosya, sınıf, alan ve sahte veri; bugün ne çiziliyor, ne eksik; hazır parçalar ve hangi görevden geldikleri |
| 4 | `### Hedef davranış` | Başta **Kararlar**; sonra numaralı, denetlenebilir kurallar (durum sırası, yerleşim, etkileşim, erişilebilirlik) |
| 5 | `### Sözleşme (adlar ve imzalar)` | Yazılacak sınıfların imzaları (`dart` kod bloğu), eklenecek token'lar (değerleriyle), ARB tablosu (anahtar + metin) |
| 6 | `### Uygulama adımları` | Sırayla, dosya yollarıyla; dikkat edilecek kural numaraları (HC…) |
| 7 | `### Test planı` | Test dosyası başına denenecek durumlar; kurulum (hangi fake, hangi yardımcı) |
| 8 | `### Alan`, `### Bölüm` | Formdaki seçeneklerden biri |
| 9 | `### Kabul ölçütleri` | Kutucuklu liste |
| 10 | `### Dokunulacak dosyalar` | Madde madde |
| 11 | `### Kapsam dışı` | Madde madde |
| 12 | `### Referans` | `docs/analiz.md §…` · `D-xx` · `CLAUDE.md §…` |
| 13 | `### Bağımlı olduğu görevler` | Her biri için `#no → ne sağlıyor`; yoksa "Yok. Hemen başlanabilir." |
| 14 | `### Çalışma akışı` | Dal adı (`tf-branch`), `bash tool/codegen.sh`, kapı, PR başlığı ve `Closes #no` (`tf-pr`) |

Arayüz ya da kod içermeyen küçük görevlerde (ör. yalnızca belge) 5–7 boş bırakılmaz, "Yok" yazılır.

**Yapay zekâ notu** (gövdenin en üstüne aynen; yalnızca skill listesi göreve göre değişir):

```markdown
> **Bu görevi yapay zekâ ile yapıyorsan** (Claude Code vb.): önce `CLAUDE.md`'yi, sonra bu sayfayı baştan sona oku.
> - Buradaki sınıf, dosya, token ve ARB anahtarı adları ya kodda vardır ya da bu görevin sözleşmesidir. Farklı ad uydurma.
> - **Karar** diye yazılanlar verilmiş kararlardır; yeniden tartışma. Sayfada cevabı olmayan bir şey çıkarsa tahmin etme, proje sahibine sor.
> - Material bileşenleri `package:material_ui/material_ui.dart`'tan import edilir; `package:flutter/material.dart` yasak (D-32).
> - Renk, boşluk, ölçü, süre ve metin koda yazılmaz: token (`context.tf.*`, `TfSpacing`, `TfSizes`, `TfMotion`) ve ARB (`context.l10n.*`). Eksik token token katmanına eklenir ve `docs/token-map.md` güncellenir.
> - Kullanılacak skill'ler: `tf-…`, `tf-…`
```

## Adımlar

1. **Var mı bak:** `gh issue list --state all --search "<anahtar sözcük>"`. Varsa yenisini açma; eksikse onu güncellemeyi öner.
2. **Taslağı yaz.** Birden çok görev çıkarılacaksa (`"bölümlerin görevlerini yaz"`) `tf-issue-drafter` agent'ını çalıştır; sırayı, bağımlılıkları ve karar bekleyen soruları da o çıkarır.
3. **Kararları al.** Taslaktaki her açık soruyu `tf-ask-user` ile sor (önerinle birlikte); cevapları taslağa **Karar** olarak işle.
4. **Denetle** ("Açmadan önce denetle", aşağıda).
5. **Göster ve onay al.** Issue açmak ya da gövdesini değiştirmek depoya herkesin göreceği bir kayıt düşer: taslak(lar)ı kullanıcıya göster, `tf-ask-user` ile onay iste. Toplu işte önce liste (başlık + bir cümle) ve alınan kararlar, sonra onay.
6. **Aç.** Form şablonları `gh` ile doldurulamaz; gövdeyi yukarıdaki başlıklarla Markdown yaz ve dosyadan ver:

   ```
   gh issue create --title "[Görev] Projeler: etiket filtresi ve arama" \
     --label enhancement --body-file <taslak.md>
   ```

   Issue numarası açılınca belli olur. Dal adı, `Closes #no` ve başka görevlere verilen `#no` referansları için: önce aç, sonra numaraları yerine koyup `gh issue edit <no> --body-file <taslak.md>` ile gövdeyi güncelle.
7. **Bildir:** numara, adres ve bağımlılık sırası.

Var olan bir görevi ayrıntılandırmak ya da düzeltmek de aynı yoldan geçer: taslak → denetim → onay → `gh issue edit`.

## Açmadan önce denetle

- [ ] Gövdede geçen her kod adı ya kodda var (`grep`) ya "Sözleşme"de tanımlı ya da bağlı bir görevin sağladıkları arasında.
- [ ] Yeni ARB anahtarları `lib/l10n/app_tr.arb`'de ve başka açık görevlerde yok (`gh issue list --search "<anahtar> in:body"`).
- [ ] "Dokunulacak dosyalar"daki mevcut yollar gerçekten var; aynı dosyaya dokunan açık görev varsa bağlandı (D-31 hariç).
- [ ] Açık soru yok; her karar **Karar** olarak yazılı.
- [ ] Bağımlılık satırları `#no → ne sağlıyor` biçiminde; bağlanan görev o şeyi gerçekten sağlıyor.
- [ ] Kişisel veri, gizli anahtar ve kod dışında `@kullanıcı` yok; referans siteden içerik yok.

## Etiketler

Yalnızca depoda var olanlar: `bug`, `enhancement`, `documentation`, `accessibility`, `good first issue`, `help wanted`, `question`. Yeni etiket gerekiyorsa önce sor; onaysız `gh label create` yok.

## Yapma

- ❌ Kişisel veri (ad, e-posta, telefon) ya da gizli anahtar içeren issue.
- ❌ Birden çok konuyu tek issue'da toplamak.
- ❌ Görevde açık soru ya da "duruma göre" bırakmak; kodda olmayan bir adı varmış gibi yazmak.
- ❌ Tanıtım metni, adres, kişi adı gibi içeriği uydurmak.
- ❌ Kilitli bir kararı (D-xx) issue ile değiştirmek: önce `tf-ask-user`, sonra `tf-decision-log`.
- ❌ Onaysız issue açmak, kapatmak, gövdesini değiştirmek ya da başkasının issue'sunu düzenlemek.
- ❌ Atama (`--assignee`) ya da `@kullanıcı` yazmak: kullanıcı açıkça isim vermediyse kimse etiketlenmez.
