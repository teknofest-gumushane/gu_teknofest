import 'package:flutter_test/flutter_test.dart';
import 'package:gu_teknofest/product/mixin/external_link_mixin.dart';

void main() {
  group('ExternalLinks', () {
    test('yalnızca http(s) ve mailto açılabilir', () {
      expect(ExternalLinks.isAllowed(Uri.parse('https://example.com')), isTrue);
      expect(
        ExternalLinks.isAllowed(Uri.parse('mailto:a@example.com')),
        isTrue,
      );
      expect(
        ExternalLinks.isAllowed(Uri.parse('javascript:alert(1)')),
        isFalse,
      );
      expect(ExternalLinks.isAllowed(Uri.parse('file:///etc/passwd')), isFalse);
    });

    test('kimlik bilgisi taşıyan ve sunucusuz adres reddedilir', () {
      expect(
        ExternalLinks.isAllowed(Uri.parse('https://kullanici@example.com')),
        isFalse,
      );
      expect(ExternalLinks.isAllowed(Uri.parse('https:///yol')), isFalse);
    });

    test('web şemasız adrese https ekler; boş adres null', () {
      expect(
        ExternalLinks.web('example.com').toString(),
        'https://example.com',
      );
      expect(ExternalLinks.web('  '), isNull);
      expect(ExternalLinks.web('mailto:a@example.com'), isNull);
    });

    test('mail e-postadan mailto bağlantısı üretir', () {
      expect(
        ExternalLinks.mail(' a@example.com ').toString(),
        'mailto:a@example.com',
      );
      expect(ExternalLinks.mail(''), isNull);
    });
  });
}
