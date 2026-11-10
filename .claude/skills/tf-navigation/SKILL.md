---
name: tf-navigation
description: go_router typed route, redirect ile yetki yönlendirmesi, genel sayfada menüden bölüme kaydırma ve /admin'in gecikmeli yüklenmesi işleri. Rota eklerken, ekran bağlarken, menüye öğe eklerken ya da bölüme kaydırma davranışını değiştirirken kullan.
---

# tf-navigation

Kurallar `CLAUDE.md §5`; adres tablosu `docs/architecture.md §6`; genel sayfanın yapısı `docs/architecture.md §4`. Kilitli: D-04, D-07.

## Kurallar

1. **Typed route:** `@TypedGoRoute` + `GoRouteData`, sınıf adı `<Ad>Route`. Yönlendirici `lib/product/navigation/app_router.dart`, rotalar `lib/product/navigation/routes/`. Her rota dosyası kendi `part '….g.dart'` satırını taşır; üretilen dosya commit edilmez (D-18).
2. **Genel sayfa tek sayfadır.** Menü öğesi rota **değiştirmez**; `LandingViewMixin`'deki bölüm anahtarıyla ilgili bölüme kaydırır (süre `TfMotion.scroll`, eğri `TfMotion.emphasized`). Bölüm için ayrı adres (`/projeler` gibi) açılmaz.
3. **Bölüm kimlikleri tek yerde:** `LandingSectionId` (`hero`, `about`, `projects`, `events`, `gallery`, `team`, `socials`). Üst bar, çekmece ve kaydırma aynı kimliği kullanır; bölüm adı string olarak yazılmaz.
4. **Menü iki yerde:** `LandingHeader` (≥ 1024 px linkler) ve `LandingDrawer` (< 1024 px). Öğe değişince ikisi birlikte güncellenir; çekmecede seçim sonrası çekmece kapanır, sonra kaydırılır.
5. **Yetki kararı router'da** (`redirect`); view'dan `context.go` ile auth kararı verilmez.
6. **`/admin` gecikmeli yüklenir** (D-04): admin view'ları yalnızca `lib/product/navigation/` içinden ve `deferred as` ile import edilir; ziyaretçi admin kodunu indirmez. Admin ekranları **henüz yok** (sonraki tur, D-23) — o tur açılmadan `/admin` rotası yazma.
7. **Path parametresi:** zorunlu kimlikler path'te; `$extra` ile model taşınmaz.
8. **`Navigator.push` yok** (HC12); geçiş `XRoute(...).go(context)`.
9. **Bilinmeyen adres** → `NotFoundView`.
10. **Temiz adresler:** `usePathUrlStrategy`; adreste `#` yok.
11. Açılır pencereler (Takıma Katıl formu, görsel pencereleri) için tabloda adres tanımlı değildir; adres gerekiyorsa önce sor.

## Yeni rota ekleme sırası

1. `docs/architecture.md §6` tablosunda satırı bul. Yoksa dur → `tf-ask-user`; onaylanırsa tabloya işle (`tf-decision-log`).
2. `lib/product/navigation/routes/` altında typed sınıf; parametre tipleri; `$extra` yok.
3. Yetki gerekiyorsa `redirect` kuralı (oturum `lib/core/session/`).
4. `bash tool/codegen.sh`.
5. Çağıran tarafta `XRoute(...).go(context)`.
6. Test (aşağıda).

## Menü öğesi / bölüm bağlama

Bölüm listesi `docs/architecture.md §4`'te sabittir; yeni bölüm = önce `tf-ask-user`.

1. `LandingSectionId`'de kimlik; `LandingViewMixin`'de anahtar; `LandingView`'da sıra.
2. `LandingHeader` ve `LandingDrawer` öğesi; etiket ARB'den (`tf-l10n`).
3. Klavye: menü öğeleri ve hamburger düğmesi Tab ile ulaşılır, Enter ile çalışır; odak çerçevesi görünür (`CLAUDE.md §7`).

## Test

Bilinmeyen adres → `NotFoundView` · `redirect` kuralları · menü öğesi ilgili bölümü görünür alana getiriyor, adres `/` kalıyor · 1024 px altında hamburger + çekmece, üstünde linkler · çekmece seçimden sonra kapanıyor. `Navigator.push` taramasını `tool/check_hardcode.sh` yapar.
