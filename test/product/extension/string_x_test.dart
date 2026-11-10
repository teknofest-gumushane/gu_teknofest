import 'package:flutter_test/flutter_test.dart';
import 'package:gu_teknofest/product/extension/string_x.dart';

void main() {
  group('TurkishCaseX', () {
    test('trUpper noktalı ve noktasız i harflerini ayırır', () {
      expect('istanbul'.trUpper(), 'İSTANBUL');
      expect('ığdır'.trUpper(), 'IĞDIR');
      expect('hakkımızda'.trUpper(), 'HAKKIMIZDA');
    });

    test('trLower noktalı ve noktasız I harflerini ayırır', () {
      expect('ISPARTA'.trLower(), 'ısparta');
      expect('İSTANBUL'.trLower(), 'istanbul');
    });

    test('trCompareTo Türkçe alfabe sırasını izler', () {
      final names = ['Zeynep', 'Ömer', 'Ilgaz', 'Çağla', 'Can']
        ..sort((a, b) => a.trCompareTo(b));

      expect(names, ['Can', 'Çağla', 'Ilgaz', 'Ömer', 'Zeynep']);
    });

    test('initials ilk ve son parçanın baş harfini verir', () {
      expect('Ayşe Demir'.initials, 'AD');
      expect('ilker'.initials, 'İ');
      expect('Ali Veli Kaya'.initials, 'AK');
      expect('   '.initials, '?');
    });
  });
}
