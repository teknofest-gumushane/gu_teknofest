/// Sayısal ve süre sınırları — tek yer. Servis ve repository kodunda sınır
/// sayısı elle yazılmaz; güvenlik kuralları yazılınca aynı değerler oradaki
/// karşılıklarıyla eşleşmelidir.
abstract final class Limits {
  // ── Kimlik doğrulama (admin girişi) ──────────────────────────────────

  /// Kilitlenmeden önce izin verilen hatalı giriş sayısı (`LoginThrottle`).
  static const int loginMaxFailedAttempts = 5;

  /// Hatalı giriş kilidinin süresi (`LoginThrottle`).
  static const Duration loginLockout = Duration(seconds: 30);

  /// `AuthService` çağrılarının zaman aşımı.
  static const Duration authTimeout = Duration(seconds: 15);

  // ── Altyapı ──────────────────────────────────────────────────────────

  /// `FirestoreService` okuma / yazma zaman aşımı.
  static const Duration firestoreTimeout = Duration(seconds: 10);

  /// `StorageService.upload` zaman aşımı.
  static const Duration storageUploadTimeout = Duration(seconds: 60);

  /// `RetryPolicy` bekleme süreleri; deneme sayısı = liste uzunluğu.
  static const List<Duration> retryBackoff = [
    Duration(milliseconds: 250),
    Duration(milliseconds: 500),
    Duration(milliseconds: 1000),
  ];

  /// Tek `WriteBatch` içindeki yazma üst sınırı (Firestore 500 sınırının
  /// altında pay).
  static const int batchMaxWrites = 450;

  /// Sayfalı sorguların varsayılan sayfa boyutu.
  static const int pageSize = 20;

  /// Türkiye saati sabit UTC+3'tür (yaz saati yok).
  static const Duration istanbulUtcOffset = Duration(hours: 3);

  // ── Görseller ────────────────────────────────────────────────────────

  /// Yüklenebilen bir görselin en büyük boyutu (5 MB). Proje, etkinlik,
  /// galeri, üye fotoğrafı ve logo için aynıdır.
  static const int imageMaxBytes = 5 * 1024 * 1024;
}
