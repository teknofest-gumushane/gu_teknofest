## Ne değişti?

<!-- Kısa özet. İlgili issue: Closes #123 -->

## Neden?

<!-- Sorun ya da ihtiyaç. Kilitli bir karardan (D-xx) ya da docs/analiz.md'den sapma varsa belirt. -->

## Nasıl test edildi?

- [ ] `bash tool/quality_gate.sh` yeşil (tam kapı)
- [ ] Yeni / değişen view model, state, model ve repository için test yazıldı
- [ ] Arayüz değiştiyse: widget testi ve 320 / 768 / 1024 / 1440 genişliklerinde taşma denemesi
- [ ] Tarayıcıda gözle bakıldı (`bash tool/dev.sh`)

## Ekran görüntüsü

<!-- Arayüz değiştiyse önce / sonra; en az bir masaüstü ve bir telefon genişliği. -->

## Kontrol listesi

- [ ] Tek konu: bu PR tek bir issue'yu kapatıyor
- [ ] Hardcode yok (renk, boşluk, ölçü, metin, ikon token / ARB / `TfIcons`'tan)
- [ ] Yeni metin `lib/l10n/app_tr.arb`'ye eklendi
- [ ] Hard delete yok (soft delete)
- [ ] Üretilen dosyalar (`*.g.dart`, `app_localizations*.dart`) commit edilmedi
- [ ] Referans siteden içerik (logo, metin, fotoğraf, kişi adı) kopyalanmadı
- [ ] `docs/` güncellendi (karar, token haritası, paketler, mimari — gerekiyorsa)
- [ ] PR başlığı Conventional Commits + Türkçe açıklama
