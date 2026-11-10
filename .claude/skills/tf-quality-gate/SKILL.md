---
name: tf-quality-gate
description: tool/quality_gate.sh kalite kapısını çalıştırma ve çıktısını yorumlama. Commit öncesi, bir iş bitince, "kapı kırmızı", "commit durdu" ya da "hook uyardı" durumlarında kullan.
---

# tf-quality-gate

```
bash tool/quality_gate.sh                 # tam kapı — commit öncesi ŞART
bash tool/quality_gate.sh --fast          # ara kontrol: codegen yok, test kapsamsız
bash tool/quality_gate.sh --static        # yalnızca statik: codegen ve test yok
bash tool/quality_gate.sh --check-format  # biçimlendirmeyi uygulamaz, yalnızca doğrular
bash tool/quality_gate.sh --verbose       # adım çıktılarını akıtır
```

Sıra: **bağımlılık (`flutter pub get`) → format → codegen → analyze (`--fatal-infos --fatal-warnings`) → araç öz-testi → sınırlar → hardcode → hard-delete → test → rules** (yalnızca `firebase/package.json` varsa; backend fazı). Kırmızıyken **commit yok**, `--no-verify` yok (`CLAUDE.md §11`, `§12`). Betiklerin tamamı: `tool/README.md`.

## Modlar

| Mod | Ne zaman | Commit için yeterli mi |
|---|---|---|
| (bayraksız) | commit öncesi: tüm adımlar, test kapsam raporlu | ✅ |
| `--fast` | geliştirirken ara kontrol | ❌ |
| `--static` | hızlı statik bakış (git pre-commit hook'u `--static --check-format` çalıştırır) | ❌ |

- `--check-format` ve `--verbose` her modla birleşir; `--fast` ile `--static` birlikte verilmez.
- Bayraksız çalıştırınca `format` adımı dosyaları **yeniden biçimlendirir**. Yalnızca doğrulamak için `--check-format` ekle (CI ve pre-commit böyle çalışır).
- `--fast` ve `--static` üretilen dosyaların güncel olduğunu varsayar. Analyze "dosya bulunamadı" ya da `part` hatası veriyorsa önce `bash tool/codegen.sh`.
- Çıkış kodu: `0` yeşil, `1` kırmızı, `2` kullanım hatası.

## Çalıştırma notları (Claude Code)

- Bash aracının varsayılan zaman aşımı 2 dk'dır; tam kapı daha uzun sürebilir → `timeout: 600000` ver ya da arka planda çalıştır.
- Çıktı kısadır: her adım tek satır; başarısız adımın son 40 satırı gösterilir, tam log `tool/.cache/gate-logs/NN-ad.log`. Uzun logu bağlamına dökme; yalnızca ilgili kısmı oku.
- `TF_GATE_STATIC_ONLY=1` flutter/dart adımlarını atlar (yalnızca Flutter kurulu olmayan ortam için).
- Tek denetimi tek dosyada koşmak: `bash tool/check_hardcode.sh --files lib/a.dart`; kural listesi: `--list`.

## Hata → çözüm

| Adım | Tipik sebep | Çözüm |
|---|---|---|
| bağımlılık | `pubspec.yaml` çözülemiyor (sürüm çakışması, ağ) | Hata mesajındaki paketi düzelt; `docs/packages.md` sürüm politikası |
| format | biçimlenmemiş dosya (`--check-format`) | `dart format lib test packages` |
| codegen | `@riverpod`, rota, model ya da ARB hatası | Hatayı düzelt; gerekirse `bash tool/codegen.sh --clean` |
| analyze | `very_good_analysis`, `--fatal-infos`; eksik `*.g.dart` | Kodu düzelt; `// ignore:` yalnızca gerekçeli; eksik dosya → codegen |
| öz-test | `tool/check_*.sh` deseni ya da fixture değişti | `bash tool/test/run.sh --verbose` |
| sınırlar (B03–B09) | feature → feature, `lib/` → Firebase SDK, `package:tf_data/src/…`, `tf_data` → Flutter arayüzü | Katman ihlalini düzelt; satır içi istisna **yok** |
| hardcode (HC00–HC18) | renk, boşluk, köşe, yazı, süre, ölçü, metin, ikon, URL literali | Token / ARB / `TfIcons` / `AppConstants`; eksik token → `lib/product/theme/` + `docs/token-map.md`. Bilinçli istisna: `// ignore-hardcode: <gerekçe>` |
| hard-delete (HD01–HD22) | `.delete(`, `delete*` adlı metot, Rules'ta `allow write` | `softDelete` / `restore` (`tf-soft-delete`) |
| test | kırık ya da eksik test, taşma | Düzelt; **silme / skip yok** (`tf-testing`) |
| rules | (backend fazı) kural testi kırık, `firebase/node_modules` yok | `(cd firebase && npm ci)`, sonra `npm test` çıktısına bak |

## Hook'lar

- **Git pre-commit** (`tool/hooks/pre-commit`; `bash tool/install_hooks.sh` kurar): Dart / ARB / rules / pubspec ya da `tool/` değişince `quality_gate.sh --static --check-format`. Kırmızıysa commit durur. Test koşmaz; tam kapının yerini tutmaz.
- **Claude Code `PostToolUse`** (`tool/hooks/post_edit.sh`, `.claude/settings.json`): yazılan `.dart` dosyasında (`lib/`, `packages/*/lib`) hardcode + hard delete + sınır; `.rules` dosyasında hard delete; `packages/*/pubspec.yaml`'da sınır. İhlalde çıkış 2 ve mesaj geri beslenir. Uyarı = **düzelt**; gerekçesiz susturma yok.

## Rapor

Kapı sonucunu kullanıcıya tek satırda ver ("Kapı yeşil: 9/9 adım, 95 sn"). Kırmızıyı örtbas etme: başarısız adımı ve ilk hatayı yaz.
