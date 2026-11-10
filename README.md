# GÜ Teknofest

Gümüşhane Üniversitesi Teknofest Kulübü web sitesi. Flutter web + Firebase.

Şu an arayüz fazındadır: site sahte veriyle çalışır, Firebase bağlantısı arayüz bitince yapılacaktır.
Genel sayfanın üst barı, çekmece menüsü ve bölüm iskeleti hazırdır; bölümlerin içeriği "yakında gelecek"
yer tutucusuyla durur ve ekip tarafından tek tek yazılacaktır.

## Hızlı başlangıç

Gerekenler: Flutter 3.44.9 (Dart 3.12), git, Chrome.

```bash
bash tool/setup.sh
```

```bash
bash tool/dev.sh
```

İlk komut bağımlılıkları kurar, kodu üretir ve commit öncesi denetimi kurar; ikincisi siteyi Chrome'da açar.

## Commit öncesi

```bash
bash tool/quality_gate.sh
```

Yeşil olmalı. Aynı kapı her push ve PR'da GitHub Actions'ta da çalışır (`.github/workflows/ci.yml`).

## Katkı akışı

Her iş **issue → dal → PR** yoluyla `main`'e girer: [`CONTRIBUTING.md`](CONTRIBUTING.md).

## Belgeler

| Ne | Nerede |
|---|---|
| Kurallar (tek doğru kaynak) | [`CLAUDE.md`](CLAUDE.md) |
| Ekip için kurulum ve günlük akış | [`CONTRIBUTING.md`](CONTRIBUTING.md) |
| Mimari ve klasör yapısı | [`docs/architecture.md`](docs/architecture.md) |
| Kilitli kararlar | [`docs/decisions.md`](docs/decisions.md) |
| Ne yapılacak: referans site analizi | [`docs/analiz.md`](docs/analiz.md) |
| Renk, boşluk ve yazı token'ları | [`docs/token-map.md`](docs/token-map.md) |
| İzin verilen paketler | [`docs/packages.md`](docs/packages.md) |
| Betikler ve kullanımları | [`tool/README.md`](tool/README.md) |

## Yapı

```
packages/tf_data/   veri katmanı: modeller, repository'ler, Firebase servisleri
lib/core/           başlatma, DI, ortam, hata/log, oturum
lib/product/        tema token'ları, ikonlar, yönlendirme, ortak widget'lar
lib/features/       landing (genel sayfa); auth ve admin sonraki turda
assets/mock/        sahte veri
```
