---
name: tf-section-from-site
description: Genel sayfanın bir bölümünü (hero, hakkımızda, projeler, etkinlikler, galeri, ekip, sosyal medya; üst bar ve alt bilgi dahil) docs/analiz.md'deki tarife göre uygular. Bir bölüm dosyasındaki TfComingSoon'u gerçek içerikle değiştirirken ya da "şu bölümü yaz", "referans sitedeki gibi yap" istendiğinde kullan.
---

# tf-section-from-site — bir bölümü uygulama

Kaynak sırası: **`docs/analiz.md`** (ne yapılacak) → `docs/architecture.md §4` (yapı) → `docs/token-map.md` (değerler) → canlı referans site (adresi `CLAUDE.md`'nin başında; yalnızca düzen ve davranış). Akışın kısa hali: `CONTRIBUTING.md` → "Bir bölüme başlarken".

## Referans siteden ne alınır, ne alınmaz

| Alınır: **düzen ve davranış** | Alınmaz: **içerik** (`CLAUDE.md §12`, D-24) |
|---|---|
| Bölüm sırası, sütun sayısı, hizalama | Logo, fotoğraflar, görsel ve ikon dosyaları |
| Filtre, arama, pencere, kaydırma, üzerine gelme davranışı | Tanıtım metinleri: başlık, paragraf, madde listesi |
| Kırılma noktalarındaki değişim | Kişi adları, ünvanlar, e-posta, adres, sosyal medya adresleri |
| Animasyonun türü ve süresi | Proje / etkinlik adları ve açıklamaları; sitenin kodu |

- Renk ve ölçüler siteden yeniden ölçülmez; `docs/token-map.md`'deki token'lar kullanılır.
- İçerik bizimdir: arayüz metni `lib/l10n/app_tr.arb`'de, veri `assets/mock/*.json`'da (örnek veri; referans sitedeki kişi, proje ve etkinlik adları kullanılmaz).
- İçerik eksikse (tanıtım metni, ekip listesi, fotoğraf) gerçekmiş gibi uydurma → `tf-ask-user`. Logo ve kulüp adı için geçici çözüm `docs/decisions.md` → "Açık konular"da.

## Sıra

0. **Plan → onay** (`CLAUDE.md §0`). Bir bölüm = bir kişi; başka bölümün dosyasına dokunma.
1. **Tarifi oku:** `docs/analiz.md §1` tablosunda bölümün satırı; pencere açıyorsa `§2`; veri alanları `§4`; ölçü, renk ve hareket `§5`. "Veri" sütunu `Sabit` mi `API` mi, not et.
2. **Gerekirse canlı siteye bak** — yalnızca düzen ve davranış için: sütunlar, üzerine gelme, pencere, klavye. Analizde olmayan bir davranış görürsen kendiliğinden ekleme → `tf-ask-user`.
3. **Bölüm dosyası:** `lib/features/landing/view/section/<ad>_section.dart`. `TfComingSoon`'u gerçek içerikle değiştir; **`TfSectionFrame` kalır** (üst etiket, başlık, alt metin, içerik). `LandingSectionId` ve `LandingView`'daki sıra değişmez.
4. **Veri gerekiyorsa** (`API` satırı): `lib/features/landing/provider/<ad>_view_model.dart` + `<ad>_state.dart`; veri `tf_data` repository'sinden (`tf-feature`). Render sırası hata → yükleniyor → boş → dolu. `Sabit` bölümde view model gerekmez: metin ARB'den, adres ve e-posta `AppConstants`'tan.
5. **Parçalar:** önce `lib/product/widget/`'a bak; ortak olacak yeni parça oraya (`tf-widget`), bölüme özgü olan `lib/features/landing/view/widget/`'a. Etkileşim mantığı (filtre, arama, pencere açma) view model ya da `view/mixin/` içinde.
6. **Metinler** `lib/l10n/app_tr.arb` (`tf-l10n`), sonra `bash tool/codegen.sh`.
7. **Stil yalnızca token** (`CLAUDE.md §6`). Eksik token çağrı yerine değil `lib/product/theme/`'a eklenir ve `docs/token-map.md` güncellenir.
8. **Responsive** (`tf-responsive`): ızgara 1 / 2 / 3 sütun, içerik en fazla `TfSizes.contentMaxWidth`, 320 px'te taşma yok.
9. **Erişilebilirlik** (`CLAUDE.md §7`): klavye ile gezinme, görünür odak, `Semantics`; pencereler Esc ile kapanır.
10. **Test** `test/features/landing/` (`tf-testing`): dört genişlik, dört durum, her etkileşimin sonucu.
11. `bash tool/quality_gate.sh --fast`; ardından `tf-site-parity-reviewer` ve `tf-architecture-reviewer` ajanları.

## Bölüm → nereye bak

| Bölüm (`LandingSectionId`) | `docs/analiz.md` | Veri |
|---|---|---|
| `hero` | §1 Hero, §5 gradyan | kulüp bilgisi (istatistikler) |
| `about` | §1 Hakkımızda | sabit |
| `projects` | §1 Projeler | proje; etiket filtresi + arama |
| `events` | §1 Etkinlikler, §2 Etkinlik görsel penceresi | etkinlik + görselleri |
| `gallery` | §1 Galeri, §2 Galeri penceresi | galeri |
| `team` | §1 Ekibimiz, §2 Takıma Katıl formu | üye; form başvuru yazar (D-14) |
| `socials` | §1 Sosyal medya | sabit |
| `LandingHeader`, `LandingFooter` (kimliği yok) | §1 Üst menü, Alt bilgi | sabit |

## Bizde bilinçli olarak farklı

Logo özgün (D-24) · ana başlık ağırlığı 600 ("Açık konular") · form EmailJS'e değil `applications` kaydına gider (D-14) · AI asistan yok (D-17) · ağ görseli `TfNetworkImage` (D-12) · animasyon Flutter yerleşikleriyle (D-13) · silme soft delete (D-10) · bulanıklık pahalıysa sade yedek (`docs/analiz.md §6`).

## Yapma

❌ Referans siteden metin, görsel ya da isim kopyalama · ❌ `TfSectionFrame`'i kaldırma · ❌ analizde olmayan özellik uydurma · ❌ koda sayı, renk ya da metin yazma · ❌ view'da `GetIt` / repository · ❌ "el değmişken" başka bölümü düzenleme.
