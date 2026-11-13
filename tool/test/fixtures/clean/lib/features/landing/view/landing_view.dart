import 'package:fixture_app/features/landing/provider/projects_view_model.dart';
import 'package:fixture_app/product/theme/tf_colors.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Yorum içindeki Color(0xFF000000) ve Text('örnek') ihlal sayılmaz.
class LandingView extends ConsumerWidget {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.all(TfSpacing.s16),
      child: Column(
        children: [
          Text(context.l10n.heroTitle),
          const SizedBox(height: 0),
          Container(color: Colors.transparent),
          // ignore-hardcode: logo oranı tasarımda sabit
          SizedBox(width: 44, child: Icon(TfIcons.menu)),
          SizedBox(height: 2), // ignore-hardcode: ince ayırıcı çizgi
        ],
      ),
    );
  }
}
