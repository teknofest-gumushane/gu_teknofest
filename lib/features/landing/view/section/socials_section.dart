import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gu_teknofest/product/extension/build_context_l10n_x.dart';
import 'package:gu_teknofest/product/widget/tf_coming_soon.dart';
import 'package:gu_teknofest/product/widget/tf_section_frame.dart';

/// Sosyal medya bölümü: kulübün hesaplarına bağlantılar.
///
/// İçerik henüz yazılmadı: [TfComingSoon] yerine gerçek içerik gelecek
/// (`docs/analiz.md` §1 "Sosyal medya").
class SocialsSection extends ConsumerWidget {
  /// Bölümü oluşturur.
  const SocialsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return TfSectionFrame(
      eyebrow: l10n.socialsEyebrow,
      title: l10n.socialsTitle,
      alternate: true,
      child: const TfComingSoon(),
    );
  }
}
