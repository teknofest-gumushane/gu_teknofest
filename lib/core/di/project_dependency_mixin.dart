import 'package:get_it/get_it.dart';
import 'package:tf_data/tf_data.dart';

/// View model'lerin bağımlılıklara eriştiği yer. View ve widget dosyalarında
/// `GetIt` kullanılmaz (`tool/check_hardcode.sh` HC13).
mixin ProjectDependencyMixin {
  /// Uygulama saati (testte sabitlenebilir).
  AppClock get appClock => GetIt.I<AppClock>();

  // ── Repository'ler ───────────────────────────────────────────────────

  /// Kulüp bilgisi.
  ClubInfoRepository get clubInfoRepository => GetIt.I<ClubInfoRepository>();

  /// Projeler.
  ProjectRepository get projectRepository => GetIt.I<ProjectRepository>();

  /// Etkinlikler.
  EventRepository get eventRepository => GetIt.I<EventRepository>();

  /// Ekip üyeleri.
  MemberRepository get memberRepository => GetIt.I<MemberRepository>();

  /// Galeri.
  GalleryRepository get galleryRepository => GetIt.I<GalleryRepository>();

  /// Takıma Katıl başvuruları.
  JoinApplicationRepository get joinApplicationRepository =>
      GetIt.I<JoinApplicationRepository>();
}
