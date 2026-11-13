import 'package:flutter_test/flutter_test.dart';
import 'package:gu_teknofest/features/landing/view/landing_section_id.dart';
import 'package:gu_teknofest/features/landing/view/landing_view.dart';
import 'package:gu_teknofest/features/landing/view/section/hero_section.dart';
import 'package:gu_teknofest/features/landing/view/widget/landing_drawer.dart';
import 'package:gu_teknofest/features/landing/view/widget/landing_header.dart';
import 'package:gu_teknofest/l10n/app_localizations.dart';
import 'package:gu_teknofest/product/widget/tf_coming_soon.dart';
import 'package:gu_teknofest/product/widget/tf_logo.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/tf_test_sizes.dart';

void main() {
  late AppLocalizations l10n;

  setUpAll(() async => l10n = await loadL10n());

  double scrollOffset(WidgetTester tester) => tester
      .widget<SingleChildScrollView>(find.byType(SingleChildScrollView))
      .controller!
      .offset;

  group('LandingView · masaüstü', () {
    testWidgets('üst barda altı bölüm linki ve Takıma Katıl butonu var', (
      tester,
    ) async {
      await tester.pumpApp(const LandingView());

      final header = find.byType(LandingHeader);
      for (final id in LandingSectionId.menu) {
        expect(
          find.descendant(of: header, matching: find.text(id.label(l10n))),
          findsOneWidget,
          reason: id.name,
        );
      }
      expect(
        find.descendant(of: header, matching: find.text(l10n.navJoin)),
        findsOneWidget,
      );
      expect(find.byTooltip(l10n.navOpenMenu), findsNothing);
    });

    testWidgets('yedi bölümün hepsi "yakında" yer tutucusu gösterir', (
      tester,
    ) async {
      await tester.pumpApp(const LandingView());

      expect(
        find.byType(TfComingSoon, skipOffstage: false),
        findsNWidgets(LandingSectionId.values.length),
      );
    });

    testWidgets('bölüm içerikleri üst barla aynı sol hizadan başlar', (
      tester,
    ) async {
      await tester.pumpApp(const LandingView(), size: TfTestSizes.wide);

      final headerLeft = tester.getTopLeft(find.byType(TfLogo).first).dx;

      final heroTitle = find.descendant(
        of: find.byType(HeroSection),
        matching: find.text(l10n.heroTitle),
      );

      expect(tester.getTopLeft(heroTitle).dx, headerLeft);
      expect(tester.getTopLeft(find.text(l10n.aboutTitle)).dx, headerLeft);
    });

    testWidgets('bölüm linkine basınca sayfa o bölüme kayar', (tester) async {
      await tester.pumpApp(const LandingView());

      expect(scrollOffset(tester), 0);

      await tester.tap(find.text(l10n.navEvents));
      await tester.pumpAndSettle();

      expect(scrollOffset(tester), greaterThan(0));
      expect(find.text(l10n.eventsTitle).hitTestable(), findsOneWidget);
    });

    testWidgets('logoya basınca sayfanın başına döner', (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpApp(const LandingView());
      await tester.tap(find.text(l10n.navTeam));
      await tester.pumpAndSettle();

      // Etiket, görünür marka adıyla birleşir; bu yüzden içerme aranır.
      await tester.tap(
        find.bySemanticsLabel(RegExp(RegExp.escape(l10n.navHome))),
      );
      await tester.pumpAndSettle();

      expect(scrollOffset(tester), 0);
      semantics.dispose();
    });

    testWidgets('sayfa kaydırılınca üst bar küçülür', (tester) async {
      await tester.pumpApp(const LandingView());

      expect(
        tester.widget<LandingHeader>(find.byType(LandingHeader)).isScrolled,
        isFalse,
      );

      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -300),
      );
      await tester.pumpAndSettle();

      expect(
        tester.widget<LandingHeader>(find.byType(LandingHeader)).isScrolled,
        isTrue,
      );
    });

    testWidgets('Takıma Katıl "yakında" bildirimi gösterir', (tester) async {
      await tester.pumpApp(const LandingView());

      await tester.tap(find.text(l10n.navJoin));
      await tester.pump();

      expect(find.text(l10n.joinComingSoon), findsOneWidget);
    });
  });

  group('LandingView · dar ekran', () {
    for (final size in [TfTestSizes.mobile, TfTestSizes.tablet]) {
      testWidgets('$size: linkler yerine menü butonu var', (tester) async {
        await tester.pumpApp(const LandingView(), size: size);

        final header = find.byType(LandingHeader);
        expect(find.byTooltip(l10n.navOpenMenu), findsOneWidget);
        expect(
          find.descendant(of: header, matching: find.text(l10n.navProjects)),
          findsNothing,
        );
      });
    }

    testWidgets('menü butonu çekmeceyi açar; altı link ve buton listelenir', (
      tester,
    ) async {
      await tester.pumpApp(const LandingView(), size: TfTestSizes.mobile);

      await tester.tap(find.byTooltip(l10n.navOpenMenu));
      await tester.pumpAndSettle();

      final drawer = find.byType(LandingDrawer);
      expect(drawer, findsOneWidget);
      for (final id in LandingSectionId.menu) {
        expect(
          find.descendant(of: drawer, matching: find.text(id.label(l10n))),
          findsOneWidget,
          reason: id.name,
        );
      }
      expect(
        find.descendant(of: drawer, matching: find.text(l10n.navJoin)),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('çekmeceden bölüm seçilince çekmece kapanır ve sayfa kayar', (
      tester,
    ) async {
      await tester.pumpApp(const LandingView(), size: TfTestSizes.mobile);
      await tester.tap(find.byTooltip(l10n.navOpenMenu));
      await tester.pumpAndSettle();

      await tester.tap(find.text(l10n.navGallery));
      await tester.pumpAndSettle();

      expect(find.byType(LandingDrawer), findsNothing);
      expect(scrollOffset(tester), greaterThan(0));
    });

    testWidgets('kapat butonu çekmeceyi kapatır', (tester) async {
      await tester.pumpApp(const LandingView(), size: TfTestSizes.mobile);
      await tester.tap(find.byTooltip(l10n.navOpenMenu));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip(l10n.navCloseMenu));
      await tester.pumpAndSettle();

      expect(find.byType(LandingDrawer), findsNothing);
    });

    testWidgets(
      'çekmecedeki Takıma Katıl çekmeceyi kapatıp bildirim gösterir',
      (
        tester,
      ) async {
        await tester.pumpApp(const LandingView(), size: TfTestSizes.mobile);
        await tester.tap(find.byTooltip(l10n.navOpenMenu));
        await tester.pumpAndSettle();

        await tester.tap(find.text(l10n.navJoin));
        await tester.pumpAndSettle();

        expect(find.byType(LandingDrawer), findsNothing);
        expect(find.text(l10n.joinComingSoon), findsOneWidget);
      },
    );
  });

  group('LandingView · taşma', () {
    for (final size in TfTestSizes.all) {
      testWidgets('$size genişliğinde taşma yok', (tester) async {
        await tester.pumpApp(const LandingView(), size: size);

        expect(tester.takeException(), isNull);

        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, -5000),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(
          find.text(l10n.footerCopyright('${DateTime.now().year}')),
          findsOneWidget,
        );
      });
    }
  });
}
