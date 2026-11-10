import 'package:tf_data/src/core/firebase_result.dart';
import 'package:tf_data/src/models/gallery_item_model.dart';

/// Galeri görselleri (`gallery` verisi). Silme soft delete'tir (D-10).
abstract interface class GalleryRepository {
  /// Silinmemiş galeri kayıtları, sıra numarasına göre.
  Future<FirestoreResult<List<GalleryItemModel>>> fetchGallery();

  /// Kimliği boşsa oluşturur, doluysa günceller; kaydedileni döner.
  /// Güncellenecek kayıt yoksa `FirestoreError.notFound`.
  Future<FirestoreResult<GalleryItemModel>> saveGalleryItem(
    GalleryItemModel item,
  );

  /// Kaydı silinmiş olarak işaretler.
  Future<FirestoreResult<void>> softDeleteGalleryItem(String id);

  /// Silinmiş kaydı geri alır.
  Future<FirestoreResult<void>> restoreGalleryItem(String id);
}
