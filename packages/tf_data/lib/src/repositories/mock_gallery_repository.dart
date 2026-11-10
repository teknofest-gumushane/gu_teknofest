import 'package:tf_data/src/core/app_clock.dart';
import 'package:tf_data/src/core/firebase_result.dart';
import 'package:tf_data/src/core/firestore_error.dart';
import 'package:tf_data/src/models/gallery_item_model.dart';
import 'package:tf_data/src/repositories/gallery_repository.dart';
import 'package:tf_data/src/repositories/mock_collection.dart';
import 'package:tf_data/src/repositories/mock_data_source.dart';

/// [GalleryRepository]'nin sahte uygulaması: `gallery.json` okur, yazmalar bellekte
/// kalır.
final class MockGalleryRepository implements GalleryRepository {
  /// Sahte repository oluşturur.
  MockGalleryRepository(
    MockDataSource source, {
    AppClock clock = const SystemAppClock(),
  }) : _items = MockCollection<GalleryItemModel>(
         source: source,
         asset: asset,
         idPrefix: 'gorsel',
         clock: clock,
         parse: (json, id) => GalleryItemModel.fromJson(json, id: id),
         idOf: (item) => item.id,
         stamp:
             (
               item, {
               id,
               createdAt,
               updatedAt,
               isDeleted,
               deletedAt,
               deletedBy,
               clearDeletion = false,
             }) => item.copyWith(
               id: id,
               createdAt: createdAt,
               updatedAt: updatedAt,
               isDeleted: isDeleted,
               deletedAt: deletedAt,
               deletedBy: deletedBy,
               clearDeletion: clearDeletion,
             ),
       );

  /// Sahte veri dosyasının adı.
  static const String asset = 'gallery';

  final MockCollection<GalleryItemModel> _items;

  @override
  Future<FirestoreResult<List<GalleryItemModel>>> fetchGallery() =>
      _items.guard(() async {
        final items = await _items.live();
        return items..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
      });

  @override
  Future<FirestoreResult<GalleryItemModel>> saveGalleryItem(
    GalleryItemModel item,
  ) async {
    final saved = await _items.save(item);
    return saved == null
        ? const FirebaseFailure(FirestoreError.notFound)
        : FirebaseSuccess(saved);
  }

  @override
  Future<FirestoreResult<void>> softDeleteGalleryItem(String id) =>
      _setDeleted(id, deleted: true);

  @override
  Future<FirestoreResult<void>> restoreGalleryItem(String id) =>
      _setDeleted(id, deleted: false);

  Future<FirestoreResult<void>> _setDeleted(
    String id, {
    required bool deleted,
  }) async => await _items.setDeleted(id, deleted: deleted)
      ? const FirebaseSuccess(null)
      : const FirebaseFailure(FirestoreError.notFound);
}
