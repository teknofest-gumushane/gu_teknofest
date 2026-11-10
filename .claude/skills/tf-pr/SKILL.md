---
name: tf-pr
description: Pull request açma, güncelleme ve birleştirmeye hazırlama kuralları. Bir dal bitince, "PR aç", "pull request", "incelemeye gönder" dendiğinde ya da inceleme yorumlarına cevap verirken kullan.
---

# tf-pr

Akış: issue (`tf-issue`) → dal (`tf-branch`) → **PR**. Şablon: `.github/PULL_REQUEST_TEMPLATE.md`. Kural: D-27, `CONTRIBUTING.md`.

## Açmadan önce (hepsi "evet" olmalı)

- [ ] Dal tek bir issue'ya ait ve `main`'den güncel (`tf-branch`).
- [ ] `bash tool/quality_gate.sh` **yeşil** (tam kapı; `--fast` / `--static` yetmez) → `tf-quality-gate`.
- [ ] Denetçiler çalıştı, kritik bulgu yok: `tf-architecture-reviewer`, `tf-test-auditor`; arayüz değiştiyse `tf-site-parity-reviewer`.
- [ ] Üretilen dosya (`*.g.dart`, `app_localizations*.dart`) ve gizli bilgi commit'lerde yok: `git diff --name-only origin/main...HEAD`.
- [ ] Kullanıcı PR açılmasını istedi. PR açmak depoya herkesin göreceği bir kayıt düşer; kendiliğinden açılmaz.

## Başlık

Conventional Commits + Türkçe açıklama; squash ile birleşince `main`'deki commit mesajı bu olur:

```
feat(landing): projeler bölümünü ekle
fix(header): çekmece kapanınca odağı menü butonuna geri ver
```

## Gövde

Şablondaki **her başlık** doldurulur:

- **Ne değişti?** kısa özet + `Closes #<issue-no>` (issue PR birleşince kapanır).
- **Neden?** ihtiyaç; D-xx ya da `docs/analiz.md`'den sapma varsa açıkça.
- **Nasıl test edildi?** / **Kontrol listesi:** kutu yalnızca **gerçekten yapıldıysa** işaretlenir. Yapılmayanı işaretsiz bırak ve nedenini yaz; "yeşil" demek için kapıyı az önce çalıştırmış olmalısın.
- **Ekran görüntüsü:** arayüz değiştiyse en az bir masaüstü ve bir telefon genişliği.

## Açma

```
git push -u origin <dal>
gh pr create --base main --title "feat(landing): projeler bölümünü ekle" --body-file <govde.md>
```

- Henüz incelemeye hazır değilse `--draft`.
- İnceleyici ya da atama (`--reviewer`, `--assignee`) yalnızca kullanıcı isim verdiyse; gövdeye `@kullanıcı` yazma.

## Açtıktan sonra

- **CI:** `gh pr checks <no>`. Kırmızıysa logu oku (`gh run view <id> --log-failed`), düzelt, yeni commit at.
- **İnceleme yorumları:** her yoruma ya düzeltmeyle ya gerekçeyle cevap ver; yeni commit ekle, **geçmişi yeniden yazma** (force push yok). Kapsam büyüyorsa yeni issue öner.
- **`main` ile çakışma:** `git merge origin/main` (rebase değil), sonra `bash tool/codegen.sh` ve kapı.
- İkinci göz gerekiyorsa `tf-pr-reviewer` agent'ı PR'ı salt okunur inceler.

## Birleştirme

- Koşul: CI yeşil + en az bir onay + şablon dolu.
- Yöntem: **squash**; `main`'e tek commit düşer.
- Kim: proje sahibi ya da onun açıkça yetki verdiği kişi. **Claude kendiliğinden birleştirmez, auto-merge açmaz**; yalnızca kullanıcı o PR için açıkça isterse.

## Rapor

Kullanıcıya: PR adresi, CI durumu, açık kalan kutular ve bekleyen yorumlar. Birleştirildiyse yerel dalı temizleme adımı (`tf-branch` → "Bitince").

## Yapma

- ❌ Kırmızı kapıyla ya da kırmızı CI ile "hazır" demek.
- ❌ Birden çok issue'yu tek PR'da toplamak; ilgisiz dosyaları PR'a katmak.
- ❌ `git push --force`, `git commit --no-verify`.
- ❌ Onaysız PR açmak, kapatmak, birleştirmek ya da başkasının PR'ına push etmek.
