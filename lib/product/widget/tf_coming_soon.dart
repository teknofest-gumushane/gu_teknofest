import 'package:flutter/widgets.dart';
import 'package:gu_teknofest/product/extension/build_context_l10n_x.dart';
import 'package:gu_teknofest/product/extension/build_context_x.dart';
import 'package:gu_teknofest/product/icon/tf_icon.dart';
import 'package:gu_teknofest/product/icon/tf_icons.dart';
import 'package:gu_teknofest/product/theme/tf_radius.dart';
import 'package:gu_teknofest/product/theme/tf_shadows.dart';
import 'package:gu_teknofest/product/theme/tf_sizes.dart';
import 'package:gu_teknofest/product/theme/tf_spacing.dart';

/// İçeriği henüz yazılmamış bölümün yer tutucusu: "Bu bölüm yakında gelecek".
/// Bölümü yazan kişi bunu gerçek içerikle değiştirir.
class TfComingSoon extends StatelessWidget {
  /// Yer tutucu oluşturur. [onBrand] mor / gradyan zemin içindir.
  const TfComingSoon({this.onBrand = false, super.key});

  /// Koyu (marka) zemin üstünde mi.
  final bool onBrand;

  @override
  Widget build(BuildContext context) {
    final tf = context.tf;
    final colors = tf.colors;
    final l10n = context.l10n;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: TfSizes.comingSoonMaxWidth),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: onBrand ? colors.glass : colors.card,
          borderRadius: TfRadius.lgAll,
          border: Border.all(
            color: onBrand ? colors.glassBorder : colors.border,
          ),
          boxShadow: onBrand ? null : TfShadows.soft,
        ),
        child: Padding(
          padding: TfInsets.all24,
          child: Row(
            children: [
              TfIcon(
                TfIcons.comingSoon,
                size: TfSizes.iconLg,
                color: onBrand ? colors.onBrand : colors.primary,
              ),
              TfGap.w16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.comingSoonTitle,
                      style: tf.text.title.copyWith(
                        color: onBrand ? colors.onBrand : colors.deep,
                      ),
                    ),
                    TfGap.h4,
                    Text(
                      l10n.comingSoonBody,
                      style: tf.text.bodySmall.copyWith(
                        color: onBrand ? colors.onBrandMuted : colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
