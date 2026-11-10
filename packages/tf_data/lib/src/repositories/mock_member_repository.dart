import 'package:tf_data/src/core/app_clock.dart';
import 'package:tf_data/src/core/firebase_result.dart';
import 'package:tf_data/src/core/firestore_error.dart';
import 'package:tf_data/src/models/member_model.dart';
import 'package:tf_data/src/repositories/member_repository.dart';
import 'package:tf_data/src/repositories/mock_collection.dart';
import 'package:tf_data/src/repositories/mock_data_source.dart';

/// [MemberRepository]'nin sahte uygulaması: `members.json` okur, yazmalar bellekte
/// kalır.
final class MockMemberRepository implements MemberRepository {
  /// Sahte repository oluşturur.
  MockMemberRepository(
    MockDataSource source, {
    AppClock clock = const SystemAppClock(),
  }) : _items = MockCollection<MemberModel>(
         source: source,
         asset: asset,
         idPrefix: 'uye',
         clock: clock,
         parse: (json, id) => MemberModel.fromJson(json, id: id),
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
  static const String asset = 'members';

  final MockCollection<MemberModel> _items;

  @override
  Future<FirestoreResult<List<MemberModel>>> fetchMembers({
    bool includeInactive = false,
  }) => _items.guard(() async {
    final items = await _items.live();
    return [
      for (final item in items)
        if (includeInactive || item.isActive) item,
    ]..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  });

  @override
  Future<FirestoreResult<MemberModel>> saveMember(MemberModel item) async {
    final saved = await _items.save(item);
    return saved == null
        ? const FirebaseFailure(FirestoreError.notFound)
        : FirebaseSuccess(saved);
  }

  @override
  Future<FirestoreResult<void>> softDeleteMember(String id) =>
      _setDeleted(id, deleted: true);

  @override
  Future<FirestoreResult<void>> restoreMember(String id) =>
      _setDeleted(id, deleted: false);

  Future<FirestoreResult<void>> _setDeleted(
    String id, {
    required bool deleted,
  }) async => await _items.setDeleted(id, deleted: deleted)
      ? const FirebaseSuccess(null)
      : const FirebaseFailure(FirestoreError.notFound);
}
