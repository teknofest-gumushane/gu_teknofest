import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tf_data/src/constants/firestore_fields.dart';
import 'package:tf_data/src/core/base_fields.dart';
import 'package:tf_data/src/models/enums/project_status.dart';
import 'package:tf_data/src/utils/json_converters.dart';

part 'project_model.g.dart';

/// Proje — `projects/{projectId}` belgesi.
///
/// Belge kimliği [id] JSON'a girmez: okurken `fromJson(json, id: …)` ile
/// verilir, yazarken belge yolundan gelir. Zaman alanları UTC'dir.
@JsonSerializable()
final class ProjectModel extends Equatable with BaseFields {
  /// Proje oluşturur; [id] verilmezse boş dizgidir (henüz yazılmamış kayıt).
  const ProjectModel({
    required this.name,
    this.id = '',
    this.description = '',
    this.imagePath,
    this.tags = const [],
    this.status = ProjectStatus.active,
    this.displayOrder = 0,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.isDeleted = false,
    this.deletedAt,
    this.deletedBy,
  });

  /// Firestore belge verisinden üretir; [id] belge kimliğidir.
  factory ProjectModel.fromJson(
    Map<String, Object?> json, {
    required String id,
  }) => _$ProjectModelFromJson(json).copyWith(id: id);

  /// Belge kimliği (JSON'a yazılmaz).
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String id;

  /// Proje adı.
  @JsonKey(name: FirestoreFields.name)
  final String name;

  /// Kısa açıklama.
  @JsonKey(name: FirestoreFields.description)
  final String description;

  /// Kapak görselinin depolama yolu; yoksa `null`.
  @JsonKey(name: FirestoreFields.imagePath)
  final String? imagePath;

  /// Etiketler (filtre çipleri bunlardan türetilir).
  @JsonKey(name: FirestoreFields.tags)
  final List<String> tags;

  /// Proje durumu.
  @JsonKey(name: FirestoreFields.status)
  final ProjectStatus status;

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
  Map<String, Object?> toJson() => _$ProjectModelToJson(this);

  /// Verilen alanları değişmiş kopya; `clear*` bayrağı alanı `null` yapar.
  ProjectModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imagePath,
    bool clearImagePath = false,
    List<String>? tags,
    ProjectStatus? status,
    int? displayOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    bool? isDeleted,
    DateTime? deletedAt,
    String? deletedBy,
    bool clearDeletion = false,
  }) => ProjectModel(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    imagePath: clearImagePath ? null : (imagePath ?? this.imagePath),
    tags: tags ?? this.tags,
    status: status ?? this.status,
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
    name,
    description,
    imagePath,
    tags,
    status,
    displayOrder,
    createdAt,
    updatedAt,
    createdBy,
    isDeleted,
    deletedAt,
    deletedBy,
  ];
}
