import 'package:tf_data/src/core/app_clock.dart';
import 'package:tf_data/src/core/firebase_result.dart';
import 'package:tf_data/src/core/firestore_error.dart';
import 'package:tf_data/src/models/event_model.dart';
import 'package:tf_data/src/repositories/event_repository.dart';
import 'package:tf_data/src/repositories/mock_collection.dart';
import 'package:tf_data/src/repositories/mock_data_source.dart';

/// [EventRepository]'nin sahte uygulaması: `events.json` okur, yazmalar bellekte
/// kalır.
final class MockEventRepository implements EventRepository {
  /// Sahte repository oluşturur.
  MockEventRepository(
    MockDataSource source, {
    AppClock clock = const SystemAppClock(),
  }) : _items = MockCollection<EventModel>(
         source: source,
         asset: asset,
         idPrefix: 'etkinlik',
         clock: clock,
         parse: (json, id) => EventModel.fromJson(json, id: id),
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
  static const String asset = 'events';

  final MockCollection<EventModel> _items;

  @override
  Future<FirestoreResult<List<EventModel>>> fetchEvents() =>
      _items.guard(() async {
        final items = await _items.live();
        return items..sort((a, b) => b.eventTime.compareTo(a.eventTime));
      });

  @override
  Future<FirestoreResult<EventModel>> saveEvent(EventModel item) async {
    final saved = await _items.save(item);
    return saved == null
        ? const FirebaseFailure(FirestoreError.notFound)
        : FirebaseSuccess(saved);
  }

  @override
  Future<FirestoreResult<void>> softDeleteEvent(String id) =>
      _setDeleted(id, deleted: true);

  @override
  Future<FirestoreResult<void>> restoreEvent(String id) =>
      _setDeleted(id, deleted: false);

  Future<FirestoreResult<void>> _setDeleted(
    String id, {
    required bool deleted,
  }) async => await _items.setDeleted(id, deleted: deleted)
      ? const FirebaseSuccess(null)
      : const FirebaseFailure(FirestoreError.notFound);
}
