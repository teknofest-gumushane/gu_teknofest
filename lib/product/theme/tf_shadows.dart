import 'package:flutter/widgets.dart';
import 'package:gu_teknofest/product/theme/tf_colors.dart';

/// Gölgeler (`docs/token-map.md`).
abstract final class TfShadows {
  /// Kart gölgesi.
  static final List<BoxShadow> soft = [
    BoxShadow(
      color: TfColors.light.shadow,
      offset: const Offset(0, 20),
      blurRadius: 45,
      spreadRadius: -20,
    ),
  ];

  /// Yapışkan üst barın altındaki gölge.
  static final List<BoxShadow> header = [
    BoxShadow(
      color: TfColors.light.shadow,
      offset: const Offset(0, 4),
      blurRadius: 16,
      spreadRadius: -8,
    ),
  ];
}
