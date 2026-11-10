import 'package:flutter_test/flutter_test.dart';
import 'package:gu_teknofest/core/error/app_logger.dart';

void main() {
  group('AppLogger', () {
    test('format: düzey etiketi, mesaj ve varsa hata', () {
      expect(AppLogger.format(AppLogLevel.warn, 'mesaj'), '[W] mesaj');
      expect(
        AppLogger.format(AppLogLevel.error, 'mesaj', error: 'neden'),
        '[E] mesaj | neden',
      );
    });

    test('geliştirmede her düzey yazılır', () {
      final lines = <String>[];

      for (final level in AppLogLevel.values) {
        AppLogger.write(level, 'x', sink: lines.add);
      }

      expect(lines, hasLength(AppLogLevel.values.length));
    });

    test('yayında yalnızca uyarı ve hata yazılır', () {
      final lines = <String>[];

      for (final level in AppLogLevel.values) {
        AppLogger.write(level, 'x', release: true, sink: lines.add);
      }

      expect(lines, ['[W] x', '[E] x']);
    });

    test('yazıcı hata fırlatsa da çağıran düşmez', () {
      expect(
        () => AppLogger.write(
          AppLogLevel.error,
          'x',
          sink: (_) => throw StateError('yazılamadı'),
        ),
        returnsNormally,
      );
    });
  });
}
