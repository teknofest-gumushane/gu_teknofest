import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gu_teknofest/product/extension/build_context_l10n_x.dart';
import 'package:gu_teknofest/product/widget/tf_coming_soon.dart';
import 'package:gu_teknofest/product/widget/tf_section_frame.dart';

/// Etkinlikler bölümü: yaklaşan ve geçmiş etkinlikler.
///
/// İçerik henüz yazılmadı: [TfComingSoon] yerine gerçek içerik gelecek
/// (`docs/analiz.md` §1 "Etkinlikler").
class EventsSection extends ConsumerWidget {
  /// Bölümü oluşturur.
  const EventsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return TfSectionFrame(
      eyebrow: l10n.eventsEyebrow,
      title: l10n.eventsTitle,
      child: const TfComingSoon(),
    );
  }
}
