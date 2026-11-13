import 'package:gu_teknofest/features/landing/view/landing_section_id.dart';
import 'package:gu_teknofest/product/extension/build_context_l10n_x.dart';
import 'package:gu_teknofest/product/extension/build_context_x.dart';
import 'package:gu_teknofest/product/icon/tf_icon.dart';
import 'package:gu_teknofest/product/icon/tf_icons.dart';
import 'package:gu_teknofest/product/theme/tf_sizes.dart';
import 'package:gu_teknofest/product/theme/tf_spacing.dart';
import 'package:gu_teknofest/product/widget/tf_button.dart';
import 'package:material_ui/material_ui.dart';

/// Dar ekranlardaki çekmece menü: bölüm linkleri ve "Takıma Katıl" butonu.
class LandingDrawer extends StatelessWidget {
  /// Çekmeceyi oluşturur.
  const LandingDrawer({
    required this.onSectionSelected,
    required this.onJoin,
    super.key,
  });

  /// Bir bölüm seçildi.
  final ValueChanged<LandingSectionId> onSectionSelected;

  /// "Takıma Katıl" basıldı.
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    final tf = context.tf;
    final colors = tf.colors;
    final l10n = context.l10n;
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: TfInsets.drawerItem,
              child: Row(
                children: [
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: Text(
                        l10n.navMenuTitle,
                        style: tf.text.title.copyWith(color: colors.deep),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Scaffold.of(context).closeEndDrawer(),
                    tooltip: l10n.navCloseMenu,
                    constraints: const BoxConstraints.tightFor(
                      width: TfSizes.tapTarget,
                      height: TfSizes.tapTarget,
                    ),
                    icon: TfIcon(TfIcons.close, color: colors.deep),
                  ),
                ],
              ),
            ),
            Divider(height: TfSizes.borderThin, color: colors.divider),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  for (final id in LandingSectionId.menu)
                    InkWell(
                      onTap: () => onSectionSelected(id),
                      child: Padding(
                        padding: TfInsets.drawerItem,
                        child: Text(
                          id.label(l10n),
                          style: tf.text.bodyLarge.copyWith(
                            color: colors.deep,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: TfInsets.all24,
              child: TfButton(
                label: l10n.navJoin,
                onPressed: onJoin,
                expand: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
