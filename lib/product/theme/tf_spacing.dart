import 'package:flutter/widgets.dart';

/// Boşluk ölçeği (`docs/token-map.md`). Ekran koduna sayı yazılmaz.
abstract final class TfSpacing {
  static const double s2 = 2;
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s32 = 32;
  static const double s40 = 40;
  static const double s48 = 48;
  static const double s64 = 64;
  static const double s80 = 80;
  static const double s96 = 96;
}

/// Hazır boşluk widget'ları: `TfGap.h16` dikey, `TfGap.w16` yatay boşluk.
abstract final class TfGap {
  static const SizedBox h4 = SizedBox(height: TfSpacing.s4);
  static const SizedBox h8 = SizedBox(height: TfSpacing.s8);
  static const SizedBox h12 = SizedBox(height: TfSpacing.s12);
  static const SizedBox h16 = SizedBox(height: TfSpacing.s16);
  static const SizedBox h24 = SizedBox(height: TfSpacing.s24);
  static const SizedBox h32 = SizedBox(height: TfSpacing.s32);
  static const SizedBox h48 = SizedBox(height: TfSpacing.s48);

  static const SizedBox w4 = SizedBox(width: TfSpacing.s4);
  static const SizedBox w8 = SizedBox(width: TfSpacing.s8);
  static const SizedBox w12 = SizedBox(width: TfSpacing.s12);
  static const SizedBox w16 = SizedBox(width: TfSpacing.s16);
  static const SizedBox w24 = SizedBox(width: TfSpacing.s24);
}

/// Hazır iç boşluklar.
abstract final class TfInsets {
  static const EdgeInsets all8 = EdgeInsets.all(TfSpacing.s8);
  static const EdgeInsets all12 = EdgeInsets.all(TfSpacing.s12);
  static const EdgeInsets all16 = EdgeInsets.all(TfSpacing.s16);
  static const EdgeInsets all24 = EdgeInsets.all(TfSpacing.s24);
  static const EdgeInsets all32 = EdgeInsets.all(TfSpacing.s32);

  /// Hap biçimli buton iç boşluğu.
  static const EdgeInsets button = EdgeInsets.symmetric(
    horizontal: TfSpacing.s20,
    vertical: TfSpacing.s12,
  );

  /// Üst bardaki menü linkinin iç boşluğu.
  static const EdgeInsets navLink = EdgeInsets.symmetric(
    horizontal: TfSpacing.s12,
    vertical: TfSpacing.s8,
  );

  /// Çekmece menü satırının iç boşluğu.
  static const EdgeInsets drawerItem = EdgeInsets.symmetric(
    horizontal: TfSpacing.s24,
    vertical: TfSpacing.s16,
  );
}
