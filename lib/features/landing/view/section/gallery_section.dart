import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gu_teknofest/product/extension/build_context_l10n_x.dart';
import 'package:gu_teknofest/product/widget/tf_coming_soon.dart';
import 'package:gu_teknofest/product/widget/tf_section_frame.dart';

/// Galeri bölümü: görsel ızgarası ve büyük görünüm.
///
/// İçerik henüz yazılmadı: [TfComingSoon] yerine gerçek içerik gelecek
/// (`docs/analiz.md` §1 "Galeri").
class GallerySection extends ConsumerWidget {
  /// Bölümü oluşturur.
  const GallerySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return TfSectionFrame(
      eyebrow: l10n.galleryEyebrow,
      title: l10n.galleryTitle,
      alternate: true,
      child: const TfComingSoon(),
    );
  }
}
