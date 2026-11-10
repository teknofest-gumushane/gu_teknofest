// Uyarlama: gu_kulupler/packages/gu_data storage_paths.dart (MIT, aynı yazar). Dosya adı şeması ve
// doğrulama aynıdır; kökler ve yol üreticileri bu sitenin kayıtlarına göre yeniden yazıldı.
import 'dart:math';

import 'package:tf_data/src/constants/firestore_collections.dart';
import 'package:tf_data/src/core/app_clock.dart';

/// Storage nesne yolları — **tek** yol sınıfı (D-10).
///
/// Her yol `<kök>/<kimlik>/<dosya>` biçimindedir ve dosya adı daima
/// [newFileName] şemasındandır: `<UTC yyyyMMddTHHmmssZ>_<16 hex>.<uzantı>`.
/// Sabit ad (`logo.jpg`, `0.jpg`) hiçbir yolda kullanılmaz: değiştirme =
/// yeni dosya + Firestore yol alanı; eski dosya silinmez.
///
/// Üreticiler geçersiz girdide [ArgumentError] fırlatır (boş, `/` içeren ya
/// da `.` / `..` olan kimlik, şemaya uymayan dosya adı); doğrulayıcılar hiçbir
/// zaman fırlatmaz.
abstract final class StoragePaths {
  /// Kulüp logosunun kökü: `club/main/{file}`.
  static const String clubRoot = 'club';

  /// Proje görsellerinin kökü: `projects/{projectId}/{file}`.
  static const String projectsRoot = 'projects';

  /// Etkinlik görsellerinin kökü: `events/{eventId}/{file}`.
  static const String eventsRoot = 'events';

  /// Üye fotoğraflarının kökü: `members/{memberId}/{file}`.
  static const String membersRoot = 'members';

  /// Galeri görsellerinin kökü: `gallery/{itemId}/{file}`.
  static const String galleryRoot = 'gallery';

  /// İzinli içerik türü → dosya uzantısı. Yüklenebilen tek türler bunlardır
  /// (`StorageError.invalidType`); uzantı içerik türünden türetilir.
  static const Map<String, String> extensionByContentType = {
    'image/jpeg': 'jpg',
    'image/png': 'png',
    'image/webp': 'webp',
  };

  /// Dosya adı deseni (`RegExp` kaynağı; yol ayırıcı içermez):
  /// `yyyyMMddTHHmmssZ_<16 küçük hex>.(jpg|png|webp)`.
  static const String fileNamePattern =
      r'\d{8}T\d{6}Z_[0-9a-f]{16}\.(?:jpg|png|webp)';

  /// Kulüp logosu yolu: `club/main/{file}`.
  static String clubLogo(String file) =>
      _path(clubRoot, FirestoreCollections.clubInfoDoc, file);

  /// Proje görseli yolu: `projects/{projectId}/{file}`.
  static String projectImage(String projectId, String file) =>
      _path(projectsRoot, projectId, file);

  /// Etkinlik görseli yolu: `events/{eventId}/{file}`.
  static String eventImage(String eventId, String file) =>
      _path(eventsRoot, eventId, file);

  /// Üye fotoğrafı yolu: `members/{memberId}/{file}`.
  static String memberPhoto(String memberId, String file) =>
      _path(membersRoot, memberId, file);

  /// Galeri görseli yolu: `gallery/{itemId}/{file}`.
  static String galleryImage(String itemId, String file) =>
      _path(galleryRoot, itemId, file);

  /// Yeni, benzersiz dosya adı: `<UTC yyyyMMddTHHmmssZ>_<16 hex>.<ext>`
  /// (örnek `20261008T201501Z_3f9a1c2b7d4e5f60.jpg`).
  ///
  /// Damga [clock] saatinden, 16 hex karakter (8 bayt) [random] kaynağından
  /// gelir; üretimde kaynak `Random.secure()` olmalıdır (ad tahmin edilemez,
  /// üzerine yazma olmaz). [ext] içerik türünden türetilir
  /// ([extensionByContentType]) ve `jpg`, `png`, `webp` dışında olamaz
  /// ([ArgumentError]).
  static String newFileName(AppClock clock, Random random, String ext) {
    if (!extensionByContentType.containsValue(ext)) {
      throw ArgumentError.value(ext, 'ext', 'jpg, png ya da webp olmalı');
    }
    final now = clock.nowUtc().toUtc();
    final stamp =
        '${_pad(now.year, 4)}${_pad(now.month, 2)}${_pad(now.day, 2)}'
        'T${_pad(now.hour, 2)}${_pad(now.minute, 2)}${_pad(now.second, 2)}Z';
    final hex = StringBuffer();
    for (var i = 0; i < _randomBytes; i++) {
      hex.write(_pad(random.nextInt(_byteRange), 2, radix: 16));
    }
    return '${stamp}_$hex.$ext';
  }

  /// [path] kulüp logosu yolu mu (`club/main/{file}`)?
  static bool isClubLogo(String path) =>
      _matches(clubRoot, FirestoreCollections.clubInfoDoc, path);

  /// [path], [projectId] projesinin görsel yolu mu?
  static bool isProjectImage(String path, String projectId) =>
      _matches(projectsRoot, projectId, path);

  /// [path], [eventId] etkinliğinin görsel yolu mu?
  static bool isEventImage(String path, String eventId) =>
      _matches(eventsRoot, eventId, path);

  /// [path], [memberId] üyesinin fotoğraf yolu mu?
  static bool isMemberPhoto(String path, String memberId) =>
      _matches(membersRoot, memberId, path);

  /// [path], [itemId] galeri kaydının görsel yolu mu?
  static bool isGalleryImage(String path, String itemId) =>
      _matches(galleryRoot, itemId, path);

  static String _path(String root, String id, String file) {
    if (!_isSegment(id)) {
      throw ArgumentError.value(id, 'id', 'tek yol parçası olmalı');
    }
    if (!_fileName.hasMatch(file)) {
      throw ArgumentError.value(
        file,
        'file',
        'StoragePaths.newFileName şemasında olmalı',
      );
    }
    return '$root/$id/$file';
  }

  static bool _matches(String root, String id, String path) =>
      _isSegment(id) &&
      RegExp(
        '^${RegExp.escape(root)}/${RegExp.escape(id)}/$fileNamePattern\$',
      ).hasMatch(path);

  /// Tek yol parçası: boş değil, `/` içermez, `.` ya da `..` değil.
  static bool _isSegment(String value) =>
      value.isNotEmpty && !value.contains('/') && value != '.' && value != '..';

  static String _pad(int value, int width, {int radix = 10}) =>
      value.toRadixString(radix).padLeft(width, '0');

  static final RegExp _fileName = RegExp('^$fileNamePattern\$');
  static const int _randomBytes = 8;
  static const int _byteRange = 256;
}
