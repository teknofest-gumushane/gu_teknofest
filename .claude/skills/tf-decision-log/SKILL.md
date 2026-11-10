---
name: tf-decision-log
description: Kararları, soru cevaplarını ve açık konuları docs/decisions.md içinde kayda geçirme. Kilitli bir karar (D-xx) değişecekse, kullanıcı bir soruyu cevapladıysa, yeni bir kural doğduysa ya da bir açık konu kapandıysa kullan.
---

# tf-decision-log

Kayıt yeri: `docs/decisions.md` — **D-xx tablosu** + **"Açık konular"**. Kural: `CLAUDE.md §0` (madde 3).

## Neyi nereye

| Olay | Yer | Biçim |
|---|---|---|
| Yeni karar (kullanıcı onaylı) | D-xx tablosunun sonu | sıradaki numara (`D-27…`): karar · gerekçe · tarih (`YYYY-AA-GG`) |
| Seçenekli soru cevabı (karar niteliğinde) | D-xx tablosu | seçilen etiket kullanıcının sözleriyle; gerekçe sütununda neden |
| Kilitli kararın değişmesi | aynı satır | `~~eski~~ → yeni`, tarih, neden; numara yeniden kullanılmaz |
| Henüz verilemeyen karar / beklenen girdi | "Açık konular" | `- **Konu:** durum + o zamana kadar ne yapılıyor` |
| Açık konunun kapanması | maddeyi "Açık konular"dan çıkar | karşılığında D-xx satırı |
| Yeni ya da değişen token | `docs/token-map.md` | aynı commit |
| Eklenen / çıkan paket | `docs/packages.md` (+ `pubspec.yaml`'daki amaç yorumu) | aynı commit |
| Yeni adres, klasör ya da bölüm | `docs/architecture.md` | aynı commit |

## Kurallar

- **Sessiz sapma yok.** Bir D-xx ya da `docs/*` sözleşmesi değişecekse önce `tf-ask-user`; onay gelmeden yazma.
- Kayıt **olay anında** yazılır, işin sonuna bırakılmaz.
- Cevaplar kullanıcının sözleriyle; yorum ayrı (gerekçe sütunu). Gerekçe sütunu boş kalmaz.
- Kararın yansımaları **aynı commit'te**: karar `CLAUDE.md`'yi, başka bir `docs/*` dosyasını ya da bir skill / agent metnini etkiliyorsa onlar da güncellenir. Kural tek yerde yazılı kalır; diğerleri oraya referans verir.
- Belgeyi değiştirmek de dosyaya dokunmaktır: plan → onay kuralı geçerlidir (D-25).
- Gizli bilgi (anahtar, servis hesabı, şifre) hiçbir belgeye yazılmaz.

## Satır örneği

```
| D-27 | Görsel pencerelerinde klavye okları da ileri / geri yapar. | Kullanıcı kararı; referans sitede yalnızca düğmeler var. | 2026-11-12 |
```

(Örnektir; gerçek bir karar değildir.)

## Bitince

Kullanıcıya tek satır: hangi numara eklendi ya da değişti, hangi dosyalar etkilendi.
