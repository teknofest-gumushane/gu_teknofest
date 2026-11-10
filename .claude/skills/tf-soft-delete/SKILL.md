---
name: tf-soft-delete
description: Projede hard delete olmadığını uygulatır (D-10); silme ve geri alma işlemlerini soft delete ile yazdırır. Silme, kaldırma, geri alma, admin panelinde "sil" düğmesi, Storage dosyası değiştirme ya da herhangi bir .delete( çağrısı söz konusu olduğunda kullan.
---

# tf-soft-delete — D-10

Kural: `CLAUDE.md §9`. **Hiçbir yerde hard delete yok.** `tool/check_no_hard_delete.sh` kalite kapısında ve her dosya yazımında (hook) denetler; backend fazında Rules da kilitler (`allow delete: if false`).

## Üç kavramı karıştırma

| Kavram | Yazılan | Örnek |
|---|---|---|
| Kayıt silme | `isDeleted: true` + `deletedAt` + `deletedBy` (+ `updatedAt`) | proje, etkinlik, üye, galeri görseli, başvuru |
| Durum değişimi | ilgili durum alanı (**`isDeleted` yazılmaz**) | üyenin aktif / pasif olması, başvuruların açık / kapalı olması |
| Alan temizleme | `FieldValue.delete()` + `// allow-field-delete: <gerekçe>` | artık kullanılmayan bir alanı belgeden çıkarma |

## API (`tf_data`)

```dart
await firestoreService.softDelete(ref, actorId: uid, batch: batch);   // SoftDelete.payload(actorId: uid)
await firestoreService.restore(ref, batch: batch);                    // SoftDelete.restorePayload()
```

- Tanımlar: `packages/tf_data/lib/src/core/soft_delete.dart`, `…/services/firestore_service.dart`. İmza için dosyayı oku.
- Repository: `softDeleteProject`, `restoreProject` … **`delete*` adlı metot yazılmaz** (HD03, HD04).
- Alan adları `FirestoreFields.*` sabitlerinden; elle `'isDeleted'` yazılmaz.
- Okuma: listeler `isDeleted == false` süzer (`BaseFields.isLive`). `mock_*` repository'ler de aynı süzgeci uygular; sahte veride silinmiş kayıt listede görünmez.
- Geri alma: aynı kayıt `restore` ile; `deletedAt` ve `deletedBy` `null` yazılır.
- Admin panelindeki "sil" = soft delete; önce onay sorusu, sonra sonuç bildirimi (`docs/analiz.md §3`). View model metodu da `softDelete…` adını taşır.
- Storage: dosya silinmez. Görsel değiştirme = yeni dosya + kayıttaki yolun güncellenmesi.
- Auth: istemciden hesap silme (`user.delete()`) yok.
- Kalıcı silme gerçekten gerekiyorsa **dur → `tf-ask-user`** (D-10 kilitlidir).

## Denetim

```
bash tool/check_no_hard_delete.sh                    # lib/, packages/*/lib, firebase/*.rules
bash tool/check_no_hard_delete.sh --files <dosya…>   # yalnızca verilen dosyalar
bash tool/check_no_hard_delete.sh --list             # kural listesi
```

| Kural | Yakaladığı |
|---|---|
| HD01, HD02 | `.delete(…)`, `deleteDoc`, `recursiveDelete`, `deleteUser` … |
| HD03, HD04 | `delete*` adlı metot, `delete` adlı üye |
| HD05 | gerekçesiz `FieldValue.delete()` |
| HD20–HD22 | Rules: `allow write`, koşulsuz `allow …;`, `if false` olmayan `allow delete` |

Satır içi istisna **yalnızca** HD05 içindir (`// allow-field-delete: <gerekçe>`, aynı satırda ya da hemen üstünde). Belge, dosya ve hesap silme için istisna yoktur.

## Testler

Soft delete sonrası alan kümesi (`SoftDelete.affectedKeys`) · silinen kayıt listeden düşer, `restore` geri getirir · fake ve `mock_*` repository aynı davranır · (backend fazı) Rules: her koleksiyonda `delete` reddi.

## Hook uyarısı geldiyse

`PostToolUse` hook'u `.delete(` bulduysa çağrıyı **kaldır** ve `softDelete` / `restore`'a çevir; susturma ya da yorumla geçme yok.
