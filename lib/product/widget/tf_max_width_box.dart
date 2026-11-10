import 'package:flutter/widgets.dart';
import 'package:gu_teknofest/product/extension/build_context_responsive_x.dart';
import 'package:gu_teknofest/product/theme/tf_sizes.dart';

/// İçeriği ortalar, en fazla içerik genişliğine sınırlar ve sayfa kenar
/// boşluğunu ekler. Her bölümün içeriği bununla sarılır.
class TfMaxWidthBox extends StatelessWidget {
  /// Kutu oluşturur.
  const TfMaxWidthBox({required this.child, super.key});

  /// İçerik.
  final Widget child;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: TfSizes.contentMaxWidth),
      // Kutu, içeriği dar olsa da tüm genişliği kaplar: her bölümün içeriği
      // üst barla aynı sol hizadan başlar.
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.pageGutter),
          child: child,
        ),
      ),
    ),
  );
}
