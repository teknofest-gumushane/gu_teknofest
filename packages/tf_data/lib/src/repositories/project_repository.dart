import 'package:tf_data/src/core/firebase_result.dart';
import 'package:tf_data/src/models/project_model.dart';

/// Projeler (`project` verisi). Silme soft delete'tir (D-10).
abstract interface class ProjectRepository {
  /// Silinmemiş projeler, sıra numarasına göre.
  Future<FirestoreResult<List<ProjectModel>>> fetchProjects();

  /// Kimliği boşsa oluşturur, doluysa günceller; kaydedileni döner.
  /// Güncellenecek kayıt yoksa `FirestoreError.notFound`.
  Future<FirestoreResult<ProjectModel>> saveProject(ProjectModel item);

  /// Kaydı silinmiş olarak işaretler.
  Future<FirestoreResult<void>> softDeleteProject(String id);

  /// Silinmiş kaydı geri alır.
  Future<FirestoreResult<void>> restoreProject(String id);
}
