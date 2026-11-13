import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gu_teknofest/core/bootstrap/tf_app.dart';
import 'package:gu_teknofest/features/landing/view/landing_view.dart';
import 'package:gu_teknofest/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/tf_test_sizes.dart';

void main() {
  const turkish = Locale('tr');

  group('TfApp.localizationsDelegates', () {
    test('kendi metinlerimizin delegesini içerir', () {
      expect(TfApp.localizationsDelegates, contains(AppLocalizations.delegate));
    });

    test('her delege Türkçeyi destekler', () {
      for (final delegate in TfApp.localizationsDelegates) {
        expect(
          delegate.isSupported(turkish),
          isTrue,
          reason: '${delegate.type}',
        );
      }
    });
  });

  testWidgets('TfApp Türkçe açılır; Material metinleri de Türkçedir', (
    tester,
  ) async {
    tester.setScreenSize(TfTestSizes.wide);

    await tester.pumpWidget(const ProviderScope(child: TfApp()));
    await tester.pumpAndSettle();

    // Eksik delege, çerçevenin "locale is not supported" uyarısıyla görünür.
    expect(tester.takeException(), isNull);

    final context = tester.element(find.byType(LandingView));
    expect(Localizations.localeOf(context), turkish);
    expect(MaterialLocalizations.of(context).okButtonLabel, 'Tamam');
    expect(AppLocalizations.of(context), isNotNull);
  });
}
