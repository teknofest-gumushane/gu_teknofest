// Uyarlama: gu_kulupler external_link_mixin.dart (MIT, aynı yazar). Onay penceresi ve Instagram
// yardımcısı alınmadı; bağlantı doğrudan açılır.
import 'package:gu_teknofest/core/error/app_logger.dart';
import 'package:url_launcher/url_launcher.dart';

/// Dış bağlantı kuralları ve üreticileri.
abstract final class ExternalLinks {
  /// Açılmasına izin verilen şemalar.
  static const Set<String> allowedSchemes = {_https, _http, _mailto};

  /// [uri] açılabilir mi: yalnızca http(s) ve mailto; kimlik bilgisi taşıyan
  /// adres reddedilir.
  static bool isAllowed(Uri uri) => switch (uri.scheme) {
    _mailto => true,
    _https || _http => uri.host.isNotEmpty && uri.userInfo.isEmpty,
    _ => false,
  };

  /// E-posta adresinden `mailto:` bağlantısı; adres boşsa `null`.
  static Uri? mail(String email) {
    final address = email.trim();
    return address.isEmpty ? null : Uri(scheme: _mailto, path: address);
  }

  /// Web adresinden bağlantı; şema yoksa https eklenir. Geçersizse `null`.
  static Uri? web(String address) {
    final trimmed = address.trim();
    if (trimmed.isEmpty) return null;
    final uri = Uri.tryParse(
      trimmed.contains(_schemeSeparator)
          ? trimmed
          : '$_https$_schemeSeparator$trimmed',
    );
    return uri != null && uri.scheme != _mailto && isAllowed(uri) ? uri : null;
  }

  static const String _https = 'https';
  static const String _http = 'http';
  static const String _mailto = 'mailto';
  static const String _schemeSeparator = '://';
}

/// Dış bağlantı açan view ve view model'ler için.
mixin ExternalLinkMixin {
  /// [uri] izinliyse yeni sekmede açar; açıldıysa `true`.
  Future<bool> openExternalLink(Uri uri) async {
    if (!ExternalLinks.isAllowed(uri)) return false;
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Object catch (error, stack) {
      AppLogger.warn('Bağlantı açılamadı', error: error, stackTrace: stack);
      return false;
    }
  }
}
