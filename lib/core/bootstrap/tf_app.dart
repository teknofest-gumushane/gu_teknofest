import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gu_teknofest/l10n/app_localizations.dart';
import 'package:gu_teknofest/product/extension/build_context_l10n_x.dart';
import 'package:gu_teknofest/product/navigation/app_router.dart';
import 'package:gu_teknofest/product/theme/tf_theme.dart';
import 'package:material_ui/material_ui.dart';

/// Kök widget: tema, dil ve yönlendirmeyi bağlar.
class TfApp extends ConsumerStatefulWidget {
  /// Kök widget'ı oluşturur.
  const TfApp({super.key});

  /// Uygulamanın yerelleştirme delegeleri: kendi metinlerimiz ile Material,
  /// Cupertino ve temel widget metinleri.
  ///
  /// `AppLocalizations.localizationsDelegates` kullanılmaz: `flutter gen-l10n`
  /// o listeye `flutter_localizations`'ın delegelerini koyar; `material_ui`'ın
  /// `MaterialApp`'i ise kendi delegelerini arar (D-32).
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    AppLocalizations.delegate,
    ...GlobalMaterialLocalizations.delegates,
  ];

  @override
  ConsumerState<TfApp> createState() => _TfAppState();
}

class _TfAppState extends ConsumerState<TfApp> {
  late final GoRouter _router = AppRouter.create();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    routerConfig: _router,
    debugShowCheckedModeBanner: false,
    onGenerateTitle: (context) => context.l10n.appTitle,
    theme: TfTheme.light(),
    locale: AppLocalizations.supportedLocales.first,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: TfApp.localizationsDelegates,
  );
}
