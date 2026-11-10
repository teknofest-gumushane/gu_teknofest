import 'package:tf_data/src/core/app_clock.dart';
import 'package:tf_data/src/core/firebase_result.dart';
import 'package:tf_data/src/core/firestore_error.dart';
import 'package:tf_data/src/models/club_info_model.dart';
import 'package:tf_data/src/repositories/club_info_repository.dart';
import 'package:tf_data/src/repositories/mock_data_source.dart';

/// [ClubInfoRepository]'nin sahte uygulaması: `club_info.json` okur, yazmalar
/// bellekte kalır.
final class MockClubInfoRepository implements ClubInfoRepository {
  /// Sahte repository oluşturur.
  MockClubInfoRepository(
    this._source, {
    this._clock = const SystemAppClock(),
  });

  /// Sahte veri dosyasının adı.
  static const String asset = 'club_info';

  final MockDataSource _source;
  final AppClock _clock;
  ClubInfoModel? _info;

  @override
  Future<FirestoreResult<ClubInfoModel>> fetchClubInfo() async {
    try {
      return FirebaseSuccess(
        _info ??= ClubInfoModel.fromJson(await _source.readMap(asset)),
      );
    } on Object catch (error) {
      return FirebaseFailure(FirestoreError.parse, message: '$error');
    }
  }

  @override
  Future<FirestoreResult<ClubInfoModel>> saveClubInfo(
    ClubInfoModel info,
  ) async {
    final saved = info.copyWith(updatedAt: _clock.nowUtc());
    _info = saved;
    return FirebaseSuccess(saved);
  }
}
