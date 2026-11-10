import 'package:flutter/widgets.dart';
import 'package:gu_teknofest/product/extension/build_context_responsive_x.dart';
import 'package:gu_teknofest/product/extension/build_context_x.dart';
import 'package:gu_teknofest/product/extension/string_x.dart';
import 'package:gu_teknofest/product/theme/tf_spacing.dart';
import 'package:gu_teknofest/product/widget/tf_max_width_box.dart';

/// Genel sayfadaki bir bölümün ortak çerçevesi: üst etiket, başlık, isteğe
/// bağlı alt metin ve içerik. Her bölüm bununla başlar; böylece boşluklar ve
/// başlık stilleri tüm sayfada aynı kalır.
class TfSectionFrame extends StatelessWidget {
  /// Çerçeve oluşturur. [decoration] verilirse zemin odur (ör. gradyan) ve
  /// metinler açık renk yazılır ([onBrand]).
  const TfSectionFrame({
    required this.eyebrow,
    required this.title,
    required this.child,
    this.subtitle,
    this.decoration,
    this.alternate = false,
    this.onBrand = false,
    super.key,
  });

  /// Başlığın üstündeki küçük etiket (büyük harfe çevrilir).
  final String eyebrow;

  /// Bölüm başlığı.
  final String title;

  /// Başlığın altındaki açıklama.
  final String? subtitle;

  /// Bölüm içeriği.
  final Widget child;

  /// Özel zemin; verilmezse [alternate]'e göre düz renk.
  final Decoration? decoration;

  /// Beyaz zemin (`card`); `false` ise sayfa zemini (`surface`). Ardışık
  /// bölümler dönüşümlü kullanır.
  final bool alternate;

  /// Koyu (marka) zemin üstünde mi: metinler açık renk yazılır.
  final bool onBrand;

  @override
  Widget build(BuildContext context) {
    final tf = context.tf;
    final colors = tf.colors;
    final subtitle = this.subtitle;
    return DecoratedBox(
      decoration:
          decoration ??
          BoxDecoration(color: alternate ? colors.card : colors.surface),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.sectionSpacing),
        child: TfMaxWidthBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow.trUpper(),
                style: tf.text.eyebrow.copyWith(
                  color: onBrand ? colors.onBrandMuted : colors.accent,
                ),
              ),
              TfGap.h12,
              Semantics(
                header: true,
                child: Text(
                  title,
                  style: (onBrand ? tf.text.display : tf.text.headline)
                      .copyWith(color: onBrand ? colors.onBrand : colors.deep),
                ),
              ),
              if (subtitle != null) ...[
                TfGap.h16,
                Text(
                  subtitle,
                  style: tf.text.bodyLarge.copyWith(
                    color: onBrand ? colors.onBrandMuted : colors.textMuted,
                  ),
                ),
              ],
              TfGap.h32,
              child,
            ],
          ),
        ),
      ),
    );
  }
}
