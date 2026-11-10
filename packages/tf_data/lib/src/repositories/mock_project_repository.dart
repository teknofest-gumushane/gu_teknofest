import 'package:tf_data/src/core/app_clock.dart';
import 'package:tf_data/src/core/firebase_result.dart';
import 'package:tf_data/src/core/firestore_error.dart';
import 'package:tf_data/src/models/project_model.dart';
import 'package:tf_data/src/repositories/mock_collection.dart';
import 'package:tf_data/src/repositories/mock_data_source.dart';
import 'package:tf_data/src/repositories/project_repository.dart';

/// [ProjectRepository]'nin sahte uygulaması: `projects.json` okur, yazmalar bellekte
/// kalır.
final class MockProjectRepository implements ProjectRepository {
  /// Sahte repository oluşturur.
  MockProjectRepository(
    MockDataSource source, {
    AppClock clock = const SystemAppClock(),
  }) : _items = MockCollection<ProjectModel>(
         source: source,
         asset: asset,
         idPrefix: 'proje',
         clock: clock,
         parse: (json, id) => ProjectModel.fromJson(json, id: id),
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
  static const String asset = 'projects';

  final MockCollection<ProjectModel> _items;

  @override
  Future<FirestoreResult<List<ProjectModel>>> fetchProjects() =>
      _items.guard(() async {
        final items = await _items.live();
        return items..sort((a, b) {
          final byOrder = a.displayOrder.compareTo(b.displayOrder);
          return byOrder != 0 ? byOrder : a.name.compareTo(b.name);
        });
      });

  @override
  Future<FirestoreResult<ProjectModel>> saveProject(ProjectModel item) async {
    final saved = await _items.save(item);
    return saved == null
        ? const FirebaseFailure(FirestoreError.notFound)
        : FirebaseSuccess(saved);
  }

  @override
  Future<FirestoreResult<void>> softDeleteProject(String id) =>
      _setDeleted(id, deleted: true);

  @override
  Future<FirestoreResult<void>> restoreProject(String id) =>
      _setDeleted(id, deleted: false);

  Future<FirestoreResult<void>> _setDeleted(
    String id, {
    required bool deleted,
  }) async => await _items.setDeleted(id, deleted: deleted)
      ? const FirebaseSuccess(null)
      : const FirebaseFailure(FirestoreError.notFound);
}
