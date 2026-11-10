import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tf_data/src/constants/firestore_fields.dart';

part 'event_image_model.g.dart';

/// Etkinlik görseli — `events.images[]` gömülü nesnesi.
@JsonSerializable()
final class EventImageModel extends Equatable {
  /// Etkinlik görseli oluşturur.
  const EventImageModel({required this.path, this.title, this.description});

  /// Firestore haritasından üretir.
  factory EventImageModel.fromJson(Map<String, Object?> json) =>
      _$EventImageModelFromJson(json);

  /// Görselin depolama yolu.
  @JsonKey(name: FirestoreFields.path)
  final String path;

  /// Görsel başlığı; yoksa `null`.
  @JsonKey(name: FirestoreFields.title)
  final String? title;

  /// Görsel açıklaması; yoksa `null`.
  @JsonKey(name: FirestoreFields.description)
  final String? description;

  /// Firestore haritası.
  Map<String, Object?> toJson() => _$EventImageModelToJson(this);

  @override
  List<Object?> get props => [path, title, description];
}
