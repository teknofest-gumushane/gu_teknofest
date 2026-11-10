import 'package:flutter/widgets.dart';
import 'package:gu_teknofest/product/theme/tf_theme_extension.dart';

/// Tema erişimi: `context.tf.colors`, `context.tf.text`.
extension TfBuildContextX on BuildContext {
  /// Renkler, yazı stilleri, ekran sınıfı ve hareket tercihi.
  TfThemeExtension get tf => TfThemeExtension.of(this);
}
