---
name: tf-ask-user
description: Kullanıcıya seçenekli soru sorma kuralları (AskUserQuestion açılır penceresi). Belirsizlik, kilitli kararla çelişki, kapsam dışı istek, eksik içerik ya da birden çok geçerli yaklaşım olduğunda kullan; asla düz metinle seçenekli soru sorma.
---

# tf-ask-user — AskUserQuestion kuralları

**Kural (`CLAUDE.md §0`, D-25):** Seçenek sunulabilecek her soru **`AskUserQuestion`** ile sorulur. Düz sohbet metniyle "A mı B mi?" **yasak.** Araç şeması yüklü değilse önce `ToolSearch` ile `select:AskUserQuestion` yükle.

## Biçim

| Alan | Kural |
|---|---|
| Çağrı başına soru | **1–4** (aynı konuya ait olanları grupla; birbirine bağlı sorular ayrı çağrı) |
| `header` | en çok **12 karakter**, isim gibi ("Arama", "Galeri") |
| `options` | **2–4**, birbirini dışlar; "Diğer" seçeneğini **sen ekleme** (araç ekler) |
| `label` | 1–5 kelime, Türkçe |
| `description` | tek kısa cümle: *neyi getirir / neyi götürür* |
| Öneri | Önerin varsa **ilk seçenek** yap ve etiketin sonuna ` (Önerilen)` ekle; gerekçeyi `description`'a yaz |
| `multiSelect` | yalnızca seçenekler gerçekten birlikte seçilebiliyorsa |
| `preview` | görsel ya da kod karşılaştırması gerekiyorsa (ör. iki yerleşim); yoksa kullanma |
| Dil | Türkçe, jargonsuz; "ne seçersem ne olur" açık olsun |

## Ne zaman sor

- Cevabı `CLAUDE.md` ve `docs/*` içinde olmayan bir davranış ya da kapsam sorusu.
- İki kaynak çelişiyor ya da bir kilitli karar (D-xx) **gerçekten uygulanamıyor** / değişmesi gerekiyor.
- `docs/analiz.md`'de tarifi olmayan bir bölüm, özellik ya da durum gerekiyor (uydurma).
- İçerik eksik: logo, kulüp metni, ekip bilgisi, fotoğraf. Referans siteden alınmaz; kullanıcıdan istenir.
- `docs/packages.md` listesinde olmayan paket gerekiyor (gerekçe + alternatif + bakım durumu).
- Geri dönülemez ya da riskli işlem: gerçek Firebase'e yazma, `firebase deploy`, `git push`, toplu dosya silme.
- Plan sırasında çıkan ve planı etkileyen belirsizlik; birden çok geçerli yaklaşım.

## Ne zaman SORMA

- Cevap `CLAUDE.md` ya da `docs/*` içinde zaten yazılıysa — oku.
- Salt biçim / isimlendirme tercihi (`CLAUDE.md` kuralını uygula).
- Kullanıcının daha önce cevapladığı soru (`docs/decisions.md`; "Açık konular"daki geçici çözümler dahil).

Plan onayı ayrı bir kuraldır: numaralı planı göster ve dur (`CLAUDE.md §0`); plandaki seçenekli noktalar yine bu pencereyle sorulur.

## Cevabı işle

1. Karar niteliğindeyse `docs/decisions.md`'ye **olduğu gibi** yaz (`tf-decision-log`): seçilen etiket, gerekçe, tarih. Serbest ("Diğer") cevap: kullanıcının sözleri tırnak içinde + kısa yorum; belirsizse tek soruyla netleştir.
2. Etkilenen dosyaları kısaca söyle.
3. Kullanıcı soruyu reddeder ya da yanıtlamazsa: önerilen seçeneği **uygulama**; işin bekleyen kısmını durdur, kalan bağımsız işe geç ve bunu bildir.

## Şablon

```json
{
  "questions": [{
    "header": "Arama",
    "question": "Projeler bölümündeki arama kutusu listeyi ne zaman süzsün?",
    "multiSelect": false,
    "options": [
      {"label": "Yazdıkça süz (Önerilen)", "description": "Referans sitedeki davranış; her tuşta liste güncellenir."},
      {"label": "Enter ile ara", "description": "Daha az yeniden çizim; kullanıcı fazladan bir tuşa basar."}
    ]
  }]
}
```
