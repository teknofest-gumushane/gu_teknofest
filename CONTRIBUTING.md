# Katkı Rehberi

Ekibe yeni katılan biri için: kurulumdan ilk commit'e kadar gereken her şey bu sayfada.
Kuralların tamamı [`CLAUDE.md`](CLAUDE.md) içindedir.

## Kurulum

Gerekenler: Flutter 3.44.9 (Dart 3.12), git, Chrome.

```bash
git clone https://github.com/teknofest-gumushane/gu_teknofest.git
```

```bash
cd gu_teknofest && bash tool/setup.sh
```

`setup.sh` bağımlılıkları kurar, kodu üretir ve commit öncesi denetimi (git hook) kurar.

## Çalıştırma

```bash
bash tool/dev.sh
```

Site Chrome'da sahte veriyle açılır. Firebase hesabı ya da ayarı gerekmez.
VS Code kullanıyorsan F5 de aynı şeyi yapar.

## Akış: issue → dal → PR

Her iş bir issue ile başlar, kendi dalında yürür ve bir PR ile `main`'e girer.

1. **Issue:** GitHub'da "New issue" → **Görev** şablonu. Bir görev = bir kişi = bir PR.
   Var olan bir görevi alıyorsan issue'ya yorum yazıp üzerine aldığını belirt.
2. **Dal:** `main`'den, adı `<tür>/<issue-no>-<kısa-ad>`:

   ```bash
   git switch main && git pull --ff-only origin main && git switch -c feat/12-projeler-bolumu
   ```

   Türler: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `ci`. Küçük harf, tire, Türkçe karaktersiz.
3. **Çalış:** kod üreten bir şey değiştiyse (`@riverpod`, rota, model, ARB) `bash tool/codegen.sh`.
   Ara kontrol: `bash tool/quality_gate.sh --fast`.
4. **Kapı:** `bash tool/quality_gate.sh` — yeşil olmalı.
5. **PR:** dalı push'la ve `main`'e PR aç; şablonu doldur, `Closes #12` yaz.

   ```bash
   git push -u origin feat/12-projeler-bolumu
   ```

6. **İnceleme:** CI yeşil ve en az bir onay gerekir. Yorumları yeni commit'lerle karşıla;
   PR açıldıktan sonra `git push --force` ve `git rebase` yok. `main` ilerlediyse `git merge origin/main`.
7. **Birleştirme:** squash ile, proje sahibi ya da yetki verdiği kişi tarafından. Sonra:

   ```bash
   git switch main && git pull --ff-only origin main && git branch -d feat/12-projeler-bolumu
   ```

`main`'e doğrudan commit atılmaz; tek istisna proje sahibinin açıkça istediği altyapı işleridir.

## Bir bölüme başlarken

Genel sayfanın her bölümü `lib/features/landing/view/section/` altında bir dosyadır ve şu an
"yakında gelecek" yazısını gösterir. Bir bölümü yazmak için:

1. `docs/analiz.md`'de o bölümün tarifini oku.
2. Bölüm dosyasında `TfComingSoon` yerine gerçek içeriği yaz; çerçeve (`TfSectionFrame`) kalır.
3. Veri gerekiyorsa `lib/features/landing/provider/` altına view model ve state ekle; veriyi `tf_data`'daki
   repository'den al.
4. Metinleri `lib/l10n/app_tr.arb`'ye ekle; renk, boşluk ve ölçü için token kullan (`docs/token-map.md`).
5. Test yaz (`test/features/landing/`).

İki kişi aynı dosyaya dokunmasın: bir bölüm = bir kişi.

## Commit ve PR başlığı

Conventional Commits, açıklama Türkçe. PR squash ile birleştiği için PR başlığı `main`'deki commit mesajı olur:

```
feat(landing): projeler bölümüne etiket filtresi ekle
fix(header): çekmece menü kapanınca odağı geri ver
docs: token tablosuna yeni gölgeyi ekle
```

## Sık karşılaşılanlar

| Belirti | Çözüm |
|---|---|
| Analyze "dosya bulunamadı" ya da `part` hatası veriyor | `bash tool/codegen.sh` |
| Commit durdu, "kalite kapısı kırmızı" yazıyor | Çıktıdaki ilk hatayı düzelt; biçimlendirme ise `dart format lib test packages` |
| PR'da CI kırmızı | Actions sekmesinde başarısız adımı aç; yerelde `bash tool/quality_gate.sh --check-format` ile yeniden üret |
| Dalın `main`'in gerisinde, çakışma var | `git merge origin/main`, çakışmayı çöz, `bash tool/codegen.sh`, kapıyı çalıştır |
| Hardcode denetimi sayı ya da renge takıldı | `docs/token-map.md`'deki token'ı kullan; yoksa token'ı ekle |
| Bilinçli bir istisna gerekiyor | Satıra `// ignore-hardcode: <gerekçe>` yaz |

Betiklerin tamamı ve bayrakları: [`tool/README.md`](tool/README.md).
