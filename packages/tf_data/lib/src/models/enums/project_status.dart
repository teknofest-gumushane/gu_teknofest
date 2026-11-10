import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

/// Proje durumu (`projects.status`).
@JsonEnum(valueField: 'json')
enum ProjectStatus {
  /// Geliştirmesi devam ediyor.
  active('active'),

  /// Tamamlandı.
  completed('completed');

  const ProjectStatus(this.json);

  /// Firestore'daki dizgi karşılığı.
  final String json;

  /// Firestore dizgisinden değer üretir. Bilinmeyen değer [ArgumentError]
  /// fırlatır (model ayrıştırmasında `FirestoreError.parse`).
  static ProjectStatus fromJson(String json) =>
      values.firstWhereOrNull((value) => value.json == json) ??
      (throw ArgumentError.value(
        json,
        'json',
        'ProjectStatus: bilinmeyen değer',
      ));
}
