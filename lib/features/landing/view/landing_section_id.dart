import 'package:gu_teknofest/l10n/app_localizations.dart';

/// Genel sayfanın bölümleri, sayfadaki sırayla. Menü, kaydırma ve bölüm
/// anahtarları bu enum'dan türetilir.
enum LandingSectionId {
  /// Giriş (hero).
  hero,

  /// Hakkımızda.
  about,

  /// Projeler.
  projects,

  /// Etkinlikler.
  events,

  /// Galeri.
  gallery,

  /// Ekibimiz.
  team,

  /// Sosyal medya.
  socials;

  /// Menüde gösterilen bölümler (giriş hariç; ona logo götürür).
  static const List<LandingSectionId> menu = [
    about,
    projects,
    events,
    gallery,
    team,
    socials,
  ];

  /// Menüdeki adı.
  String label(AppLocalizations l10n) => switch (this) {
    hero => l10n.heroTitle,
    about => l10n.navAbout,
    projects => l10n.navProjects,
    events => l10n.navEvents,
    gallery => l10n.navGallery,
    team => l10n.navTeam,
    socials => l10n.navSocials,
  };
}
