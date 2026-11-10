import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tf_data/src/constants/firestore_fields.dart';
import 'package:tf_data/src/core/base_fields.dart';
import 'package:tf_data/src/utils/json_converters.dart';

part 'member_model.g.dart';

/// Ekip üyesi — `members/{memberId}` belgesi. Belge kimliği [id] JSON'a
/// girmez.
@JsonSerializable()
final class MemberModel extends Equatable with BaseFields {
  /// Üye oluşturur; [id] verilmezse boş dizgidir.
  const MemberModel({
    required this.name,
    this.id = '',
    this.title = '',
    this.description,
    this.imagePath,
    this.displayOrder = 0,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.isDeleted = false,
    this.deletedAt,
    this.deletedBy,
  });

  /// Firestore belge verisinden üretir; [id] belge kimliğidir.
  factory MemberModel.fromJson(
    Map<String, Object?> json, {
    required String id,
  }) => _$MemberModelFromJson(json).copyWith(id: id);

  /// Belge kimliği (JSON'a yazılmaz).
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String id;

  /// Ad soyad.
  @JsonKey(name: FirestoreFields.name)
  final String name;

  /// Ünvan (ör. kulüp içindeki görev).
  @JsonKey(name: FirestoreFields.title)
  final String title;

  /// Kısa tanıtım; yoksa `null`.
  @JsonKey(name: FirestoreFields.description)
  final String? description;

  /// Fotoğrafın depolama yolu; yoksa `null`.
  @JsonKey(name: FirestoreFields.imagePath)
  final String? imagePath;

  /// Listedeki sıra (küçük önce).
  @JsonKey(name: FirestoreFields.displayOrder)
  final int displayOrder;

  /// Üye ekipte gösterilsin mi.
  @JsonKey(name: FirestoreFields.isActive)
  final bool isActive;

  @override
  @JsonKey(name: FirestoreFields.createdAt)
  @TimestampConverter()
  final DateTime? createdAt;

  @override
  @JsonKey(name: FirestoreFields.updatedAt)
  @TimestampConverter()
  final DateTime? updatedAt;

  @override
  @JsonKey(name: FirestoreFields.createdBy)
  final String? createdBy;

  @override
  @JsonKey(name: FirestoreFields.isDeleted)
  final bool isDeleted;

  @override
  @JsonKey(name: FirestoreFields.deletedAt)
  @TimestampConverter()
  final DateTime? deletedAt;

  @override
  @JsonKey(name: FirestoreFields.deletedBy)
  final String? deletedBy;

  /// Firestore'a yazılacak harita ([id] hariç).
  Map<String, Object?> toJson() => _$MemberModelToJson(this);

  /// Verilen alanları değişmiş kopya; `clear*` bayrağı alanı `null` yapar.
  MemberModel copyWith({
    String? id,
    String? name,
    String? title,
    String? description,
    bool clearDescription = false,
    String? imagePath,
    bool clearImagePath = false,
    int? displayOrder,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    bool? isDeleted,
    DateTime? deletedAt,
    String? deletedBy,
    bool clearDeletion = false,
  }) => MemberModel(
    id: id ?? this.id,
    name: name ?? this.name,
    title: title ?? this.title,
    description: clearDescription ? null : (description ?? this.description),
    imagePath: clearImagePath ? null : (imagePath ?? this.imagePath),
    displayOrder: displayOrder ?? this.displayOrder,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    createdBy: createdBy ?? this.createdBy,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAt: clearDeletion ? null : (deletedAt ?? this.deletedAt),
    deletedBy: clearDeletion ? null : (deletedBy ?? this.deletedBy),
  );

  @override
  List<Object?> get props => [
    id,
    name,
    title,
    description,
    imagePath,
    displayOrder,
    isActive,
    createdAt,
    updatedAt,
    createdBy,
    isDeleted,
    deletedAt,
    deletedBy,
  ];
}
