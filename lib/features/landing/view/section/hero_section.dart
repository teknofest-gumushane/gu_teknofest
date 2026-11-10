import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gu_teknofest/product/extension/build_context_l10n_x.dart';
import 'package:gu_teknofest/product/theme/tf_gradients.dart';
import 'package:gu_teknofest/product/widget/tf_coming_soon.dart';
import 'package:gu_teknofest/product/widget/tf_section_frame.dart';

/// Giriş bölümü: gradyan zemin, başlık ve kulüp istatistikleri.
///
/// İçerik henüz yazılmadı: [TfComingSoon] yerine butonlar ve istatistik kartı
/// gelecek (`docs/analiz.md` §1 "Hero").
class HeroSection extends ConsumerWidget {
  /// Bölümü oluşturur.
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return TfSectionFrame(
      eyebrow: l10n.heroEyebrow,
      title: l10n.heroTitle,
      subtitle: l10n.heroSubtitle,
      decoration: BoxDecoration(gradient: TfGradients.hero),
      onBrand: true,
      child: const TfComingSoon(onBrand: true),
    );
  }
}
