import 'package:flutter/animation.dart';

/// Süre ve eğriler (`docs/token-map.md`).
abstract final class TfMotion {
  /// Üzerine gelme, renk geçişi.
  static const Duration fast = Duration(milliseconds: 150);

  /// Üst bar küçülmesi, çekmece.
  static const Duration base = Duration(milliseconds: 300);

  /// Kartların aşağıdan belirmesi.
  static const Duration slow = Duration(milliseconds: 600);

  /// Menüden bölüme kaydırma.
  static const Duration scroll = Duration(milliseconds: 500);

  static const Curve standard = Curves.easeOutCubic;
  static const Curve emphasized = Curves.easeInOutCubic;
}
