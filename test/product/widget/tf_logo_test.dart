import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gu_teknofest/core/constants/app_constants.dart';
import 'package:gu_teknofest/product/theme/tf_sizes.dart';
import 'package:gu_teknofest/product/widget/tf_logo.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('logo dosyasını verilen ölçüde çizer', (tester) async {
    await tester.pumpApp(const Center(child: TfLogo(size: 96)));

    final image = tester.widget<Image>(find.byType(Image));

    expect((image.image as AssetImage).assetName, AppAssets.logo);
    expect(tester.getSize(find.byType(Image)), const Size(96, 96));
    expect(tester.takeException(), isNull);
  });

  testWidgets('daire zeminli logoda görsel daireye sığacak kadar küçülür', (
    tester,
  ) async {
    await tester.pumpApp(const Center(child: TfLogo(size: 100, plate: true)));

    expect(tester.getSize(find.byType(TfLogo)), const Size(100, 100));
    expect(
      tester.getSize(find.byType(Image)).width,
      closeTo(100 * TfSizes.logoPlateContentFactor, 0.001),
    );
  });

  testWidgets(
    'süs logosu ekran okuyucuya bildirilmez, tek başına olan bildirilir',
    (
      tester,
    ) async {
      final l10n = await loadL10n();
      final semantics = tester.ensureSemantics();

      await tester.pumpApp(const Center(child: TfLogo(size: 96)));
      expect(find.bySemanticsLabel(l10n.logoSemantics), findsOneWidget);

      await tester.pumpApp(
        const Center(child: TfLogo(size: 96, decorative: true)),
      );
      expect(find.bySemanticsLabel(l10n.logoSemantics), findsNothing);

      semantics.dispose();
    },
  );
}
