/// Sabit ölçüler (`docs/token-map.md`). Boşluklar `TfSpacing`'tedir.
abstract final class TfSizes {
  /// İçerik en fazla genişliği.
  static const double contentMaxWidth = 1152;

  /// Üst bar logosu, sayfa başında.
  static const double headerLogoLarge = 72;

  /// Üst bar logosu, sayfa kaydırılınca.
  static const double headerLogoSmall = 44;

  /// Üst barın küçülmeye başladığı kaydırma miktarı.
  static const double headerShrinkOffset = 24;

  /// En küçük dokunma alanı; ikon butonların kenarı.
  static const double tapTarget = 44;

  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconLg = 24;
  static const double iconXl = 40;

  /// Çekmece menü genişliği.
  static const double drawerWidth = 320;

  /// "Yakında" kartının en fazla genişliği.
  static const double comingSoonMaxWidth = 480;

  /// Bulunamadı sayfasındaki logonun kenarı.
  static const double notFoundLogo = 160;

  /// Beyaz daire zeminli logoda görselin daireye oranı: kare görsel dairenin
  /// içine kırpılmadan sığar.
  static const double logoPlateContentFactor = 0.72;

  static const double borderThin = 1;
  static const double focusRing = 2;
}
