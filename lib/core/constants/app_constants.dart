/// Uygulama genelindeki sabitler. Arayüz metinleri burada değil ARB'dedir.
abstract final class AppConstants {
  /// Sahte veri dosyalarının klasörü (`ENV=mock`).
  static const String mockAssetDir = 'assets/mock';

  /// Sahte veri dosyalarının uzantısı.
  static const String mockAssetExtension = '.json';
}

/// Görsel dosya yolları.
abstract final class AppAssets {
  /// Resmi TEKNOFEST logosu (saydam zeminli PNG; `assets/README.md`).
  static const String logo = 'assets/images/logo.png';
}
