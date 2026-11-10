import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tf_data/src/constants/firestore_fields.dart';
import 'package:tf_data/src/core/base_fields.dart';
import 'package:tf_data/src/utils/json_converters.dart';

part 'join_application_model.g.dart';

/// Takıma Katıl başvurusu — `applications/{applicationId}` belgesi (D-14).
/// Belge kimliği [id] JSON'a girmez.
///
/// Kişisel veri taşır (ad, e-posta, telefon): yalnızca yöneticiler okuyabilir;
/// ziyaretçi yalnızca kendi başvurusunu oluşturur.
@JsonSerializable()
final class JoinApplicationModel extends Equatable with BaseFields {
  /// Başvuru oluşturur; [id] verilmezse boş dizgidir.
  const JoinApplicationModel({
    required this.firstName,
    required this.lastName,
    required this.classYear,
    required this.department,
    required this.email,
    required this.phone,
    this.id = '',
    this.about,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.isDeleted = false,
    this.deletedAt,
    this.deletedBy,
  });

  /// Firestore belge verisinden üretir; [id] belge kimliğidir.
  factory JoinApplicationModel.fromJson(
    Map<String, Object?> json, {
    required String id,
  }) => _$JoinApplicationModelFromJson(json).copyWith(id: id);

  /// Belge kimliği (JSON'a yazılmaz).
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String id;

  /// Ad.
  @JsonKey(name: FirestoreFields.firstName)
  final String firstName;

  /// Soyad.
  @JsonKey(name: FirestoreFields.lastName)
  final String lastName;

  /// Sınıf (serbest metin, ör. "2. sınıf").
  @JsonKey(name: FirestoreFields.classYear)
  final String classYear;

  /// Bölüm.
  @JsonKey(name: FirestoreFields.department)
  final String department;

  /// E-posta.
  @JsonKey(name: FirestoreFields.email)
  final String email;

  /// Telefon.
  @JsonKey(name: FirestoreFields.phone)
  final String phone;

  /// Başvuranın kendini tanıttığı metin; yazılmadıysa `null`.
  @JsonKey(name: FirestoreFields.about)
  final String? about;

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
  Map<String, Object?> toJson() => _$JoinApplicationModelToJson(this);

  /// Verilen alanları değişmiş kopya.
  JoinApplicationModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? classYear,
    String? department,
    String? email,
    String? phone,
    String? about,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    bool? isDeleted,
    DateTime? deletedAt,
    String? deletedBy,
    bool clearDeletion = false,
  }) => JoinApplicationModel(
    id: id ?? this.id,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    classYear: classYear ?? this.classYear,
    department: department ?? this.department,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    about: about ?? this.about,
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
    firstName,
    lastName,
    classYear,
    department,
    email,
    phone,
    about,
    createdAt,
    updatedAt,
    createdBy,
    isDeleted,
    deletedAt,
    deletedBy,
  ];
}
