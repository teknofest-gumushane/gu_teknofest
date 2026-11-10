import 'package:flutter/widgets.dart';
import 'package:gu_teknofest/product/extension/build_context_l10n_x.dart';
import 'package:gu_teknofest/product/extension/build_context_x.dart';
import 'package:gu_teknofest/product/theme/tf_sizes.dart';
import 'package:gu_teknofest/product/theme/tf_spacing.dart';
import 'package:gu_teknofest/product/widget/tf_logo.dart';
import 'package:gu_teknofest/product/widget/tf_max_width_box.dart';

/// Genel sayfanın alt bilgisi. Şimdilik logo, marka adı ve telif satırı;
/// adres ve iletişim bilgileri ayrı bir görevde eklenecek.
class LandingFooter extends StatelessWidget {
  /// Alt bilgiyi oluşturur. [year] testlerde sabitlenebilir.
  const LandingFooter({this.year, super.key});

  /// Telif satırındaki yıl; verilmezse içinde bulunulan yıl.
  final int? year;

  @override
  Widget build(BuildContext context) {
    final tf = context.tf;
    final colors = tf.colors;
    final l10n = context.l10n;
    return ColoredBox(
      color: colors.brandPurple,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TfSpacing.s48),
        child: TfMaxWidthBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const TfLogo(
                    size: TfSizes.headerLogoLarge,
                    decorative: true,
                    plate: true,
                  ),
                  TfGap.w12,
                  Flexible(
                    child: Text(
                      '${l10n.brandUniversity} ${l10n.brandName}',
                      style: tf.text.title.copyWith(color: colors.onBrand),
                    ),
                  ),
                ],
              ),
              TfGap.h16,
              Text(
                l10n.footerCopyright('${year ?? DateTime.now().year}'),
                style: tf.text.bodySmall.copyWith(color: colors.onBrandMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
