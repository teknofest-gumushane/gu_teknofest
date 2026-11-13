# Ekip Rehberi

Bu belge ekibe yeni katılan biri içindir: projeyi kurmak, mimariyi anlamak ve **yapay zekâ ile**
(Claude Code) bir özelliği baştan sona geliştirmek için gereken her şey burada. Daha önce hiç yapay
zekâ aracı kullanmamış olduğun varsayılır.

| Ne kadar vaktin var? | Oku |
|---|---|
| 5 dakika | [Bir bakışta](#0-bir-bakışta) |
| 20 dakika | + [Kurulum](#2-kurulum-bir-kez), [Yapay zekâ ile çalışmanın temelleri](#4-yapay-zekâ-ile-çalışmanın-temelleri) |
| İlk görevinden önce | + [Bir özelliği baştan sona geliştirme](#5-bir-özelliği-baştan-sona-geliştirme) |

Kuralların tek doğru kaynağı [`CLAUDE.md`](../CLAUDE.md) dosyasıdır; bu rehber onu açıklar, yerine geçmez.

---

## 0. Bir bakışta

**Akış:** görev (issue) → dal → plan → onay → kod → kapı → PR → inceleme → birleştirme.

**Altı adımda bir görev:**

1. GitHub'da bir **Görev** issue'su al.
2. Terminalde proje klasöründe `claude` yaz.
3. Claude'a söyle: *"#12 numaralı görevi yapacağız. Dalı aç, sonra bana plan göster; onaylamadan dosyaya dokunma."*
4. Planı oku, düzelt, onayla. Claude yazsın.
5. Siteyi aç (`bash tool/dev.sh`), **kendi gözünle** bak. Sonra: *"Kalite kapısını çalıştır."*
6. Yeşilse: *"Commit et ve PR aç."*

**Beş altın kural:**

1. **Önce plan, sonra kod.** Planı onaylamadan yazdırma.
2. **Küçük adım.** Bir görev = bir kişi = bir dal = bir PR.
3. **Güvenme, doğrula.** "Çalışıyor" dediyse siteyi aç ve bak; "testler geçti" dediyse çıktıyı gör.
4. **Kırmızıyken commit yok.** Kalite kapısı yeşil olmadan PR açılmaz.
5. **Anlamadığını onaylama.** Sor: *"Bunu neden böyle yaptın, daha basit yolu var mı?"*

---

## 1. Proje ne, şu an nerede

Gümüşhane Üniversitesi Teknofest Kulübü'nün web sitesi. Flutter web ile yazılıyor, verisi Firebase'de
duracak. Özellik ve düzen olarak [mauteknofest.com](https://mauteknofest.com) örnek alınıyor; **içerik
(metin, fotoğraf, kişi adı) bize ait**, oradan kopyalanmıyor. Ne yapılacağının tarifi:
[`analiz.md`](analiz.md).

Çalışma iki fazda:

| Faz | Ne | Durum |
|---|---|---|
| Arayüz | Tüm ekranlar **sahte veriyle** (`assets/mock/`) yazılır | **şu an buradayız** |
| Backend | Firebase bağlanır, güvenlik kuralları yazılır | arayüz bitince |

**Hazır olanlar** (ekip altyapısı):

- Kurallar ve kararlar: `CLAUDE.md`, `docs/`.
- Veri paketi `packages/tf_data`: 7 model, repository'ler, sahte veriyle çalışan uygulamaları, Firebase servisleri (bağlı değil).
- Tema: renkler, boşluklar, yazı stilleri, ortak widget'lar.
- Ana sayfanın kabuğu: üst bar, çekmece menü ve yedi bölüm. Bölümler şu an "Bu bölüm yakında gelecek" yazıyor.
- Otomasyon: kalite kapısı, hook'lar, CI, 14 skill, 5 agent, issue ve PR şablonları.

**Sırada olanlar:** bölümlerin içeriği (her biri ayrı görev), Takıma Katıl formu, admin paneli, sonra backend.

**Bilinçli olarak yok:** AI asistan kutusu, web yayını (şimdilik yerelde çalışır).

---

## 2. Kurulum (bir kez)

### Gerekenler

| Ne | Neden | Not |
|---|---|---|
| Flutter **3.50.0** (Dart 3.14) | Projeyi derler | Sürüm aynı olmalı; CI de bunu kullanır. Daha eski sürümle derlenmez (D-32) |
| git | Sürüm kontrolü | |
| Chrome | Siteyi çalıştırır | |
| GitHub hesabı | Depoya erişim | `teknofest-gumushane` organizasyonuna eklenmiş olmalısın |
| GitHub CLI (`gh`) | Issue ve PR işlemleri | Kurduktan sonra bir kez `gh auth login` |
| Claude Code | Yapay zekâ aracı | Claude aboneliği (Pro, Max, Team …) ya da Console hesabı gerekir |

Windows kullanıyorsan: projedeki betikler `bash` ile çalışır; **Git for Windows** (Git Bash) ya da WSL
kur ve komutları orada çalıştır. Betikler Windows'ta denenmedi; sorun çıkarsa issue aç.

### Adımlar

1. Depoyu klonla ve içine gir:

   ```bash
   git clone https://github.com/teknofest-gumushane/gu_teknofest.git && cd gu_teknofest
   ```

2. Projeyi kur (bağımlılıklar, kod üretimi, commit öncesi denetim):

   ```bash
   bash tool/setup.sh
   ```

3. Siteyi aç:

   ```bash
   bash tool/dev.sh
   ```

   Chrome'da sahte veriyle açılır; Firebase hesabı gerekmez. Kapatmak için terminalde `q`.

4. GitHub CLI'a giriş yap:

   ```bash
   gh auth login
   ```

5. Claude Code'u kur. macOS, Linux ya da WSL:

   ```bash
   curl -fsSL https://claude.ai/install.sh | bash
   ```

   Windows PowerShell:

   ```powershell
   irm https://claude.ai/install.ps1 | iex
   ```

   Kurulumu doğrula (yeni bir terminal penceresinde):

   ```bash
   claude --version
   ```

6. Proje klasöründe başlat ve tarayıcıda giriş yap:

   ```bash
   claude
   ```

Terminal yerine masaüstü uygulaması ya da VS Code eklentisi de kullanılabilir; projedeki kurallar,
skill'ler ve hook'lar hepsinde aynı çalışır. Güncel kurulum seçenekleri:
[Claude Code hızlı başlangıç](https://code.claude.com/docs/en/quickstart).

### Kurulum tamam mı?

```bash
bash tool/quality_gate.sh --check-format
```

Son satır `YEŞİL` ise hazırsın.

---

## 3. Mimari — 5 dakikada

Ayrıntı: [`architecture.md`](architecture.md). Bilmen gereken kadarı:

```
features/  ──►  product/  ──►  core/  ──►  tf_data
 (ekranlar)    (ortak parça)  (altyapı)   (veri)
```

Ok "import eder" demek. **Tersi yasak**, feature'lar da birbirini import edemez.

### Ne nereye girer?

| Yazacağın şey | Yeri |
|---|---|
| Ana sayfanın bir bölümü | `lib/features/landing/view/section/<ad>_section.dart` |
| O bölümün verisi ve durumu | `lib/features/landing/provider/<ad>_view_model.dart` + `<ad>_state.dart` |
| Yalnızca o bölümde kullanılan parça | `lib/features/landing/view/widget/` |
| Birden çok yerde kullanılan parça | `lib/product/widget/` |
| Renk, boşluk, ölçü, yazı stili | `lib/product/theme/` (ve [`token-map.md`](token-map.md)) |
| İkon | `lib/product/icon/tf_icons.dart` |
| Ekranda görünen metin | `lib/l10n/app_tr.arb` |
| Model, repository | `packages/tf_data/lib/src/` |
| Sahte veri | `assets/mock/*.json` |
| Test | `test/` altında, kodla aynı klasör yapısında |

### Veri nasıl akar?

```
bölüm (view) ──izler──► view model ──çağırır──► repository ──► sahte veri (şimdi) / Firebase (sonra)
```

- Bölüm yalnızca **çizer**; veriyi view model getirir.
- View model her çağrıda iki sonucu da ele alır: başarı ve hata.
- Her bölüm dört durumu gösterir: **hata → yükleniyor → boş → dolu**.

### Ekran koduna yazılmayanlar

Bunlar `tool/check_hardcode.sh` tarafından otomatik yakalanır:

| Yazma | Yerine |
|---|---|
| `Color(0xFF…)`, `Colors.red` | `context.tf.colors.primary` |
| `SizedBox(height: 16)`, `EdgeInsets.all(12)` | `TfGap.h16`, `TfInsets.all12` |
| `TextStyle(fontSize: 18)` | `context.tf.text.bodyLarge` |
| `Text('Projeler')` | `Text(context.l10n.navProjects)` |
| `Icons.menu` | `TfIcon(TfIcons.menu)` |

Bunları ezberlemene gerek yok: Claude kuralları biliyor, unutursa hook uyarıyor. Senin işin **planda ve
PR'da bunlara uyulduğunu görmek**.

---

## 4. Yapay zekâ ile çalışmanın temelleri

### 4.1 Claude Code nedir?

Terminalde çalışan bir yapay zekâ yardımcısı. Ona Türkçe yazarsın; o dosyaları okur, kod yazar, komut
çalıştırır ve sana ne yaptığını anlatır. Kodu elle yazmıyoruz; **ne istediğimizi tarif ediyor, çıkanı
denetliyoruz**.

İyi yaptığı: kuralları izlemek, tekrarlı kod, test yazmak, hata aramak, belge okuyup özetlemek.
Yapamadığı: senin yerine karar vermek, ekranın "güzel" olup olmadığını senin gözünle görmek, kulübün
gerçek içeriğini bilmek. Bunlar sende.

### 4.2 Bu projede Claude neleri zaten biliyor?

Proje klasöründe `claude` yazdığında şunlar kendiliğinden devreye girer; ayrıca anlatmana gerek yok:

| Ne | Nerede | Ne işe yarar |
|---|---|---|
| Kurallar | `CLAUDE.md` | Her oturumda okunur: mimari, yasaklar, akış |
| Skill'ler | `.claude/skills/` | Belirli işlerin "nasıl yapılır" kılavuzu; konu açılınca kendiliğinden yüklenir |
| Agent'lar | `.claude/agents/` | Yalnızca okuyan denetçiler; ikinci göz |
| Hook | `.claude/settings.json` | Claude bir dosya yazınca kuralları anında denetler, ihlali ona geri bildirir |
| İzinler | `.claude/settings.json` | Hangi komutlar sormadan çalışır, hangileri yasak |

### 4.3 Temel kullanım

| Yapmak istediğin | Nasıl |
|---|---|
| Başlatmak | Proje klasöründe `claude` |
| Kaldığın konuşmaya dönmek | `claude -c` |
| Komutları ve skill'leri görmek | `/` yaz |
| Yardım | `/help` |
| Konuşmayı sıfırlamak (yeni göreve geçerken) | `/clear` |
| Çıkmak | `/exit` |
| İzin kipini değiştirmek (ör. plan kipi) | `Shift+Tab` |
| Claude'u durdurmak | `Esc` |

**Her yeni görevde `/clear` yaz.** Eski konuşma Claude'un aklını karıştırır.

### 4.4 İzin soruları: neye "evet", neye "dur"?

Claude bazı işlerden önce izin ister. Okumadan "evet" deme.

| Soru | Karar |
|---|---|
| Dosya okuma, arama, `flutter test`, `bash tool/…` | Evet |
| `lib/`, `test/`, `packages/` altında dosya yazma | Evet, **planı onayladıysan** |
| `git commit`, `git push`, issue ya da PR açma | Yalnızca sen istediysen |
| `pubspec.yaml`'a yeni paket | Dur: [`packages.md`](packages.md)'de var mı? Yoksa ekibe sor |
| `git push --force`, `git reset --hard`, `firebase deploy` | **Hayır.** Proje sahibine sor |
| Anlamadığın herhangi bir komut | Dur ve sor: *"Bu komut ne yapıyor, neden gerekli?"* |

### 4.5 İyi istek nasıl yazılır?

1. **Sonucu söyle**, yöntemi değil.
2. **Sınırı çiz:** hangi görev, hangi bölüm, neye dokunulmayacak.
3. **Kaynağı göster:** issue numarası, `docs/analiz.md` başlığı.
4. **Plan iste** ve onaysız yazmamasını söyle.
5. **Bitmiş sayılma ölçütünü** ver.

| Kötü | İyi |
|---|---|
| "Projeler kısmını yap" | "#12 numaralı görevi yapacağız. Issue'yu ve `docs/analiz.md`'deki Projeler başlığını oku, bana numaralı plan göster. Onaylamadan dosyaya dokunma." |
| "Hata var düzelt" | "Telefonda (375 px) çekmeceden Galeri'ye basınca menü kapanıyor ama sayfa kaymıyor. Önce nedenini bul ve bana anlat, sonra düzeltme öner." |
| "Güzel olsun" | "Kartlar arası boşluk üst bardaki boşlukla aynı olsun; `docs/token-map.md`'deki token'ları kullan." |
| "Hepsini bitir" | "Yalnızca etiket filtresini yap. Arama kutusu ayrı görev, dokunma." |

### 4.6 Altın döngü

```
plan iste → planı oku → düzelt / onayla → yazdır → kendi gözünle bak → kapıyı çalıştır
```

Planı okurken sor:

- Görevdeki **her kabul ölçütü** planda var mı?
- Dokunulacak dosyalar görevdekiyle aynı mı? Fazlası var mı?
- "Kapsam dışı" yazılanlardan biri plana girmiş mi?
- Test yazılacak mı?
- Anlamadığın bir adım var mı? Varsa açıklat.

### 4.7 Güvenme, doğrula

Claude yanılabilir ve yanıldığında da kendinden emin konuşur. Şunlara **kendin** bak:

| Claude der ki | Sen yap |
|---|---|
| "Bölüm hazır" | `bash tool/dev.sh` ile aç; masaüstü ve telefon genişliğinde bak |
| "Testler geçti" | Çıktıdaki sayıyı gör; "kaç test, kaçı geçti?" diye sor |
| "Kapı yeşil" | Son satırda `YEŞİL` yazısını kendin gör |
| "Referans siteyle aynı" | İki siteyi yan yana aç |
| "Bunu değiştirmem gerekti" (görev dışı dosya) | Neden gerektiğini sor; ikna olmadıysan geri aldır |

### 4.8 Ne zaman duracaksın?

| Belirti | Ne yap |
|---|---|
| Aynı hatayı üç kez "düzeltti", hâlâ bozuk | Durdur (`Esc`). *"Düzeltmeyi bırak. Hangi varsayımın yanlış olabilir? Önce nedenini bulalım."* |
| Görev büyüyor, ilgisiz dosyalara giriyor | Durdur. Fazlasını ayrı issue yap |
| Bir kuralı ya da kilitli kararı (D-xx) değiştirmek istiyor | Onaylama. Ekibe sor; karar değişecekse [`decisions.md`](decisions.md)'ye işlenir |
| Testi silmek ya da atlamak istiyor | Hayır. Test kırıksa ya kod ya test yanlıştır; hangisi olduğunu buldur |
| Konuşma çok uzadı, saçmalamaya başladı | Yaptıklarını commit ettir, `/clear`, kaldığın yeri kısaca anlatıp devam et |

---

## 5. Bir özelliği baştan sona geliştirme

Örnek: **#12 — Projeler bölümü**. Her adımda Claude'a yazacağın cümle ve senin bakacağın şey var.

### Adım 1 — Görevi al

GitHub → Issues → bir **Görev** seç. Üzerinde çalıştığını issue'ya yorum olarak yaz ki başkası almasın.
Görev yoksa ya da belirsizse Claude'a yazdırabilirsin:

```text
Projeler bölümü için bir görev taslağı hazırla. Açma, önce bana göster.
```

### Adım 2 — Oturumu başlat

```bash
cd gu_teknofest && git switch main && git pull --ff-only origin main && claude
```

Önceki konuşmadan kalma bir şey varsa `/clear`.

### Adım 3 — Dalı açtır

```text
#12 numaralı görev için dal aç.
```

**Bak:** dal adı `feat/12-projeler-bolumu` biçiminde mi (`tür/issue-no-kısa-ad`).

### Adım 4 — Plan iste

```text
#12 numaralı görevi yapacağız. Issue'yu, docs/analiz.md'deki "Projeler" başlığını ve
mevcut bölüm dosyasını oku. Bana numaralı bir plan göster: hangi dosyalar, hangi durumlar,
hangi testler. Ben onaylamadan dosyaya dokunma.
```

**Bak:** [4.6](#46-altın-döngü)'daki sorular. Belirsiz bir nokta varsa Claude sana seçenekli bir soru
penceresi açar; cevapla.

### Adım 5 — Onayla ve yazdır

```text
Plan uygun. 3. adımdaki arama kutusunu çıkar, o ayrı görev. Geri kalanını uygula.
```

Claude yazarken hook her dosyayı denetler. "Hook uyardı, düzeltiyorum" derse sorun yok; bu beklenen
davranıştır.

### Adım 6 — Kendi gözünle bak

Başka bir terminalde:

```bash
bash tool/dev.sh
```

**Bak:** masaüstü genişliği, sonra tarayıcıyı daraltıp telefon genişliği. Yükleniyor durumu görünüyor
mu? Metinler taşıyor mu? Beğenmediğini tarif et:

```text
Telefonda kart başlıkları iki satıra taşınca kartların boyu eşit durmuyor. Düzelt.
```

### Adım 7 — Test ve kalite kapısı

```text
Eksik test var mı kontrol et, sonra tam kalite kapısını çalıştır.
```

**Bak:** son satır `YEŞİL — 9/9 adım geçti`. Kırmızıysa Claude ilk hatayı düzeltir; sen yine son satıra
bakarsın.

### Adım 8 — Denetçileri çalıştır

```text
tf-architecture-reviewer ve tf-test-auditor agent'larını bu değişiklik için çalıştır.
Arayüz değiştiği için tf-site-parity-reviewer'ı da çalıştır. Bulguları bana özetle.
```

**Bak:** "Kritik" bulgu varsa düzelttir, sonra kapıyı yeniden çalıştır.

### Adım 9 — Commit ve PR

```text
Commit et ve PR aç.
```

**Bak:** PR başlığı `feat(landing): projeler bölümünü ekle` gibi mi; gövdede `Closes #12` var mı;
işaretli kutular **gerçekten** yapılmış mı; ekran görüntüsü eklenmiş mi (ekleyemediyse sen ekle).

### Adım 10 — İnceleme ve birleştirme

- CI yeşil olmalı ve en az bir ekip arkadaşı onaylamalı.
- Yorum geldiyse: *"PR'daki inceleme yorumlarını oku ve tek tek cevapla; düzeltme gerekenleri yap."*
- Birleştirmeyi proje sahibi yapar (squash). Sonra:

  ```bash
  git switch main && git pull --ff-only origin main && git branch -d feat/12-projeler-bolumu
  ```

---

## 6. Dikkat edilecekler

**Her zaman**

1. Yeni göreve `main`'i güncelleyip yeni dalla başla.
2. Önce plan iste, okuyup onayla.
3. Bölümde dört durumu da gör: hata, yükleniyor, boş, dolu.
4. Telefon genişliğinde (320 px'e kadar) bak.
5. PR'dan önce tam kalite kapısı.

**Asla**

1. `main`'e doğrudan commit (proje sahibinin açık isteği dışında).
2. Kırmızı kapıyla commit, `--no-verify`, `git push --force`.
3. Referans siteden metin, fotoğraf, logo ya da kişi adı kopyalamak.
4. Şifre, anahtar ya da kişisel veri (ad, e-posta, telefon) yapıştırmak: koda, issue'ya, PR'a, Claude'a.
5. `firebase deploy` ya da gerçek veriye yazan bir komut.

**En sık yapılan hatalar**

| Hata | Sonucu | Önlemi |
|---|---|---|
| Plansız "yap" demek | Kapsam büyür, yanlış dosyalar değişir | Her zaman önce plan |
| Tek görevde üç iş | PR incelenemez, çakışma çıkar | Böl: bir görev = bir PR |
| Ekrana bakmadan PR açmak | "Çalışıyor" ama bozuk görünüyor | Adım 6'yı atlama |
| İki kişi aynı dosyada | Birleştirme çakışması | Görevdeki "dokunulacak dosyalar"a bak |
| Kod üretimini unutmak | Analiz "dosya bulunamadı" der | `bash tool/codegen.sh` |
| Uzun, hiç sıfırlanmayan konuşma | Claude eski bilgiyle çalışır | Her görevde `/clear` |

---

## 7. Skill'ler

Skill, Claude'a bir işin bu projede **nasıl** yapılacağını anlatan kılavuzdur. Konu açılınca Claude
ilgili skill'i kendisi yükler; emin olmak istersen adını yaz (`/tf-testing`) ya da cümlende geçir.

| Skill | Ne zaman devreye girer | Örnek cümle |
|---|---|---|
| `tf-section-from-site` | Ana sayfanın bir bölümü yazılırken | "Galeri bölümünü yaz." |
| `tf-feature` | Yeni view model, state, repository | "Etkinlikler için view model ve state ekle." |
| `tf-widget` | Ortak widget yazılırken | "Etiket çipi için ortak bir widget lazım." |
| `tf-responsive` | Düzen, sütun sayısı, taşma | "Telefonda kartlar taşıyor." |
| `tf-l10n` | Ekrana metin eklenirken | "Boş durum için bir metin ekle." |
| `tf-navigation` | Rota, menü, kaydırma | "Menüye yeni bir bölüm ekle." |
| `tf-testing` | Test yazılırken | "Bu bölümün testlerini yaz." |
| `tf-quality-gate` | Kapı çalıştırılırken, kırmızıyken | "Kalite kapısını çalıştır." |
| `tf-soft-delete` | Silme, geri alma | "Admin'de proje silme düğmesi." |
| `tf-issue` | Görev, hata, öneri kaydı | "Bu hata için issue taslağı hazırla." |
| `tf-branch` | Dal açarken | "#12 için dal aç." |
| `tf-pr` | PR açarken, yorumlara cevap verirken | "PR aç." |
| `tf-ask-user` | Claude sana soru soracakken | (kendiliğinden) |
| `tf-decision-log` | Bir karar alındığında ya da değiştiğinde | "Bu kararı kayda geçir." |

---

## 8. Agent'lar

Agent, Claude'un ayrı bir oturumda çalıştırdığı **yalnızca okuyan** denetçidir. Kodu yazan Claude'un
söylediğine güvenmez, dosyaları kendi okur. Çağırmak için adını söylemen yeter:
*"tf-test-auditor agent'ını çalıştır."* Kesin çalışsın istersen başına `@agent-` koy:
`@agent-tf-test-auditor bu değişikliğe bak`.

| Agent | Ne yapar | Ne zaman |
|---|---|---|
| `tf-architecture-reviewer` | Katman, isimlendirme, hardcode, paket kurallarına bakar | Her iş bitince, PR'dan önce |
| `tf-test-auditor` | Testler eksik mi, atlanmış mı, dört genişlik denenmiş mi | Her iş bitince, PR'dan önce |
| `tf-site-parity-reviewer` | Bölüm tarife uyuyor mu; referans siteden içerik kopyalanmış mı | Arayüz değiştiyse |
| `tf-pr-reviewer` | PR'ı görevdeki kabul ölçütleriyle karşılaştırır, CI'ye bakar | PR açıldıktan sonra, birleştirmeden önce |
| `tf-issue-drafter` | Bir kapsam için görev taslakları, bağımlılık ve sıra çıkarır | Görevler toplu yazılacakken |

Agent'lar hiçbir şeyi değiştirmez: dosya yazmaz, issue ya da PR açmaz, yorum bırakmaz. Bulgularını
raporlar; ne yapılacağına sen karar verirsin.

---

## 9. Otomatik denetimler

Kuralları aklında tutman gerekmez; dört katman yakalar:

| Ne zaman | Ne çalışır | Kırmızı olursa |
|---|---|---|
| Claude bir dosya yazınca | Hook: hardcode, hard delete, katman sınırı | Claude uyarıyı görür ve düzeltir |
| `git commit` atılınca | pre-commit: biçim, analiz, denetimler | Commit durur; ilk hatayı düzelttir |
| Sen çalıştırınca | `bash tool/quality_gate.sh`: yukarıdakiler + kod üretimi + tüm testler | PR açma; düzelttir |
| Push ve PR'da | CI: aynı kapı + web derlemesi | PR birleştirilemez; Actions sekmesinde adımı aç |

Kapının adımları: bağımlılık → biçim → kod üretimi → analiz → araç öz-testi → sınırlar → hardcode →
hard-delete → test. Betiklerin tamamı: [`tool/README.md`](../tool/README.md).

---

## 10. Sorun giderme

| Belirti | Çözüm |
|---|---|
| Analiz "dosya bulunamadı" ya da `part` hatası veriyor | `bash tool/codegen.sh` (dal değiştirince de gerekir) |
| Commit durdu, "kalite kapısı kırmızı" | Claude'a: *"Commit durdu, çıktıdaki ilk hatayı düzelt."* |
| Kapı `format` adımında kırmızı | `dart format lib test packages` |
| Hook sürekli aynı satırda uyarıyor | Token eksik olabilir: *"Bu ölçü için token ekle ve token-map'i güncelle."* |
| PR'da CI kırmızı, yerelde yeşil | `bash tool/quality_gate.sh --check-format` ile yeniden üret; çıktıyı Claude'a ver |
| Dalın `main`'in gerisinde, çakışma var | Claude'a: *"main'i dalıma birleştir, çakışmaları çöz, kapıyı çalıştır."* |
| `claude` komutu bulunamıyor | Yeni terminal aç; hâlâ yoksa kurulum belgesindeki PATH adımı |
| Claude İngilizce cevap veriyor | *"Türkçe yaz."* (kural `CLAUDE.md`'de; yeni oturumda kendiliğinden Türkçe olur) |
| Site açılıyor ama boş / eski | Terminalde `R` (yeniden başlat) ya da `q` ile kapatıp `bash tool/dev.sh` |

---

## 11. Alınan kararlar (özet)

Tamamı ve gerekçeleri: [`decisions.md`](decisions.md). Sormadan değiştirilmezler.

| Konu | Karar |
|---|---|
| Sıra | Önce arayüz sahte veriyle, sonra Firebase (D-01) |
| Mimari | Feature-first + `product/` + yerel paket `tf_data` (D-02, D-03) |
| State / DI / rota | Riverpod Notifier + Equatable, GetIt, typed go_router (D-05 – D-07) |
| Dil | Metinler ARB'de, yalnız Türkçe (D-09) |
| Silme | Soft delete; hard delete yok (D-10) |
| İkon | Hazır ikon varsa o, yoksa SVG; hepsi `TfIcons` üzerinden (D-11) |
| Paketler | Listede olmayan paket eklenmez; `cached_network_image`, `flutter_animate`, `google_fonts` yok (D-12, D-13, D-20) |
| Başvuru formu | Firestore'a yazar; admin'e "Başvurular" ekranı (D-14) |
| Logo | Resmi TEKNOFEST logosu; değiştirilmez, yeniden çizilmez (D-24) |
| Çalışma biçimi | Plan → onay → uygulama; seçenekli sorular pencereyle (D-25) |
| Git akışı | Issue → dal → PR; squash; CI yeşil + bir onay (D-19, D-27) |
| Kapsam dışı | AI asistan (D-17), web yayını (D-22) |

---

## 12. Sözlük

| Terim | Anlamı |
|---|---|
| Issue | GitHub'daki iş kaydı; bizde "görev" |
| Dal (branch) | Kodun, `main`'i bozmadan çalıştığın kopyası |
| Commit | Değişikliklerin kayıtlı bir adımı |
| PR (pull request) | Dalındaki değişiklikleri `main`'e alma isteği; inceleme burada yapılır |
| CI | Her push'ta GitHub'da otomatik çalışan kalite kapısı |
| Kalite kapısı | Biçim, analiz, kural denetimleri ve testlerin tek komutla çalışması |
| Hook | Belirli bir olayda (dosya yazma, commit) kendiliğinden çalışan denetim |
| Skill | Claude'a bir işin bu projede nasıl yapılacağını anlatan kılavuz |
| Agent | Ayrı çalışan, yalnızca okuyan denetçi |
| Token | Renk, boşluk, ölçü gibi tasarım değerlerinin adlandırılmış hali |
| View model / state | Bir ekranın verisini getiren sınıf ve o verinin anlık hali |
| Repository | Verinin nereden geldiğini (sahte / Firebase) ekrandan gizleyen katman |
| Sahte veri (mock) | Firebase yokken ekranları doldurmak için kullanılan örnek veri |
| Soft delete | Kaydı silmek yerine "silindi" diye işaretlemek |
| Kod üretimi (codegen) | Bazı dosyaların (`*.g.dart`) araçla otomatik yazılması |

---

## 13. Hangi belge nerede?

| Soru | Belge |
|---|---|
| Kural ne diyor? | [`CLAUDE.md`](../CLAUDE.md) |
| Akışın kısa hali | [`CONTRIBUTING.md`](../CONTRIBUTING.md) |
| Ne yapılacak, referans site nasıl? | [`analiz.md`](analiz.md) |
| Klasörler ve katmanlar | [`architecture.md`](architecture.md) |
| Neden böyle karar verildi? | [`decisions.md`](decisions.md) |
| Hangi renk, boşluk, yazı stili? | [`token-map.md`](token-map.md) |
| Hangi paket kullanılabilir? | [`packages.md`](packages.md) |
| Betikler ne yapıyor? | [`tool/README.md`](../tool/README.md) |
