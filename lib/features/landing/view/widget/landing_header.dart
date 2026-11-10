import 'package:flutter/material.dart';
import 'package:gu_teknofest/features/landing/view/landing_section_id.dart';
import 'package:gu_teknofest/product/extension/build_context_l10n_x.dart';
import 'package:gu_teknofest/product/extension/build_context_responsive_x.dart';
import 'package:gu_teknofest/product/extension/build_context_x.dart';
import 'package:gu_teknofest/product/icon/tf_icon.dart';
import 'package:gu_teknofest/product/icon/tf_icons.dart';
import 'package:gu_teknofest/product/theme/tf_motion.dart';
import 'package:gu_teknofest/product/theme/tf_radius.dart';
import 'package:gu_teknofest/product/theme/tf_shadows.dart';
import 'package:gu_teknofest/product/theme/tf_sizes.dart';
import 'package:gu_teknofest/product/theme/tf_spacing.dart';
import 'package:gu_teknofest/product/widget/tf_button.dart';
import 'package:gu_teknofest/product/widget/tf_logo.dart';
import 'package:gu_teknofest/product/widget/tf_max_width_box.dart';

/// Genel sayfanın yapışkan üst barı: logo ve marka adı, masaüstünde bölüm
/// linkleri ve "Takıma Katıl" butonu, dar ekranda menü butonu. Sayfa
/// kaydırılınca küçülür ve gölge alır.
class LandingHeader extends StatelessWidget {
  /// Üst barı oluşturur.
  const LandingHeader({
    required this.isScrolled,
    required this.onLogoTap,
    required this.onSectionSelected,
    required this.onJoin,
    required this.onOpenMenu,
    super.key,
  });

  /// Sayfa kaydırıldı mı.
  final bool isScrolled;

  /// Logoya basıldı (sayfanın başına döner).
  final VoidCallback onLogoTap;

  /// Bir bölüm linkine basıldı.
  final ValueChanged<LandingSectionId> onSectionSelected;

  /// "Takıma Katıl" basıldı.
  final VoidCallback onJoin;

  /// Menü butonuna basıldı (dar ekran).
  final VoidCallback onOpenMenu;

  @override
  Widget build(BuildContext context) {
    final tf = context.tf;
    final colors = tf.colors;
    final l10n = context.l10n;
    return AnimatedContainer(
      duration: tf.duration(TfMotion.base),
      curve: TfMotion.standard,
      decoration: BoxDecoration(
        color: colors.headerBackground,
        boxShadow: isScrolled ? TfShadows.header : const [],
      ),
      padding: EdgeInsets.symmetric(
        vertical: isScrolled ? TfSpacing.s8 : TfSpacing.s16,
      ),
      child: SafeArea(
        bottom: false,
        child: TfMaxWidthBox(
          child: Row(
            children: context.isDesktop
                ? [
                    _Brand(isScrolled: isScrolled, onTap: onLogoTap),
                    TfGap.w16,
                    // Linkler kalan genişliğe sığmazsa taşmak yerine birlikte
                    // küçülür (dar masaüstü, büyütülmüş yazı).
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (final id in LandingSectionId.menu)
                                _NavLink(
                                  label: id.label(l10n),
                                  onTap: () => onSectionSelected(id),
                                ),
                              TfGap.w12,
                              TfButton(label: l10n.navJoin, onPressed: onJoin),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]
                : [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: _Brand(isScrolled: isScrolled, onTap: onLogoTap),
                      ),
                    ),
                    TfGap.w16,
                    _MenuButton(onTap: onOpenMenu),
                  ],
          ),
        ),
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand({required this.isScrolled, required this.onTap});

  final bool isScrolled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tf = context.tf;
    final colors = tf.colors;
    final l10n = context.l10n;
    final logoSize = isScrolled
        ? TfSizes.headerLogoSmall
        : TfSizes.headerLogoLarge;
    return Semantics(
      button: true,
      label: l10n.navHome,
      child: InkWell(
        onTap: onTap,
        borderRadius: TfRadius.pillAll,
        hoverColor: colors.glass,
        focusColor: colors.glass,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: tf.duration(TfMotion.base),
              curve: TfMotion.standard,
              width: logoSize,
              height: logoSize,
              child: TfLogo(size: logoSize, decorative: true, plate: true),
            ),
            TfGap.w12,
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!context.isMobile)
                    Text(
                      l10n.brandUniversity,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tf.text.caption.copyWith(
                        color: colors.onBrandMuted,
                      ),
                    ),
                  Text(
                    l10n.brandName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tf.text.title.copyWith(color: colors.onBrand),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tf = context.tf;
    final colors = tf.colors;
    return TextButton(
      onPressed: onTap,
      style: ButtonStyle(
        animationDuration: tf.duration(TfMotion.fast),
        padding: const WidgetStatePropertyAll(TfInsets.navLink),
        minimumSize: const WidgetStatePropertyAll(Size(0, TfSizes.tapTarget)),
        shape: const WidgetStatePropertyAll(StadiumBorder()),
        textStyle: WidgetStatePropertyAll(tf.text.label),
        overlayColor: WidgetStatePropertyAll(colors.glass),
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.hovered) ||
                  states.contains(WidgetState.focused)
              ? colors.onBrand
              : colors.onBrandMuted,
        ),
        side: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.focused)
              ? BorderSide(color: colors.onBrand, width: TfSizes.focusRing)
              : BorderSide.none,
        ),
      ),
      child: Text(label),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.tf.colors;
    final label = context.l10n.navOpenMenu;
    return Tooltip(
      message: label,
      child: Semantics(
        button: true,
        label: label,
        excludeSemantics: true,
        child: Material(
          color: colors.glass,
          shape: CircleBorder(side: BorderSide(color: colors.glassBorder)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: SizedBox.square(
              dimension: TfSizes.tapTarget,
              child: Center(
                child: TfIcon(TfIcons.menu, color: colors.onBrand),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
