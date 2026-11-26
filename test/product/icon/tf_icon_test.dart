import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gu_teknofest/product/icon/tf_icon.dart';
import 'package:gu_teknofest/product/icon/tf_icons.dart';
import 'package:gu_teknofest/product/theme/tf_colors.dart';
import 'package:gu_teknofest/product/theme/tf_sizes.dart';

import '../../helpers/pump_app.dart';

/// SVG ikon dosyalarının yerine geçen paket: istenen her yol için aynı küçük
/// SVG'yi döner. Depoda henüz SVG ikon yok; `TfIcon`'un SVG dalı bununla
/// denenir.
class _FakeSvgBundle extends CachingAssetBundle {
  static const _svg =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"> '
      '<path d="M4 4h16v16H4z"/></svg>';

  /// İstenen yollar (hangi dosyanın yüklendiğini doğrulamak için).
  final List<String> requested = [];

  @override
  Future<ByteData> load(String key) async {
    requested.add(key);
    return ByteData.sublistView(utf8.encode(_svg));
  }
}

const _svgIcon = TfSvgIconData('assets/icons/ornek.svg');

void main() {
  group('TfIcon, hazır ikon', () {
    testWidgets('kayıtlı ikonu varsayılan ölçüde çizer', (tester) async {
      await tester.pumpApp(const Center(child: TfIcon(TfIcons.menu)));

      final icon = tester.widget<Icon>(find.byType(Icon));

      expect(icon.icon, (TfIcons.menu as TfMaterialIconData).data);
      expect(
        tester.getSize(find.byType(TfIcon)),
        const Size.square(TfSizes.iconMd),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('verilen ölçüyü ve rengi kullanır', (tester) async {
      final accent = TfColors.light.accent;

      await tester.pumpApp(
        Center(
          child: TfIcon(TfIcons.close, size: TfSizes.iconXl, color: accent),
        ),
      );

      expect(tester.widget<Icon>(find.byType(Icon)).color, accent);
      expect(
        tester.getSize(find.byType(TfIcon)),
        const Size.square(TfSizes.iconXl),
      );
    });

    testWidgets('renk verilmezse çevredeki ikon temasının rengini alır', (
      tester,
    ) async {
      final deep = TfColors.light.deep;

      await tester.pumpApp(
        Center(
          child: IconTheme(
            data: IconThemeData(color: deep),
            child: const TfIcon(TfIcons.search),
          ),
        ),
      );

      expect(tester.widget<Icon>(find.byType(Icon)).color, deep);
    });

    testWidgets(
      'etiket verilirse ekran okuyucuya bildirilir, verilmezse süs sayılır',
      (tester) async {
        final l10n = await loadL10n();
        final semantics = tester.ensureSemantics();

        await tester.pumpApp(
          Center(
            child: TfIcon(TfIcons.menu, semanticLabel: l10n.navOpenMenu),
          ),
        );
        expect(find.bySemanticsLabel(l10n.navOpenMenu), findsOneWidget);

        await tester.pumpApp(const Center(child: TfIcon(TfIcons.menu)));
        expect(find.bySemanticsLabel(l10n.navOpenMenu), findsNothing);

        semantics.dispose();
      },
    );
  });

  group('TfIcon, SVG ikon', () {
    late _FakeSvgBundle bundle;

    setUp(() => bundle = _FakeSvgBundle());

    Widget withBundle(Widget child) => DefaultAssetBundle(
      bundle: bundle,
      child: Center(child: child),
    );

    testWidgets('kayıtlı dosyayı verilen ölçüde çizer', (tester) async {
      await tester.pumpApp(
        withBundle(const TfIcon(_svgIcon, size: TfSizes.iconLg)),
      );

      final picture = tester.widget<SvgPicture>(find.byType(SvgPicture));

      expect(bundle.requested, contains(_svgIcon.asset));
      expect(picture.width, TfSizes.iconLg);
      expect(picture.height, TfSizes.iconLg);
      expect(
        tester.getSize(find.byType(TfIcon)),
        const Size.square(TfSizes.iconLg),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('verilen renkle tek renge boyar', (tester) async {
      final accent = TfColors.light.accent;

      await tester.pumpApp(withBundle(TfIcon(_svgIcon, color: accent)));

      expect(
        tester.widget<SvgPicture>(find.byType(SvgPicture)).colorFilter,
        ColorFilter.mode(accent, BlendMode.srcIn),
      );
    });

    testWidgets('renk verilmezse çevredeki ikon temasının rengiyle boyar', (
      tester,
    ) async {
      final deep = TfColors.light.deep;

      await tester.pumpApp(
        withBundle(
          IconTheme(
            data: IconThemeData(color: deep),
            child: const TfIcon(_svgIcon),
          ),
        ),
      );

      expect(
        tester.widget<SvgPicture>(find.byType(SvgPicture)).colorFilter,
        ColorFilter.mode(deep, BlendMode.srcIn),
      );
    });

    testWidgets(
      'etiket verilirse ekran okuyucuya bildirilir, verilmezse gizlenir',
      (tester) async {
        final l10n = await loadL10n();
        final semantics = tester.ensureSemantics();

        await tester.pumpApp(
          withBundle(TfIcon(_svgIcon, semanticLabel: l10n.navOpenMenu)),
        );
        expect(find.bySemanticsLabel(l10n.navOpenMenu), findsOneWidget);

        await tester.pumpApp(withBundle(const TfIcon(_svgIcon)));
        expect(find.bySemanticsLabel(l10n.navOpenMenu), findsNothing);
        expect(
          tester
              .widget<SvgPicture>(find.byType(SvgPicture))
              .excludeFromSemantics,
          isTrue,
        );

        semantics.dispose();
      },
    );
  });
}
