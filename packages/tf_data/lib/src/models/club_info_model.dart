import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tf_data/src/constants/firestore_fields.dart';
import 'package:tf_data/src/utils/json_converters.dart';

part 'club_info_model.g.dart';

/// Kulüp bilgisi — `clubInfo/main` tek belgesi.
///
/// Ana sayfadaki istatistik kartını ve başvuru durumunu besler. Sayılar
/// hesaplanmaz; admin panelinden elle girilir.
@JsonSerializable()
final class ClubInfoModel extends Equatable {
  /// Kulüp bilgisi oluşturur.
  const ClubInfoModel({
    this.logoPath,
    this.memberCount = 0,
    this.activeMemberCount = 0,
    this.projectCount = 0,
    this.isApplicationOpen = false,
    this.updatedAt,
  });

  /// Firestore belge verisinden üretir.
  factory ClubInfoModel.fromJson(Map<String, Object?> json) =>
      _$ClubInfoModelFromJson(json);

  /// Kulüp logosunun depolama yolu; yüklenmediyse `null`.
  @JsonKey(name: FirestoreFields.logoPath)
  final String? logoPath;

  /// Toplam üye sayısı.
  @JsonKey(name: FirestoreFields.memberCount)
  final int memberCount;

  /// Aktif üye sayısı.
  @JsonKey(name: FirestoreFields.activeMemberCount)
  final int activeMemberCount;

  /// Proje sayısı.
  @JsonKey(name: FirestoreFields.projectCount)
  final int projectCount;

  /// Başvurular açık mı.
  @JsonKey(name: FirestoreFields.isApplicationOpen)
  final bool isApplicationOpen;

  /// Son güncelleme anı (UTC); sunucu zamanı beklenirken `null`.
  @JsonKey(name: FirestoreFields.updatedAt)
  @TimestampConverter()
  final DateTime? updatedAt;

  /// Firestore'a yazılacak harita.
  Map<String, Object?> toJson() => _$ClubInfoModelToJson(this);

  /// Verilen alanları değişmiş kopya; [clearLogoPath] logoyu kaldırır.
  ClubInfoModel copyWith({
    String? logoPath,
    bool clearLogoPath = false,
    int? memberCount,
    int? activeMemberCount,
    int? projectCount,
    bool? isApplicationOpen,
    DateTime? updatedAt,
  }) => ClubInfoModel(
    logoPath: clearLogoPath ? null : (logoPath ?? this.logoPath),
    memberCount: memberCount ?? this.memberCount,
    activeMemberCount: activeMemberCount ?? this.activeMemberCount,
    projectCount: projectCount ?? this.projectCount,
    isApplicationOpen: isApplicationOpen ?? this.isApplicationOpen,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  @override
  List<Object?> get props => [
    logoPath,
    memberCount,
    activeMemberCount,
    projectCount,
    isApplicationOpen,
    updatedAt,
  ];
}
