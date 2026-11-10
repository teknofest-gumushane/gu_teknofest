/// Firestore belge alan adları — JSON anahtarlarının **tek** kaynağı.
///
/// Modellerdeki her JSON anahtarı burada aynı adla bir sabittir; sorgu ve
/// yüklerde alan adı elle yazılmaz. Aynı anahtar birden çok koleksiyonda
/// geçiyorsa (`name`, `description`, `displayOrder` …) bir kez tanımlanır.
/// Belge kimlikleri JSON'a yazılmaz; bu yüzden sabitleri yoktur.
/// Koleksiyon adları `FirestoreCollections` içindedir.
abstract final class FirestoreFields {
  // ── Ortak alanlar — BaseFields ───────────────────────────────────────

  /// Oluşturulma anı (sunucu zamanı).
  static const String createdAt = 'createdAt';

  /// Son güncelleme anı (sunucu zamanı).
  static const String updatedAt = 'updatedAt';

  /// Kaydı oluşturan yöneticinin kimliği.
  static const String createdBy = 'createdBy';

  /// Soft delete bayrağı (D-10). Okuma sorguları `false` olanları süzer.
  static const String isDeleted = 'isDeleted';

  /// Silinme anı; silinmemiş kayıtta yoktur.
  static const String deletedAt = 'deletedAt';

  /// Silen yöneticinin kimliği; silinmemiş kayıtta yoktur.
  static const String deletedBy = 'deletedBy';

  // ── Birden çok koleksiyonda geçenler ─────────────────────────────────

  /// `projects`, `events`, `members` kayıtlarının adı.
  static const String name = 'name';

  /// `projects`, `events`, `members`, `gallery` ve görsel açıklaması.
  static const String description = 'description';

  /// `members` ünvanı; `gallery` ve etkinlik görseli başlığı.
  static const String title = 'title';

  /// `projects`, `members`, `gallery` görselinin depolama yolu.
  static const String imagePath = 'imagePath';

  /// `projects`, `members`, `gallery` listelerindeki sıra (küçük önce).
  static const String displayOrder = 'displayOrder';

  // ── clubInfo ─────────────────────────────────────────────────────────

  /// Kulüp logosunun depolama yolu.
  static const String logoPath = 'logoPath';

  /// Toplam üye sayısı (admin elle girer).
  static const String memberCount = 'memberCount';

  /// Aktif üye sayısı (admin elle girer).
  static const String activeMemberCount = 'activeMemberCount';

  /// Proje sayısı (admin elle girer).
  static const String projectCount = 'projectCount';

  /// Başvurular açık mı.
  static const String isApplicationOpen = 'isApplicationOpen';

  // ── projects ─────────────────────────────────────────────────────────

  /// Proje etiketleri (metin listesi).
  static const String tags = 'tags';

  /// Proje durumu (`ProjectStatus`).
  static const String status = 'status';

  // ── events ───────────────────────────────────────────────────────────

  /// Etkinlik anı.
  static const String eventTime = 'eventTime';

  /// Etkinlik konumu (ör. kurum adı).
  static const String location = 'location';

  /// Etkinlik mekanı (ör. salon adı).
  static const String place = 'place';

  /// Etkinlik görselleri (gömülü liste).
  static const String images = 'images';

  /// Gömülü etkinlik görselinin depolama yolu (`images[].path`).
  static const String path = 'path';

  // ── members ──────────────────────────────────────────────────────────

  /// Üye ekipte gösterilsin mi.
  static const String isActive = 'isActive';

  // ── applications ─────────────────────────────────────────────────────

  /// Başvuranın adı.
  static const String firstName = 'firstName';

  /// Başvuranın soyadı.
  static const String lastName = 'lastName';

  /// Başvuranın sınıfı (serbest metin).
  static const String classYear = 'classYear';

  /// Başvuranın bölümü.
  static const String department = 'department';

  /// Başvuranın e-postası.
  static const String email = 'email';

  /// Başvuranın telefonu.
  static const String phone = 'phone';

  /// Başvuranın kendini tanıttığı metin (isteğe bağlı).
  static const String about = 'about';
}
