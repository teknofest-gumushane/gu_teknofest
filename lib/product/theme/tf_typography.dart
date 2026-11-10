import 'package:flutter/widgets.dart';
import 'package:gu_teknofest/product/theme/tf_breakpoints.dart';

/// Yazı stilleri (`docs/token-map.md`). Ekran kodu `context.tf.text.*` ile
/// erişir. Stiller renksizdir; renk çağrı yerinde `context.tf.colors` ile
/// verilir.
@immutable
final class TfTypography {
  const TfTypography._({
    required this.display,
    required this.headline,
    required this.title,
    required this.bodyLarge,
    required this.body,
    required this.bodySmall,
    required this.label,
    required this.eyebrow,
    required this.caption,
  });

  /// [width] genişliğindeki ekran için stiller (başlıklar küçük ekranda
  /// küçülür).
  factory TfTypography.forWidth(double width) {
    final device = TfBreakpoints.classOf(width);
    return TfTypography._(
      display: switch (device) {
        TfDeviceClass.desktop => _style(60, 64, semiBold),
        TfDeviceClass.tablet => _style(48, 52, semiBold),
        TfDeviceClass.mobile => _style(36, 40, semiBold),
      },
      headline: device == TfDeviceClass.mobile
          ? _style(30, 38, semiBold)
          : _style(36, 44, semiBold),
      title: _style(20, 28, semiBold),
      bodyLarge: _style(18, 28, regular),
      body: _style(16, 26, regular),
      bodySmall: _style(14, 22, regular),
      label: _style(14, 20, semiBold),
      eyebrow: _style(13, 18, semiBold, letterSpacing: 2.6),
      caption: _style(12, 16, medium),
    );
  }

  /// Gömülü yazı tipi ailesi (D-20).
  static const String fontFamily = 'Inter';

  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;

  /// Ana başlık.
  final TextStyle display;

  /// Bölüm başlığı.
  final TextStyle headline;

  /// Kart başlığı, marka adı.
  final TextStyle title;

  /// Giriş metni.
  final TextStyle bodyLarge;

  /// Gövde.
  final TextStyle body;

  /// İkincil metin.
  final TextStyle bodySmall;

  /// Buton, menü linki.
  final TextStyle label;

  /// Bölüm üst etiketi (büyük harfle yazılır).
  final TextStyle eyebrow;

  /// Küçük not.
  final TextStyle caption;

  static TextStyle _style(
    double size,
    double lineHeight,
    FontWeight weight, {
    double? letterSpacing,
  }) => TextStyle(
    fontFamily: fontFamily,
    fontSize: size,
    height: lineHeight / size,
    fontWeight: weight,
    letterSpacing: letterSpacing,
  );
}
