# Araç betikleri

Projedeki tüm tekrarlayan işler bu klasördeki betiklerle yapılır. Hepsi proje kökünden
`bash tool/<betik>.sh` ile çalışır ve `--help` ile kendi kullanımını yazar.

## Hızlı başvuru

| Betik | Ne yapar | Ne zaman |
|---|---|---|
| `setup.sh` | Bağımlılıkları kurar, kod üretir, git hook'unu kurar | Taze klonda, bir kez |
| `dev.sh` | Uygulamayı Chrome'da çalıştırır | Geliştirirken |
| `codegen.sh` | `*.g.dart` ve yerelleştirme dosyalarını üretir | `@riverpod`, rota, model ya da ARB değişince |
| `quality_gate.sh` | Tüm kontrolleri sırayla çalıştırır | Commit ve PR öncesi |
| `build_web.sh` | Release web derlemesi (`build/web`) | Yayın öncesi; CI kullanır |
| `check_hardcode.sh` | Sabit renk, boşluk, metin, ikon yakalar | Kapı çalıştırır; tek başına da çalışır |
| `check_boundaries.sh` | Katman ve paket import kurallarını denetler | Kapı çalıştırır |
| `check_no_hard_delete.sh` | Kayıt/dosya silme çağrılarını yakalar | Kapı çalıştırır |
| `install_hooks.sh` | Git pre-commit hook'unu kurar ya da kaldırır | `setup.sh` çalıştırır |
| `test/run.sh` | Denetim betiklerinin öz-testi | Bir kuralın desenini değiştirince |

## Günlük akış

1. İlk kez: `bash tool/setup.sh`
2. Çalıştır: `bash tool/dev.sh`
3. Kod üreten bir şey değiştiyse: `bash tool/codegen.sh` (ya da ayrı sekmede `--watch`)
4. Ara kontrol: `bash tool/quality_gate.sh --fast`
5. Commit öncesi: `bash tool/quality_gate.sh`

## Betikler

### `setup.sh`

```bash
bash tool/setup.sh
```

Sırasıyla araçları denetler (`flutter`, `dart`, `git`), `codegen.sh` çalıştırır, git hook'unu
kurar ve öz-testi koşturur. Tekrar çalıştırmak zararsızdır.

### `dev.sh`

```bash
bash tool/dev.sh                    # Chrome, sahte veri (ENV=mock)
bash tool/dev.sh --env emulator     # Firebase emülatörü (backend fazı)
bash tool/dev.sh --env prod         # gerçek Firebase projesi — gerçek veri
bash tool/dev.sh --port 5000        # sabit port
bash tool/dev.sh --server           # tarayıcı açmaz; ağdaki başka cihazdan bakmak için
bash tool/dev.sh --profile          # tanınmayan argümanlar flutter run'a geçer
```

`--env` değeri uygulamaya `--dart-define=ENV=<değer>` olarak geçer;
`lib/core/env/app_environment.dart` okur ve hangi repository'lerin kaydedileceğini belirler.

### `codegen.sh`

```bash
bash tool/codegen.sh           # bir kez üret
bash tool/codegen.sh --watch   # dosya değiştikçe yeniden üret (yalnızca kök)
bash tool/codegen.sh --clean   # önbelleği temizle, baştan üret
```

Sıra: `flutter pub get` → yerel paketlerde `build_runner` → `gen-l10n` (`l10n.yaml` varsa) →
kökte `build_runner`. Üretilen dosyalar (`*.g.dart`, `lib/l10n/app_localizations*.dart`)
commit edilmez; taze klonda ve dal değiştirince yeniden üretilmeleri gerekir.

Üreticilerin hangi klasörlerde çalıştığı `build.yaml` içinde tanımlıdır.

### `quality_gate.sh`

```bash
bash tool/quality_gate.sh                 # tam kapı
bash tool/quality_gate.sh --fast          # codegen yok, test kapsamsız
bash tool/quality_gate.sh --static        # codegen ve test yok
bash tool/quality_gate.sh --check-format  # biçimlendirmeyi uygulamaz, yalnızca doğrular
bash tool/quality_gate.sh --verbose       # adım çıktılarını akıtır
```

| Adım | Tam | `--fast` | `--static` |
|---|---|---|---|
| bağımlılık (`flutter pub get`) | ✓ | yalnızca paketler hiç çözülmemişse | yalnızca paketler hiç çözülmemişse |
| format (`dart format`) | ✓ | ✓ | ✓ |
| codegen | ✓ | – | – |
| analyze (`--fatal-infos --fatal-warnings`) | ✓ | ✓ | ✓ |
| araç öz-testi | ✓ | ✓ | ✓ |
| sınırlar, hardcode, hard-delete | ✓ | ✓ | ✓ |
| test | ✓ kapsam raporlu | ✓ | – |
| rules (Firebase kural testleri) | ✓ `firebase/package.json` varsa | – | – |

- Bayraksız çalıştırınca `format` adımı dosyaları **yeniden biçimlendirir**. Yalnızca doğrulamak
  için `--check-format` ekle (CI ve pre-commit böyle çalışır).
- Bağımlılık adımı biçim denetiminden önce gelir: paketler çözülmeden `dart format` analiz ayarlarını
  bulamaz ve taze klonda her dosyayı "değişmeli" sayar.
- `--fast` ve `--static` üretilmiş dosyaların güncel olduğunu varsayar. Analyze "dosya bulunamadı"
  diyorsa önce `bash tool/codegen.sh` çalıştır.
