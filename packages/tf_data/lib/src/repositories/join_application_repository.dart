import 'package:tf_data/src/core/firebase_result.dart';
import 'package:tf_data/src/models/join_application_model.dart';

/// Takıma Katıl başvuruları (D-14). Silme soft delete'tir (D-10).
abstract interface class JoinApplicationRepository {
  /// Ziyaretçinin başvurusunu kaydeder; kaydedileni döner.
  Future<FirestoreResult<JoinApplicationModel>> submitApplication(
    JoinApplicationModel application,
  );

  /// Silinmemiş başvurular, en yeni önce (yalnızca yöneticiler).
  Future<FirestoreResult<List<JoinApplicationModel>>> fetchApplications();

  /// Başvuruyu silinmiş olarak işaretler.
  Future<FirestoreResult<void>> softDeleteApplication(String id);

  /// Silinmiş başvuruyu geri alır.
  Future<FirestoreResult<void>> restoreApplication(String id);
}
