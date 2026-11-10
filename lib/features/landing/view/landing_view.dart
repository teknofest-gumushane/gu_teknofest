import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gu_teknofest/features/landing/view/landing_section_id.dart';
import 'package:gu_teknofest/features/landing/view/mixin/landing_view_mixin.dart';
import 'package:gu_teknofest/features/landing/view/section/about_section.dart';
import 'package:gu_teknofest/features/landing/view/section/events_section.dart';
import 'package:gu_teknofest/features/landing/view/section/gallery_section.dart';
import 'package:gu_teknofest/features/landing/view/section/hero_section.dart';
import 'package:gu_teknofest/features/landing/view/section/projects_section.dart';
import 'package:gu_teknofest/features/landing/view/section/socials_section.dart';
import 'package:gu_teknofest/features/landing/view/section/team_section.dart';
import 'package:gu_teknofest/features/landing/view/widget/landing_drawer.dart';
import 'package:gu_teknofest/features/landing/view/widget/landing_footer.dart';
import 'package:gu_teknofest/features/landing/view/widget/landing_header.dart';
import 'package:gu_teknofest/product/extension/build_context_responsive_x.dart';

/// Genel sayfa: yapışkan üst bar, alt alta bölümler ve alt bilgi. Tek
/// sayfadır; menü ilgili bölüme kaydırır.
class LandingView extends ConsumerStatefulWidget {
  /// Genel sayfayı oluşturur.
  const LandingView({super.key});

  @override
  ConsumerState<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends ConsumerState<LandingView>
    with LandingViewMixin {
  @override
  Widget build(BuildContext context) => Scaffold(
    key: scaffoldKey,
    endDrawer: context.isDesktop
        ? null
        : LandingDrawer(
            onSectionSelected: onSectionSelected,
            onJoin: onJoinPressed,
          ),
    body: Column(
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: isScrolled,
          builder: (context, scrolled, _) => LandingHeader(
            isScrolled: scrolled,
            onLogoTap: () => scrollToSection(LandingSectionId.hero),
            onSectionSelected: onSectionSelected,
            onJoin: onJoinPressed,
            onOpenMenu: openMenu,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HeroSection(key: sectionKeys[LandingSectionId.hero]),
                AboutSection(key: sectionKeys[LandingSectionId.about]),
                ProjectsSection(key: sectionKeys[LandingSectionId.projects]),
                EventsSection(key: sectionKeys[LandingSectionId.events]),
                GallerySection(key: sectionKeys[LandingSectionId.gallery]),
                TeamSection(key: sectionKeys[LandingSectionId.team]),
                SocialsSection(key: sectionKeys[LandingSectionId.socials]),
                const LandingFooter(),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
