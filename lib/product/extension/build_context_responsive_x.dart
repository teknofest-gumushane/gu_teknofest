import 'package:flutter/widgets.dart';
import 'package:gu_teknofest/product/theme/tf_breakpoints.dart';
import 'package:gu_teknofest/product/theme/tf_spacing.dart';

/// Responsive erişim: `context.isMobile`, `context.pageGutter`.
extension TfResponsiveX on BuildContext {
  /// Ekran genişliği.
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Ekran sınıfı.
  TfDeviceClass get deviceClass => TfBreakpoints.classOf(screenWidth);

  /// 640 px altı.
  bool get isMobile => deviceClass == TfDeviceClass.mobile;

  /// 640 – 1023 px.
  bool get isTablet => deviceClass == TfDeviceClass.tablet;

  /// 1024 px ve üstü.
  bool get isDesktop => deviceClass == TfDeviceClass.desktop;

  /// Sayfa kenar boşluğu.
  double get pageGutter => switch (deviceClass) {
    TfDeviceClass.mobile => TfSpacing.s16,
    TfDeviceClass.tablet => TfSpacing.s24,
    TfDeviceClass.desktop => TfSpacing.s32,
  };

  /// Bölümlerin üst ve alt boşluğu.
  double get sectionSpacing => isMobile ? TfSpacing.s80 : TfSpacing.s96;
}
