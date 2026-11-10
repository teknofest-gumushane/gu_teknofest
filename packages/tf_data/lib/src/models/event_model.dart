import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tf_data/src/constants/firestore_fields.dart';
import 'package:tf_data/src/core/base_fields.dart';
import 'package:tf_data/src/models/event_image_model.dart';
import 'package:tf_data/src/utils/json_converters.dart';

part 'event_model.g.dart';

/// Etkinlik — `events/{eventId}` belgesi.
///
/// Yaklaşan ve geçmiş etkinlikler aynı koleksiyondadır; ayrım [eventTime]
/// ile yapılır ([isUpcomingAt]). Belge kimliği [id] JSON'a girmez.
@JsonSerializable()
final class EventModel extends Equatable with BaseFields {
  /// Etkinlik oluşturur; [id] verilmezse boş dizgidir.
  const EventModel({
    required this.name,
    required this.eventTime,
    this.id = '',
    this.description = '',
    this.location = '',
    this.place = '',
    this.images = const [],
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.isDeleted = false,
    this.deletedAt,
    this.deletedBy,
  });

  /// Firestore belge verisinden üretir; [id] belge kimliğidir.
  factory EventModel.fromJson(
    Map<String, Object?> json, {
    required String id,
  }) => _$EventModelFromJson(json).copyWith(id: id);

  /// Belge kimliği (JSON'a yazılmaz).
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String id;

  /// Etkinlik adı.
  @JsonKey(name: FirestoreFields.name)
  final String name;

  /// Açıklama.
  @JsonKey(name: FirestoreFields.description)
  final String description;

  /// Etkinlik anı (UTC).
  @JsonKey(name: FirestoreFields.eventTime)
  @RequiredTimestampConverter()
  final DateTime eventTime;

  /// Konum (ör. kurum adı).
  @JsonKey(name: FirestoreFields.location)
  final String location;

  /// Mekan (ör. salon adı).
  @JsonKey(name: FirestoreFields.place)
  final String place;

  /// Etkinlik görselleri.
  @JsonKey(name: FirestoreFields.images)
  final List<EventImageModel> images;

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

  /// Etkinlik [now] anında henüz başlamamış mı?
  bool isUpcomingAt(DateTime now) => eventTime.isAfter(now.toUtc());

  /// Firestore'a yazılacak harita ([id] hariç).
  Map<String, Object?> toJson() => _$EventModelToJson(this);

  /// Verilen alanları değişmiş kopya.
  EventModel copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? eventTime,
    String? location,
    String? place,
    List<EventImageModel>? images,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    bool? isDeleted,
    DateTime? deletedAt,
    String? deletedBy,
    bool clearDeletion = false,
  }) => EventModel(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    eventTime: eventTime ?? this.eventTime,
    location: location ?? this.location,
    place: place ?? this.place,
    images: images ?? this.images,
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
    eventTime,
    location,
    place,
    images,
    createdAt,
    updatedAt,
    createdBy,
    isDeleted,
    deletedAt,
    deletedBy,
  ];
}
