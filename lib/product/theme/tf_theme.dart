import 'package:gu_teknofest/product/theme/tf_colors.dart';
import 'package:gu_teknofest/product/theme/tf_radius.dart';
import 'package:gu_teknofest/product/theme/tf_sizes.dart';
import 'package:gu_teknofest/product/theme/tf_typography.dart';
import 'package:material_ui/material_ui.dart';

/// Uygulama teması: token'ları Flutter'ın `ThemeData`'sına bağlar.
abstract final class TfTheme {
  /// Açık tema.
  static ThemeData light() {
    const colors = TfColors.light;
    final scheme = ColorScheme.fromSeed(
      seedColor: colors.primary,
      primary: colors.primary,
      onPrimary: colors.onBrand,
      secondary: colors.accent,
      surface: colors.card,
      onSurface: colors.text,
      error: colors.danger,
    );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: TfTypography.fontFamily,
      scaffoldBackgroundColor: colors.surface,
      extensions: const [colors],
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: colors.text,
        displayColor: colors.deep,
      ),
      dividerColor: colors.divider,
      focusColor: colors.border,
      drawerTheme: DrawerThemeData(
        backgroundColor: colors.card,
        scrimColor: colors.scrim,
        width: TfSizes.drawerWidth,
        shape: const RoundedRectangleBorder(),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colors.deep,
        contentTextStyle: TfTypography.forWidth(0).bodySmall.copyWith(
          color: colors.onBrand,
        ),
        shape: const RoundedRectangleBorder(borderRadius: TfRadius.mdAll),
      ),
    );
  }
}
