import 'package:gu_teknofest/product/extension/build_context_x.dart';
import 'package:gu_teknofest/product/theme/tf_motion.dart';
import 'package:gu_teknofest/product/theme/tf_sizes.dart';
import 'package:gu_teknofest/product/theme/tf_spacing.dart';
import 'package:material_ui/material_ui.dart';

/// Hap biçimli ana buton: mavi zemin, üzerine gelince turuncu.
class TfButton extends StatelessWidget {
  /// Buton oluşturur. [onPressed] `null` ise devre dışıdır.
  const TfButton({
    required this.label,
    required this.onPressed,
    this.expand = false,
    super.key,
  });

  /// Buton metni.
  final String label;

  /// Basılınca çalışır.
  final VoidCallback? onPressed;

  /// Bulunduğu alanın tüm genişliğini kaplasın mı.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final tf = context.tf;
    final colors = tf.colors;
    final button = FilledButton(
      onPressed: onPressed,
      style: ButtonStyle(
        animationDuration: tf.duration(TfMotion.fast),
        padding: const WidgetStatePropertyAll(TfInsets.button),
        minimumSize: const WidgetStatePropertyAll(Size(0, TfSizes.tapTarget)),
        shape: const WidgetStatePropertyAll(StadiumBorder()),
        textStyle: WidgetStatePropertyAll(tf.text.label),
        foregroundColor: WidgetStatePropertyAll(colors.onBrand),
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.disabled)
              ? colors.textSubtle
              : states.contains(WidgetState.hovered) ||
                    states.contains(WidgetState.pressed)
              ? colors.accent
              : colors.primary,
        ),
        side: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.focused)
              ? BorderSide(color: colors.onBrand, width: TfSizes.focusRing)
              : BorderSide.none,
        ),
      ),
      child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
