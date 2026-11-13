import 'package:material_ui/material_ui.dart';

/// Bir ikonun kaynağı: Flutter'ın hazır ikonu ya da SVG dosyası (D-11).
@immutable
sealed class TfIconData {
  const TfIconData();
}

/// Flutter'da hazır [IconData]'sı olan ikon.
final class TfMaterialIconData extends TfIconData {
  /// Hazır ikonu sarar.
  const TfMaterialIconData(this.data);

  /// Flutter ikon verisi.
  final IconData data;
}

/// Hazır karşılığı olmayan, `assets/icons` altındaki SVG ikon.
final class TfSvgIconData extends TfIconData {
  /// SVG dosyasını sarar.
  const TfSvgIconData(this.asset);

  /// Dosya yolu.
  final String asset;
}

/// İkon kayıt defteri. Ekran kodu `Icons.*` kullanmaz; `TfIcon(TfIcons.menu)`
/// yazar. Yeni ikon: Flutter'da varsa [TfMaterialIconData], yoksa SVG'yi
/// `assets/icons`'a koyup [TfSvgIconData] ile ekle.
abstract final class TfIcons {
  static const TfIconData menu = TfMaterialIconData(Icons.menu_rounded);
  static const TfIconData close = TfMaterialIconData(Icons.close_rounded);
  static const TfIconData arrowForward = TfMaterialIconData(
    Icons.arrow_forward_rounded,
  );
  static const TfIconData arrowBack = TfMaterialIconData(
    Icons.arrow_back_rounded,
  );
  static const TfIconData search = TfMaterialIconData(Icons.search_rounded);
  static const TfIconData check = TfMaterialIconData(Icons.check_rounded);
  static const TfIconData comingSoon = TfMaterialIconData(
    Icons.hourglass_empty_rounded,
  );
  static const TfIconData error = TfMaterialIconData(
    Icons.error_outline_rounded,
  );
  static const TfIconData imagePlaceholder = TfMaterialIconData(
    Icons.image_outlined,
  );
}
