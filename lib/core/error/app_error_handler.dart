import 'package:flutter/foundation.dart';
import 'package:gu_teknofest/core/error/app_logger.dart';

/// Yakalanmamış hataların tek toplanma noktası: hepsi [AppLogger]'a düşer.
abstract final class AppErrorHandler {
  /// Flutter ve platform hata kancalarını bağlar.
  static void install() {
    FlutterError.onError = onFlutterError;
    PlatformDispatcher.instance.onError = onPlatformError;
  }

  /// Çerçeve içi hata (derleme, yerleşim, çizim).
  static void onFlutterError(FlutterErrorDetails details) {
    if (kDebugMode && !details.silent) {
      FlutterError.dumpErrorToConsole(details);
      return;
    }
    AppLogger.error(
      'Flutter hatası: ${details.context?.toDescription() ?? '-'}',
      error: details.exception,
      stackTrace: details.stack,
    );
  }

  /// Çerçeve dışı, yakalanmamış asenkron hata.
  static bool onPlatformError(Object error, StackTrace stack) {
    AppLogger.error('Yakalanmamış hata', error: error, stackTrace: stack);
    return true;
  }

  /// `runZonedGuarded` bölgesine düşen hata.
  static void onZoneError(Object error, StackTrace stack) {
    AppLogger.error('Bölge hatası', error: error, stackTrace: stack);
  }
}
