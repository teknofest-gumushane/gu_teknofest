import 'package:tf_data/src/core/app_clock.dart';
import 'package:tf_data/src/core/firebase_result.dart';
import 'package:tf_data/src/core/firestore_error.dart';
import 'package:tf_data/src/models/join_application_model.dart';
import 'package:tf_data/src/repositories/join_application_repository.dart';
import 'package:tf_data/src/repositories/mock_collection.dart';
import 'package:tf_data/src/repositories/mock_data_source.dart';

/// [JoinApplicationRepository]'nin sahte uygulaması: boş başlar (sahte veri
/// dosyası yoktur; kişisel veri örneği taşınmaz), başvurular bellekte kalır.
final class MockJoinApplicationRepository implements JoinApplicationRepository {
  /// Sahte repository oluşturur.
  MockJoinApplicationRepository(
    MockDataSource source, {
    AppClock clock = const SystemAppClock(),
  }) : _items = MockCollection<JoinApplicationModel>(
         source: source,
         idPrefix: 'basvuru',
         clock: clock,
         parse: (json, id) => JoinApplicationModel.fromJson(json, id: id),
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

  final MockCollection<JoinApplicationModel> _items;

  @override
  Future<FirestoreResult<JoinApplicationModel>> submitApplication(
    JoinApplicationModel application,
  ) async {
    // Yeni başvuru daima yeni kayıttır: gelen kimlik yok sayılır.
    final saved = await _items.save(application.copyWith(id: ''));
    return saved == null
        ? const FirebaseFailure(FirestoreError.unknown)
        : FirebaseSuccess(saved);
  }

  @override
  Future<FirestoreResult<List<JoinApplicationModel>>> fetchApplications() =>
      _items.guard(() async {
        final items = await _items.live();
        return items..sort((a, b) {
          final left = a.createdAt;
          final right = b.createdAt;
          if (left == null || right == null) return 0;
          return right.compareTo(left);
        });
      });

  @override
  Future<FirestoreResult<void>> softDeleteApplication(String id) =>
      _setDeleted(id, deleted: true);

  @override
  Future<FirestoreResult<void>> restoreApplication(String id) =>
      _setDeleted(id, deleted: false);

  Future<FirestoreResult<void>> _setDeleted(
    String id, {
    required bool deleted,
  }) async => await _items.setDeleted(id, deleted: deleted)
      ? const FirebaseSuccess(null)
      : const FirebaseFailure(FirestoreError.notFound);
}
