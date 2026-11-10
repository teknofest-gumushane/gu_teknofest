/// Firestore koleksiyon ve sabit belge adları — tek yer.
abstract final class FirestoreCollections {
  /// Kulüp bilgisi: tek belgeli koleksiyon ([clubInfoDoc]).
  static const String clubInfo = 'clubInfo';

  /// [clubInfo] koleksiyonundaki tek belgenin kimliği.
  static const String clubInfoDoc = 'main';

  /// Projeler.
  static const String projects = 'projects';

  /// Etkinlikler (yaklaşan ve geçmiş; ayrım etkinlik anına göre yapılır).
  static const String events = 'events';

  /// Ekip üyeleri.
  static const String members = 'members';

  /// Galeri görselleri.
  static const String gallery = 'gallery';

  /// Takıma Katıl başvuruları (D-14).
  static const String applications = 'applications';
}
