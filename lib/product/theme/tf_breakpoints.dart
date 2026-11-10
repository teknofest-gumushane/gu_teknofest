/// Ekran sınıfı: düzen kararları buna göre verilir.
enum TfDeviceClass {
  /// 640 px altı: tek sütun.
  mobile,

  /// 640 – 1023 px: iki sütun, hamburger menü.
  tablet,

  /// 1024 px ve üstü: üç sütun, üst barda linkler.
  desktop,
}

/// Kırılma noktaları (`docs/token-map.md`).
abstract final class TfBreakpoints {
  static const double tablet = 640;
  static const double tabletLarge = 768;
  static const double desktop = 1024;

  /// [width] genişliğinin ekran sınıfı.
  static TfDeviceClass classOf(double width) {
    if (width >= desktop) return TfDeviceClass.desktop;
    if (width >= tablet) return TfDeviceClass.tablet;
    return TfDeviceClass.mobile;
  }
}
