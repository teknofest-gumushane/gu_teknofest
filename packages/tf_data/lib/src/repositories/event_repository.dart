import 'package:tf_data/src/core/firebase_result.dart';
import 'package:tf_data/src/models/event_model.dart';

/// Etkinlikler (`event` verisi). Silme soft delete'tir (D-10).
abstract interface class EventRepository {
  /// Silinmemiş etkinlikler, en yeni önce.
  Future<FirestoreResult<List<EventModel>>> fetchEvents();

  /// Kimliği boşsa oluşturur, doluysa günceller; kaydedileni döner.
  /// Güncellenecek kayıt yoksa `FirestoreError.notFound`.
  Future<FirestoreResult<EventModel>> saveEvent(EventModel item);

  /// Kaydı silinmiş olarak işaretler.
  Future<FirestoreResult<void>> softDeleteEvent(String id);

  /// Silinmiş kaydı geri alır.
  Future<FirestoreResult<void>> restoreEvent(String id);
}
