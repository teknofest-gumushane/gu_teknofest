import 'package:flutter_svg/flutter_svg.dart';
import 'package:gu_teknofest/product/icon/tf_icons.dart';
import 'package:gu_teknofest/product/theme/tf_sizes.dart';
import 'package:material_ui/material_ui.dart';

/// [TfIcons] kayıt defterindeki bir ikonu çizer.
class TfIcon extends StatelessWidget {
  /// İkon oluşturur. [semanticLabel] verilmezse ikon süs sayılır.
  const TfIcon(
    this.icon, {
    this.size = TfSizes.iconMd,
    this.color,
    this.semanticLabel,
    super.key,
  });

  /// Çizilecek ikon.
  final TfIconData icon;

  /// Kenar uzunluğu.
  final double size;

  /// Renk; verilmezse çevredeki ikon teması.
  final Color? color;

  /// Ekran okuyucu etiketi.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tint = color ?? IconTheme.of(context).color;
    return switch (icon) {
      TfMaterialIconData(:final data) => Icon(
        data,
        size: size,
        color: tint,
        semanticLabel: semanticLabel,
      ),
      TfSvgIconData(:final asset) => SvgPicture.asset(
        asset,
        width: size,
        height: size,
        semanticsLabel: semanticLabel,
        excludeFromSemantics: semanticLabel == null,
        colorFilter: tint == null
            ? null
            : ColorFilter.mode(tint, BlendMode.srcIn),
      ),
    };
  }
}
