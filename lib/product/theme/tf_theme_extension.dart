import 'package:flutter/material.dart';
import 'package:gu_teknofest/product/theme/tf_breakpoints.dart';
import 'package:gu_teknofest/product/theme/tf_colors.dart';
import 'package:gu_teknofest/product/theme/tf_typography.dart';

/// `context.tf` ile erişilen tema kümesi: renkler, yazı stilleri, ekran sınıfı
/// ve hareket tercihi.
@immutable
final class TfThemeExtension {
  const TfThemeExtension._({
    required this.colors,
    required this.text,
    required this.deviceClass,
    required this.reduceMotion,
  });

  /// [context]'teki temadan ve ekran ölçüsünden üretir.
  factory TfThemeExtension.of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return TfThemeExtension._(
      colors: Theme.of(context).extension<TfColors>() ?? TfColors.light,
      text: TfTypography.forWidth(width),
      deviceClass: TfBreakpoints.classOf(width),
      reduceMotion: MediaQuery.maybeDisableAnimationsOf(context) ?? false,
    );
  }

  /// Renk token'ları.
  final TfColors colors;

  /// Yazı stilleri (ekran genişliğine göre).
  final TfTypography text;

  /// Ekran sınıfı.
  final TfDeviceClass deviceClass;

  /// Kullanıcı hareketi azaltmayı istedi mi.
  final bool reduceMotion;

  /// [duration] süresi; hareket azaltılmışsa sıfır.
  Duration duration(Duration duration) =>
      reduceMotion ? Duration.zero : duration;
}
