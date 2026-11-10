import 'package:flutter_test/flutter_test.dart';
import 'package:gu_teknofest/product/theme/tf_breakpoints.dart';
import 'package:gu_teknofest/product/theme/tf_typography.dart';

void main() {
  group('TfBreakpoints.classOf', () {
    test('sınır değerleri bir üst sınıfa aittir', () {
      expect(TfBreakpoints.classOf(0), TfDeviceClass.mobile);
      expect(TfBreakpoints.classOf(639), TfDeviceClass.mobile);
      expect(TfBreakpoints.classOf(640), TfDeviceClass.tablet);
      expect(TfBreakpoints.classOf(1023), TfDeviceClass.tablet);
      expect(TfBreakpoints.classOf(1024), TfDeviceClass.desktop);
      expect(TfBreakpoints.classOf(1920), TfDeviceClass.desktop);
    });
  });

  group('TfTypography.forWidth', () {
    test('ana başlık dar ekranda küçülür', () {
      final mobile = TfTypography.forWidth(320).display.fontSize!;
      final tablet = TfTypography.forWidth(768).display.fontSize!;
      final desktop = TfTypography.forWidth(1440).display.fontSize!;

      expect(mobile, lessThan(tablet));
      expect(tablet, lessThan(desktop));
    });

    test('her stil gömülü yazı tipini kullanır', () {
      final text = TfTypography.forWidth(1024);

      for (final style in [
        text.display,
        text.headline,
        text.title,
        text.bodyLarge,
        text.body,
        text.bodySmall,
        text.label,
        text.eyebrow,
        text.caption,
      ]) {
        expect(style.fontFamily, TfTypography.fontFamily);
      }
    });
  });
}
