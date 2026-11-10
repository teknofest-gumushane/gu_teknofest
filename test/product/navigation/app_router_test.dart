import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gu_teknofest/core/bootstrap/tf_app.dart';
import 'package:gu_teknofest/features/landing/view/landing_view.dart';
import 'package:gu_teknofest/product/navigation/app_router.dart';
import 'package:gu_teknofest/product/navigation/not_found_view.dart';
import 'package:gu_teknofest/product/navigation/routes/app_routes.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/tf_test_sizes.dart';

void main() {
  testWidgets('kök adres genel sayfayı açar', (tester) async {
    final router = AppRouter.create();
    addTearDown(router.dispose);

    await tester.pumpRouter(router);

    expect(find.byType(LandingView), findsOneWidget);
    expect(const LandingRoute().location, AppPaths.landing);
  });

  testWidgets('bilinmeyen adres bulunamadı sayfasını açar', (tester) async {
    final l10n = await loadL10n();
    final router = AppRouter.create(initialLocation: '/olmayan-sayfa');
    addTearDown(router.dispose);

    await tester.pumpRouter(router);

    expect(find.byType(NotFoundView), findsOneWidget);
    expect(find.text(l10n.notFoundTitle), findsOneWidget);
  });

  testWidgets('bulunamadı sayfasındaki buton genel sayfaya götürür', (
    tester,
  ) async {
    final l10n = await loadL10n();
    final router = AppRouter.create(initialLocation: '/olmayan-sayfa');
    addTearDown(router.dispose);
    await tester.pumpRouter(router);

    await tester.tap(find.text(l10n.notFoundBack));
    await tester.pumpAndSettle();

    expect(find.byType(LandingView), findsOneWidget);
  });

  testWidgets('TfApp kök adreste genel sayfayla açılır', (tester) async {
    tester.setScreenSize(TfTestSizes.wide);

    await tester.pumpWidget(const ProviderScope(child: TfApp()));
    await tester.pumpAndSettle();

    expect(find.byType(LandingView), findsOneWidget);
  });
}
