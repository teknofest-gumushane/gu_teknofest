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

## Günlük akış

1. `git pull`
2. Kod üreten bir şey değiştiyse (`@riverpod`, rota, model, ARB): `bash tool/codegen.sh`
3. Yaz, dene. Ara kontrol: `bash tool/quality_gate.sh --fast`
4. Commit öncesi: `bash tool/quality_gate.sh` — yeşil olmalı
5. Commit ve `git push` (doğrudan `main`; PR yok)

Başkası aynı anda push ettiyse: `git pull --rebase`, sonra tekrar push.

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

## Commit mesajı

Conventional Commits, açıklama Türkçe:

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
| Hardcode denetimi sayı ya da renge takıldı | `docs/token-map.md`'deki token'ı kullan; yoksa token'ı ekle |
| Bilinçli bir istisna gerekiyor | Satıra `// ignore-hardcode: <gerekçe>` yaz |

Betiklerin tamamı ve bayrakları: [`tool/README.md`](tool/README.md).
