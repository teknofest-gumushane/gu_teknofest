import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tf_data/src/repositories/project_repository.dart';

final class FirebaseProjectRepository implements ProjectRepository {
  @override
  Future<void> softDeleteProject(String id) async {
    await ref(id).update({
      'isDeleted': true,
      // allow-field-delete: eski önbellek alanı artık kullanılmıyor
      'legacyCache': FieldValue.delete(),
    });
  }

  @override
  Future<void> restoreProject(String id) async {}
}
