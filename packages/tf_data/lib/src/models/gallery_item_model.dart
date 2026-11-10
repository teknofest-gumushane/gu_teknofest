import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tf_data/src/constants/firestore_fields.dart';
import 'package:tf_data/src/core/base_fields.dart';
import 'package:tf_data/src/utils/json_converters.dart';

part 'gallery_item_model.g.dart';

/// Galeri kaydı — `gallery/{itemId}` belgesi. Belge kimliği [id] JSON'a
/// girmez.
@JsonSerializable()
final class GalleryItemModel extends Equatable with BaseFields {
  /// Galeri kaydı oluşturur; [id] verilmezse boş dizgidir.
  const GalleryItemModel({
    required this.imagePath,
    this.id = '',
    this.title = '',
    this.description,
    this.displayOrder = 0,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.isDeleted = false,
    this.deletedAt,
    this.deletedBy,
  });

  /// Firestore belge verisinden üretir; [id] belge kimliğidir.
  factory GalleryItemModel.fromJson(
    Map<String, Object?> json, {
    required String id,
  }) => _$GalleryItemModelFromJson(json).copyWith(id: id);

  /// Belge kimliği (JSON'a yazılmaz).
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String id;

  /// Görselin depolama yolu.
  @JsonKey(name: FirestoreFields.imagePath)
  final String imagePath;

  /// Başlık (üzerine gelince ve büyük görünümde gösterilir).
  @JsonKey(name: FirestoreFields.title)
  final String title;

  /// Açıklama; yoksa `null`.
  @JsonKey(name: FirestoreFields.description)
  final String? description;

  /// Listedeki sıra (küçük önce).
  @JsonKey(name: FirestoreFields.displayOrder)
  final int displayOrder;

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
  Map<String, Object?> toJson() => _$GalleryItemModelToJson(this);

  /// Verilen alanları değişmiş kopya; `clear*` bayrağı alanı `null` yapar.
  GalleryItemModel copyWith({
    String? id,
    String? imagePath,
    String? title,
    String? description,
    bool clearDescription = false,
    int? displayOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    bool? isDeleted,
    DateTime? deletedAt,
    String? deletedBy,
    bool clearDeletion = false,
  }) => GalleryItemModel(
    id: id ?? this.id,
    imagePath: imagePath ?? this.imagePath,
    title: title ?? this.title,
    description: clearDescription ? null : (description ?? this.description),
    displayOrder: displayOrder ?? this.displayOrder,
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
    imagePath,
    title,
    description,
    displayOrder,
    createdAt,
    updatedAt,
    createdBy,
    isDeleted,
    deletedAt,
    deletedBy,
  ];
}
