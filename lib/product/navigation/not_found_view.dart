import 'package:flutter/material.dart';
import 'package:gu_teknofest/product/extension/build_context_l10n_x.dart';
import 'package:gu_teknofest/product/extension/build_context_x.dart';
import 'package:gu_teknofest/product/navigation/routes/app_routes.dart';
import 'package:gu_teknofest/product/theme/tf_sizes.dart';
import 'package:gu_teknofest/product/theme/tf_spacing.dart';
import 'package:gu_teknofest/product/widget/tf_button.dart';
import 'package:gu_teknofest/product/widget/tf_logo.dart';
import 'package:gu_teknofest/product/widget/tf_max_width_box.dart';

/// Bilinmeyen adreslerde gösterilen sayfa.
class NotFoundView extends StatelessWidget {
  /// Sayfayı oluşturur.
  const NotFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    final tf = context.tf;
    final l10n = context.l10n;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: TfInsets.all24,
          child: TfMaxWidthBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const TfLogo(size: TfSizes.notFoundLogo),
                TfGap.h24,
                Semantics(
                  header: true,
                  child: Text(
                    l10n.notFoundTitle,
                    textAlign: TextAlign.center,
                    style: tf.text.headline.copyWith(color: tf.colors.deep),
                  ),
                ),
                TfGap.h8,
                Text(
                  l10n.notFoundBody,
                  textAlign: TextAlign.center,
                  style: tf.text.body.copyWith(color: tf.colors.textMuted),
                ),
                TfGap.h24,
                TfButton(
                  label: l10n.notFoundBack,
                  onPressed: () => const LandingRoute().go(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
