---
name: tf-issue
description: GitHub issue açma kuralları (görev, hata, öneri şablonları). Yeni bir iş kalemi tanımlarken, "issue aç", "görevleri yaz", "task'ları çıkar" dendiğinde ya da bir hatayı / öneriyi kayda geçirirken kullan.
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

- **Bir görev = bir kişi = bir PR.** Tek PR ile kapanamayacak kadar büyükse böl.
- Başlık sonucu söyler: `[Görev] Projeler: etiket filtresi ve arama`. "Projeler bölümü üzerinde çalış" değil.
- **Kabul ölçütleri denetlenebilir** maddelerdir (kutucuklu). Her bölüm görevinde şunlar bulunur: dört durum (hata / yükleniyor / boş / dolu), 320 / 768 / 1024 / 1440'ta taşma yok, metinler ARB'de, token kullanımı, testler, kapı yeşil.
- **Dokunulacak dosyalar** yazılır. İki görev aynı dosyaya dokunuyorsa (ör. `lib/l10n/app_tr.arb` hariç ortak bir widget) birini diğerine bağla; aynı anda yürümesinler.
- **Kapsam dışı** yazılır: görevin sınırı, bitmiş sayılması için en önemli bilgidir.
- Referans: `docs/analiz.md` başlığı ve ilgili D-xx. İçerik (metin, görsel, kişi adı) bize aittir; referans siteden kopyalanacak içerik göreve yazılmaz (`CLAUDE.md §12`).

## Adımlar

1. **Var mı bak:** `gh issue list --state all --search "<anahtar sözcük>"`. Varsa yenisini açma; eksikse ona yorum öner.
2. **Taslağı yaz.** Birden çok görev çıkarılacaksa (`"bölümlerin görevlerini yaz"`) `tf-issue-drafter` agent'ını çalıştır; sırayı ve bağımlılıkları da o önerir.
3. **Göster ve onay al.** Issue açmak depoya herkesin göreceği bir kayıt düşer: taslak(lar)ı kullanıcıya göster, `tf-ask-user` ile onay iste. Toplu açılışta önce liste (başlık + bir cümle), sonra onay.
4. **Aç.** Form şablonları `gh` ile doldurulamaz; gövdeyi formun başlıklarıyla Markdown yaz ve dosyadan ver:

   ```
   gh issue create --title "[Görev] Projeler: etiket filtresi ve arama" \
     --label enhancement --body-file <taslak.md>
   ```

   Gövde başlıkları formdakiyle aynı olur: `### Ne yapılacak?`, `### Alan`, `### Bölüm`, `### Kabul ölçütleri`, `### Dokunulacak dosyalar`, `### Kapsam dışı`, `### Referans`, `### Bağımlı olduğu görevler`.
5. **Bildir:** numara, adres ve varsa bağımlılık sırası.

## Etiketler

Yalnızca depoda var olanlar: `bug`, `enhancement`, `documentation`, `accessibility`, `good first issue`, `help wanted`, `question`. Yeni etiket gerekiyorsa önce sor; onaysız `gh label create` yok.

## Yapma

- ❌ Kişisel veri (ad, e-posta, telefon) ya da gizli anahtar içeren issue.
- ❌ Birden çok konuyu tek issue'da toplamak.
- ❌ Kilitli bir kararı (D-xx) issue ile değiştirmek: önce `tf-ask-user`, sonra `tf-decision-log`.
- ❌ Onaysız issue açmak, kapatmak ya da başkasının issue'sunu düzenlemek.
- ❌ Atama (`--assignee`) ya da `@kullanıcı` yazmak: kullanıcı açıkça isim vermediyse kimse etiketlenmez.
