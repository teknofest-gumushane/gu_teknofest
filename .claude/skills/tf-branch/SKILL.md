---
name: tf-branch
description: Dal açma, adlandırma ve dalı güncel tutma kuralları. Bir issue üzerinde çalışmaya başlarken, "dal aç", "branch aç" dendiğinde ya da main üzerinde değişiklik yapmak üzereyken kullan.
---

# tf-branch

**Her iş kendi dalında yürür** (D-27). `main`'e doğrudan commit yalnızca proje sahibinin açık talimatıyla yapılır (D-19). Akış: issue (`tf-issue`) → **dal** → PR (`tf-pr`).

## Ad

```
<tür>/<issue-no>-<kısa-ad>
```

| Tür | Ne zaman | Örnek |
|---|---|---|
| `feat` | yeni özellik, bölüm, ekran | `feat/12-projeler-bolumu` |
| `fix` | hata düzeltmesi | `fix/31-cekmece-kaydirma` |
| `docs` | yalnızca belge | `docs/40-token-tablosu` |
| `refactor` | davranış değiştirmeyen düzenleme | `refactor/44-bolum-cercevesi` |
| `test` | yalnızca test | `test/47-galeri-testleri` |
| `chore` / `ci` | araç, bağımlılık, iş akışı | `ci/50-onbellek` |

- Küçük harf, tire, Türkçe karaktersiz (`ç→c`, `ğ→g`, `ı→i`, `ö→o`, `ş→s`, `ü→u`); kısa ad en çok dört sözcük.
- Issue numarası zorunludur. Issue yoksa önce `tf-issue`.
- **Bir dal = bir issue.** İkinci konu çıkarsa yeni issue ve yeni dal.

## Açma

1. Çalışma ağacı temiz mi: `git status --short`. Değilse dur ve sor (stash ya da commit kararı kullanıcınındır).
2. `main`'i güncelle ve daldan çık:

   ```
   git switch main
   git pull --ff-only origin main
   git switch -c feat/12-projeler-bolumu
   ```

3. Dal değişince üretilen dosyalar eskir: `bash tool/codegen.sh`.

## Çalışırken

- Commit: Conventional Commits + Türkçe açıklama (`CLAUDE.md §11`); commit ve push yalnızca kullanıcı isteyince.
- İlk push: `git push -u origin <dal>`.
- `main` ilerlediyse: PR **açılmadan önce** `git pull --rebase origin main`; PR **açıldıktan sonra** geçmiş yeniden yazılmaz → `git merge origin/main`.
- Çakışma `lib/l10n/app_tr.arb` gibi ortak dosyalardaysa iki tarafın satırlarını da koru; sonra `bash tool/codegen.sh` ve kapı.

## Bitince

- PR: `tf-pr`.
- Birleştirildikten sonra: `git switch main && git pull --ff-only origin main && git branch -d <dal>`. Uzak dalı GitHub birleştirirken siler; elle silme gerekiyorsa sor.

## Yapma

- ❌ `main` üzerinde çalışmaya başlamak (yanlışlıkla başladıysan: commit atmadan `git switch -c <dal>`).
- ❌ `git push --force` / `-f`, PR açıldıktan sonra `git rebase`.
- ❌ Başkasının dalına commit atmak ya da dalını silmek.
- ❌ Bir dalda iki issue; issue numarasız dal.
- ❌ `git reset --hard`, `git clean` (çalışmayı siler; `.claude/settings.json` de reddeder).