- Başarısız adımın son 40 satırı ekrana yazılır; tam log `tool/.cache/gate-logs/` altındadır.
- `TF_GATE_STATIC_ONLY=1` ile flutter/dart adımları atlanır (Flutter kurulu olmayan ortam).
- Çıkış kodu: `0` yeşil, `1` kırmızı, `2` kullanım hatası.

### `build_web.sh`

```bash
bash tool/build_web.sh                      # ENV=prod, kök adreste yayın
bash tool/build_web.sh --env mock           # sahte veriyle (önizleme)
bash tool/build_web.sh --base-href /alt/    # alt klasörde yayın
bash tool/build_web.sh --no-codegen         # kod üretimini atla
```

Çıktı `build/web` altındadır. Yerelde bakmak için:

```bash
(cd build/web && python3 -m http.server 8080)
```

### Denetim betikleri

Üçü de aynı bayrakları alır:

```bash
bash tool/check_hardcode.sh                       # tüm proje
bash tool/check_hardcode.sh --list                # kural listesi
bash tool/check_hardcode.sh --files lib/a.dart    # yalnızca verilen dosyalar
bash tool/check_hardcode.sh --root <dizin>        # başka bir proje kökü
```

Çıktı biçimi: `dosya:satır: [KURAL] açıklama` ve altında ilgili satır.
Çıkış kodu: `0` temiz, `1` ihlal, `2` kullanım hatası.

| Betik | Kurallar | Satır içi istisna |
|---|---|---|
| `check_hardcode.sh` | `HC00`–`HC18` | `// ignore-hardcode: <gerekçe>` |
| `check_boundaries.sh` | `B03`–`B09` | yok |
| `check_no_hard_delete.sh` | `HD01`–`HD05`, `HD20`–`HD22` | yalnızca `FieldValue.delete()` için `// allow-field-delete: <gerekçe>` |

İstisna işareti ihlalli satırın sonuna ya da hemen üstündeki yorum satırına yazılır.
Gerekçesiz işaret de ihlaldir (`HC00`).

Hardcode denetiminin serbest bölgeleri:

| Klasör | Neden serbest |
|---|---|
| `lib/product/theme/` | Renk, boşluk, yazı ve süre token'ları burada tanımlanır |
| `lib/product/icon/` | `TfIcons` kayıt defteri; `Icons.*` yalnızca burada geçer |
| `lib/core/constants/` | Adres ve iş süresi sabitleri |
| `lib/core/error/` | Logger; `debugPrint` yalnızca burada |

Sınır denetiminde "kompozisyon kökü" sayılan ve feature view'larını import edebilen dosyalar:
`lib/main.dart`, `lib/core/bootstrap/*`, `lib/core/di/project_dependency.dart`,
`lib/core/env/app_environment.dart`, `lib/product/navigation/*`.

### `install_hooks.sh`

```bash
bash tool/install_hooks.sh            # kur
bash tool/install_hooks.sh --remove   # kaldır
```

Git'e hook klasörü olarak `tool/hooks` gösterilir (`git config core.hooksPath`). Ayar yalnızca
o klona yazılır. Kurulan `pre-commit`, Dart/ARB/rules/pubspec ya da `tool/` değiştiğinde
`quality_gate.sh --static --check-format` çalıştırır; kapı kırmızıysa commit durur.

### `test/run.sh`

```bash
bash tool/test/run.sh            # 43 kontrol
bash tool/test/run.sh --verbose  # denetim çıktılarıyla
```

Denetim betiklerini `test/fixtures/clean` (ihlalsiz) ve `test/fixtures/violating` (her kuraldan
en az bir ihlal) ağaçlarına karşı çalıştırır. Yeni kural eklerken: ihlal örneğini `violating`
ağacına, kural kimliğini `run.sh` içindeki listeye ekle.

## Claude Code hook'u

`tool/hooks/post_edit.sh`, Claude bir dosyayı yazdıktan hemen sonra o dosyada üç denetimi
çalıştırır ve ihlali aynı turda modele geri besler. Bağlamak için `.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          { "type": "command", "command": "bash \"$CLAUDE_PROJECT_DIR/tool/hooks/post_edit.sh\"" }
        ]
      }
    ]
  }
}
```

Elle denemek için:

```bash
echo '{"tool_input":{"file_path":"lib/main.dart"}}' | bash tool/hooks/post_edit.sh; echo $?
```

Çıkış `0` temiz, `2` ihlal demektir.

## CI'da kullanım

```yaml
- uses: subosito/flutter-action@v2
  with:
    flutter-version: 3.44.9
    channel: stable
    cache: true
- run: bash tool/quality_gate.sh --check-format
```

Yayın iş akışında derleme adımı: `bash tool/build_web.sh`.

## Bilinen sınırlar

- Denetimler satır satır çalışır. Birden çok satıra bölünmüş bir ifade (ör. argümanları alt
  satırlarda olan `EdgeInsets.only(`) `HC04`'ten kaçabilir; `HC15` çoğunu ayrıca yakalar.
- Yorum algılama basittir: `//` ile başlayan satırlar ve satır sonu yorumları atlanır; çok satırlı
  `/* … */` bloklarının iç satırları kod sayılabilir.
- Rules dosyalarında yalnızca tek satıra yazılmış `allow …;` ifadeleri denetlenir.
- Betikler bash 3.2 (macOS) ve BSD awk / mawk / gawk ile çalışacak şekilde yazılmıştır; desenlerde
  `\b`, `\s`, `\d` kullanılmaz.
