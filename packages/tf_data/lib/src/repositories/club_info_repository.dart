import 'package:tf_data/src/core/firebase_result.dart';
import 'package:tf_data/src/models/club_info_model.dart';

/// Kulüp bilgisi (`clubInfo/main`).
abstract interface class ClubInfoRepository {
  /// Kulüp bilgisini getirir.
  Future<FirestoreResult<ClubInfoModel>> fetchClubInfo();

  /// Kulüp bilgisini günceller; kaydedileni döner.
  Future<FirestoreResult<ClubInfoModel>> saveClubInfo(ClubInfoModel info);
}
