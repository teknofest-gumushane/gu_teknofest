import 'package:flutter/widgets.dart';
import 'package:gu_teknofest/core/constants/app_constants.dart';
import 'package:gu_teknofest/product/extension/build_context_l10n_x.dart';
import 'package:gu_teknofest/product/extension/build_context_x.dart';
import 'package:gu_teknofest/product/theme/tf_sizes.dart';

/// Resmi TEKNOFEST logosu (D-24). Görsel olduğu gibi gösterilir; kırpılmaz,
/// yeniden renklendirilmez.
class TfLogo extends StatelessWidget {
  /// Logo oluşturur; [size] kenar uzunluğudur.
  const TfLogo({
    required this.size,
    this.decorative = false,
    this.plate = false,
    super.key,
  });

  /// Kenar uzunluğu ([plate] açıksa dairenin çapı).
  final double size;

  /// Yanında marka adı yazıyorsa `true`: ekran okuyucu logoyu atlar.
  final bool decorative;

  /// Koyu (marka) zemin üstünde logoyu beyaz bir dairenin içine alır; logonun
  /// renkleri mor zeminde okunmaz.
  final bool plate;

  @override
  Widget build(BuildContext context) {
    final imageSize = plate ? size * TfSizes.logoPlateContentFactor : size;
    final image = Image.asset(
      AppAssets.logo,
      width: imageSize,
      height: imageSize,
      excludeFromSemantics: decorative,
      semanticLabel: decorative ? null : context.l10n.logoSemantics,
    );
    if (!plate) return image;
    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.tf.colors.card,
          shape: BoxShape.circle,
        ),
        child: Center(child: image),
      ),
    );
  }
}
