import 'package:flutter/foundation.dart';

/// Günlük düzeyi.
enum AppLogLevel {
  /// Ayrıntı (yalnızca geliştirmede).
  debug('D'),

  /// Bilgi (yalnızca geliştirmede).
  info('I'),

  /// Uyarı.
  warn('W'),

  /// Hata.
  error('E');

  const AppLogLevel(this.tag);

  /// Satır başındaki tek harfli etiket.
  final String tag;
}

/// Uygulamanın tek günlük kapısı. `print` / `debugPrint` yalnızca burada
/// çağrılır (`tool/check_hardcode.sh` HC11).
abstract final class AppLogger {
  /// Ayrıntı satırı.
  static void debug(String message, {Object? error, StackTrace? stackTrace}) =>
      write(AppLogLevel.debug, message, error: error, stackTrace: stackTrace);

  /// Bilgi satırı.
  static void info(String message, {Object? error, StackTrace? stackTrace}) =>
      write(AppLogLevel.info, message, error: error, stackTrace: stackTrace);

  /// Uyarı satırı.
  static void warn(String message, {Object? error, StackTrace? stackTrace}) =>
      write(AppLogLevel.warn, message, error: error, stackTrace: stackTrace);

  /// Hata satırı.
  static void error(String message, {Object? error, StackTrace? stackTrace}) =>
      write(AppLogLevel.error, message, error: error, stackTrace: stackTrace);

  /// Satırı yazar. Yayın derlemesinde yalnızca uyarı ve hatalar konsola
  /// düşer.
  @visibleForTesting
  static void write(
    AppLogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    bool release = kReleaseMode,
    void Function(String line)? sink,
  }) {
    try {
      if (release &&
          (level == AppLogLevel.debug || level == AppLogLevel.info)) {
        return;
      }
      final line = format(level, message, error: error);
      (sink ?? debugPrint)(stackTrace == null ? line : '$line\n$stackTrace');
    } on Object catch (_) {
      // Günlük yazımı hiçbir zaman çağıranı düşürmez.
    }
  }

  /// Satır biçimi: `[E] mesaj | hata`.
  @visibleForTesting
  static String format(AppLogLevel level, String message, {Object? error}) =>
      error == null
      ? '[${level.tag}] $message'
      : '[${level.tag}] $message | $error';
}
