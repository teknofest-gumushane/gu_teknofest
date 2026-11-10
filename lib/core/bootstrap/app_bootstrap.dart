import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:gu_teknofest/core/di/project_dependency.dart';
import 'package:gu_teknofest/core/error/app_error_handler.dart';
import 'package:intl/date_symbol_data_local.dart';

/// Uygulamanın açılış sırası: hata kancaları → temiz adresler → tarih verisi →
/// bağımlılıklar → `runApp`.
abstract final class AppBootstrap {
  /// Türkçe tarih biçimleri için yerel ayar.
  static const String dateLocale = 'tr_TR';

  /// Uygulamayı başlatır.
  static Future<void> run({required Widget Function() appBuilder}) async {
    WidgetsFlutterBinding.ensureInitialized();
    AppErrorHandler.install();
    usePathUrlStrategy();
    await initializeDateFormatting(dateLocale);
    await ProjectDependency.setup();
    runApp(ProviderScope(child: appBuilder()));
  }
}
