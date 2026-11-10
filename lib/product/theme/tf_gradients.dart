import 'package:flutter/widgets.dart';
import 'package:gu_teknofest/product/theme/tf_colors.dart';

/// Gradyanlar (`docs/token-map.md`).
abstract final class TfGradients {
  /// Hero arka planı: sol üstten sağ alta mor → mavi → lacivert.
  static final LinearGradient hero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      TfColors.light.brandPurple,
      TfColors.light.primary,
      TfColors.light.deep,
    ],
  );
}
