import 'dart:ui';

/// Ekranların denendiği genişlikler (`CLAUDE.md` §10).
abstract final class TfTestSizes {
  /// En dar telefon.
  static const Size mobile = Size(320, 640);

  /// Tablet (hamburger menü).
  static const Size tablet = Size(768, 1024);

  /// Masaüstü alt sınırı (üst barda linkler).
  static const Size desktop = Size(1024, 768);

  /// Geniş masaüstü.
  static const Size wide = Size(1440, 900);

  /// Dört genişliğin tamamı.
  static const List<Size> all = [mobile, tablet, desktop, wide];
}
