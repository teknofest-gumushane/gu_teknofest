import 'package:flutter/widgets.dart';
import 'package:gu_teknofest/l10n/app_localizations.dart';

/// Metin erişimi: `context.l10n.navAbout`.
extension L10nX on BuildContext {
  /// ARB'den üretilen metinler.
  AppLocalizations get l10n => AppLocalizations.of(this);
}
