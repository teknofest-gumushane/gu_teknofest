import 'package:tf_data/src/core/firebase_result.dart';
import 'package:tf_data/src/models/member_model.dart';

/// Ekip üyeleri (`member` verisi). Silme soft delete'tir (D-10).
abstract interface class MemberRepository {
  /// Silinmemiş üyeler, sıra numarasına göre; [includeInactive] verilmezse yalnızca aktifler.
  Future<FirestoreResult<List<MemberModel>>> fetchMembers({
    bool includeInactive = false,
  });

  /// Kimliği boşsa oluşturur, doluysa günceller; kaydedileni döner.
  /// Güncellenecek kayıt yoksa `FirestoreError.notFound`.
  Future<FirestoreResult<MemberModel>> saveMember(MemberModel item);

  /// Kaydı silinmiş olarak işaretler.
  Future<FirestoreResult<void>> softDeleteMember(String id);

  /// Silinmiş kaydı geri alır.
  Future<FirestoreResult<void>> restoreMember(String id);
}
