import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gu_teknofest/product/widget/tf_button.dart';
import 'package:gu_teknofest/product/widget/tf_coming_soon.dart';
import 'package:gu_teknofest/product/widget/tf_section_frame.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/tf_test_sizes.dart';

void main() {
  group('TfSectionFrame', () {
    testWidgets(
      'üst etiketi Türkçe büyük harfe çevirir, başlık ve içeriği çizer',
      (
        tester,
      ) async {
        await tester.pumpApp(
          const SingleChildScrollView(
            child: TfSectionFrame(
              eyebrow: 'Hakkımızda',
              title: 'Kulübümüz',
              subtitle: 'Kısa açıklama',
              child: Text('içerik'),
            ),
          ),
        );

        expect(find.text('HAKKIMIZDA'), findsOneWidget);
        expect(find.text('Kulübümüz'), findsOneWidget);
        expect(find.text('Kısa açıklama'), findsOneWidget);
        expect(find.text('içerik'), findsOneWidget);
      },
    );

    testWidgets('başlık ekran okuyucuya başlık olarak bildirilir', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpApp(
        const SingleChildScrollView(
          child: TfSectionFrame(
            eyebrow: 'Etiket',
            title: 'Bölüm başlığı',
            child: SizedBox.shrink(),
          ),
        ),
      );

      expect(
        tester.getSemantics(find.text('Bölüm başlığı')),
        matchesSemantics(label: 'Bölüm başlığı', isHeader: true),
      );
      handle.dispose();
    });

    testWidgets('dört genişlikte de taşmaz', (tester) async {
      for (final size in TfTestSizes.all) {
        await tester.pumpApp(
          const SingleChildScrollView(
            child: TfSectionFrame(
              eyebrow: 'Çok uzun bir üst etiket metni',
              title:
                  'Dar ekranda birkaç satıra bölünmesi gereken uzun bir başlık',
              subtitle: 'Yine uzun, birkaç satıra yayılan bir açıklama metni.',
              child: TfComingSoon(),
            ),
          ),
          size: size,
        );

        expect(tester.takeException(), isNull, reason: '$size');
      }
    });
  });

  group('TfComingSoon', () {
    testWidgets('"yakında" başlığını ve açıklamasını gösterir', (tester) async {
      final l10n = await loadL10n();
      await tester.pumpApp(const Center(child: TfComingSoon()));

      expect(find.text(l10n.comingSoonTitle), findsOneWidget);
      expect(find.text(l10n.comingSoonBody), findsOneWidget);
    });
  });

  group('TfButton', () {
    testWidgets('basılınca geri çağrıyı çalıştırır', (tester) async {
      var taps = 0;
      await tester.pumpApp(
        Center(
          child: TfButton(label: 'Gönder', onPressed: () => taps++),
        ),
      );

      await tester.tap(find.text('Gönder'));

      expect(taps, 1);
    });

    testWidgets('onPressed yoksa devre dışıdır', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpApp(
        const Center(child: TfButton(label: 'Gönder', onPressed: null)),
      );

      expect(
        tester.getSemantics(find.byType(TfButton)),
        matchesSemantics(
          label: 'Gönder',
          isButton: true,
          hasEnabledState: true,
        ),
      );
      handle.dispose();
    });
  });
}
