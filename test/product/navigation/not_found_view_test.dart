import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gu_teknofest/features/landing/view/landing_view.dart';
import 'package:gu_teknofest/product/navigation/app_router.dart';
import 'package:gu_teknofest/product/navigation/not_found_view.dart';
import 'package:gu_teknofest/product/theme/tf_sizes.dart';
import 'package:gu_teknofest/product/widget/tf_button.dart';
import 'package:gu_teknofest/product/widget/tf_logo.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/tf_test_sizes.dart';

/// Yüksekliği içeriğe yetmeyen ekran (yatay tutulan telefon gibi).
const _shortScreen = Size(320, 240);

void main() {
  group('NotFoundView', () {
    for (final size in TfTestSizes.all) {
      testWidgets(
        'taşma yok ve içerik ekranın içinde: ${size.width.toInt()} px',
        (tester) async {
          final l10n = await loadL10n();
          final screen = Offset.zero & size;

          await tester.pumpApp(const NotFoundView(), size: size);

          expect(tester.takeException(), isNull);
          final parts = [
            find.byType(TfLogo),
            find.text(l10n.notFoundTitle),
            find.text(l10n.notFoundBody),
            find.widgetWithText(TfButton, l10n.notFoundBack),
          ];
          for (final part in parts) {
            expect(part, findsOneWidget);
            final rect = tester.getRect(part);
            expect(
              screen.contains(rect.topLeft) &&
                  screen.contains(rect.bottomRight - const Offset(1, 1)),
              isTrue,
              reason: '$part ekranın dışına taşıyor: $rect',
            );
          }
        },
      );
    }

    testWidgets('logo kendi ölçüsünde çizilir', (tester) async {
      await tester.pumpApp(const NotFoundView(), size: TfTestSizes.mobile);

      expect(
        tester.getSize(find.byType(TfLogo)),
        const Size.square(TfSizes.notFoundLogo),
      );
    });

    testWidgets('kısa ekranda taşmaz, buton kaydırılarak görünür olur', (
      tester,
    ) async {
      final l10n = await loadL10n();
      final button = find.widgetWithText(TfButton, l10n.notFoundBack);

      await tester.pumpApp(const NotFoundView(), size: _shortScreen);

      expect(tester.takeException(), isNull);
      expect(tester.getRect(button).bottom, greaterThan(_shortScreen.height));

      await tester.ensureVisible(button);
      await tester.pumpAndSettle();

      expect(
        tester.getRect(button).bottom,
        lessThanOrEqualTo(_shortScreen.height),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('başlık ekran okuyucuya başlık olarak bildirilir', (
      tester,
    ) async {
      final l10n = await loadL10n();
      final semantics = tester.ensureSemantics();

      await tester.pumpApp(const NotFoundView());

      expect(
        tester.getSemantics(find.text(l10n.notFoundTitle)),
        isSemantics(label: l10n.notFoundTitle, isHeader: true),
      );

      semantics.dispose();
    });

    testWidgets(
      'klavyeyle: Tab butona odaklanır, Enter genel sayfaya götürür',
      (
        tester,
      ) async {
        final router = AppRouter.create(initialLocation: '/olmayan-sayfa');
        addTearDown(router.dispose);
        await tester.pumpRouter(router);

        // Odak henüz butonda değil: Enter sayfayı değiştirmez.
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();
        expect(find.byType(NotFoundView), findsOneWidget);

        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();

        expect(find.byType(LandingView), findsOneWidget);
      },
    );
  });
}
