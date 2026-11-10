import 'package:flutter_test/flutter_test.dart';
import 'package:gu_teknofest/core/env/app_environment.dart';

void main() {
  group('AppEnvironment.parse', () {
    test('boş değer sahte veridir (arayüz fazı varsayılanı)', () {
      expect(AppEnvironment.parse(''), AppEnv.mock);
    });

    test('tanımlı değerler ortamlarına eşlenir', () {
      expect(AppEnvironment.parse('mock'), AppEnv.mock);
      expect(AppEnvironment.parse('emulator'), AppEnv.emulator);
      expect(AppEnvironment.parse('prod'), AppEnv.production);
    });

    test('bilinmeyen değer ArgumentError fırlatır', () {
      expect(() => AppEnvironment.parse('staging'), throwsArgumentError);
      expect(() => AppEnvironment.parse('PROD'), throwsArgumentError);
    });

    test('backend fazına kadar hiçbir ortamın gerçek veri kaynağı yoktur', () {
      for (final env in AppEnv.values) {
        expect(AppEnvironment.hasBackend(env), isFalse);
      }
    });
  });
}
