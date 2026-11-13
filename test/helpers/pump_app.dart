import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:gu_teknofest/core/bootstrap/tf_app.dart';
import 'package:gu_teknofest/core/di/project_dependency.dart';
import 'package:gu_teknofest/l10n/app_localizations.dart';
import 'package:gu_teknofest/product/theme/tf_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'tf_test_sizes.dart';

/// Türkçe metinler (testte beklenen metni ARB'den almak için).
Future<AppLocalizations> loadL10n() =>
    AppLocalizations.delegate.load(AppLocalizations.supportedLocales.first);

/// GetIt kayıtlarını `assets/mock` dosyalarıyla (gecikmesiz) kurar ve test
/// bitince sıfırlar. Veri okuyan ekran testlerinin `setUp`'ında çağrılır.
Future<void> setUpTestDependencies() async {
  await ProjectDependency.reset();
  await ProjectDependency.setup(
    mockAssetLoader: (name) => File('assets/mock/$name.json').readAsString(),
  );
  addTearDown(ProjectDependency.reset);
}

/// Widget'ı uygulamanın teması, dili ve `ProviderScope` ile çizen yardımcılar.
extension PumpApp on WidgetTester {
  /// Ekranı [size] ölçüsüne getirir (test bitince geri alınır).
  void setScreenSize(Size size) {
    view
      ..physicalSize = size
      ..devicePixelRatio = 1;
    addTearDown(view.reset);
  }

  /// [child]'ı tek başına çizer.
  Future<void> pumpApp(
    Widget child, {
    Size size = TfTestSizes.desktop,
  }) async {
    setScreenSize(size);
    await pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: TfTheme.light(),
          locale: AppLocalizations.supportedLocales.first,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: TfApp.localizationsDelegates,
          home: child,
        ),
      ),
    );
    await pumpAndSettle();
  }

  /// Uygulamayı [router] ile çizer (rota testleri).
  Future<void> pumpRouter(
    GoRouter router, {
    Size size = TfTestSizes.desktop,
  }) async {
    setScreenSize(size);
    await pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: router,
          theme: TfTheme.light(),
          locale: AppLocalizations.supportedLocales.first,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: TfApp.localizationsDelegates,
        ),
      ),
    );
    await pumpAndSettle();
  }
}
