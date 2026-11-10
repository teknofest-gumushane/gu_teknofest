import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:gu_teknofest/core/constants/app_constants.dart';
import 'package:gu_teknofest/core/constants/app_durations.dart';
import 'package:gu_teknofest/core/env/app_environment.dart';
import 'package:gu_teknofest/core/error/app_logger.dart';
import 'package:tf_data/tf_data.dart';

/// Servis ve repository kayıtları (GetIt). Hangi uygulamanın kaydedileceğine
/// burada karar verilir; ekran ve view model kodu bunu bilmez.
abstract final class ProjectDependency {
  /// Kayıtları kurar. [mockAssetLoader] testlerde sahte veri dosyalarını
  /// vermek içindir; verilmezse `assets/mock` okunur.
  static Future<void> setup({
    AppEnv? env,
    MockAssetLoader? mockAssetLoader,
    AppClock clock = const SystemAppClock(),
  }) async {
    final resolved = env ?? AppEnvironment.current;
    if (resolved != AppEnv.mock && !AppEnvironment.hasBackend(resolved)) {
      AppLogger.warn(
        'ENV=${resolved.define}: Firebase bağlantısı henüz yok (backend fazı); '
        'sahte veri kullanılıyor.',
      );
    }
    final source = MockDataSource(
      mockAssetLoader ?? _loadMockAsset,
      latency: mockAssetLoader == null
          ? AppDurations.mockLatency
          : Duration.zero,
    );
    GetIt.I
      ..registerSingleton<AppClock>(clock)
      ..registerSingleton<ClubInfoRepository>(
        MockClubInfoRepository(source, clock: clock),
      )
      ..registerSingleton<ProjectRepository>(
        MockProjectRepository(source, clock: clock),
      )
      ..registerSingleton<EventRepository>(
        MockEventRepository(source, clock: clock),
      )
      ..registerSingleton<MemberRepository>(
        MockMemberRepository(source, clock: clock),
      )
      ..registerSingleton<GalleryRepository>(
        MockGalleryRepository(source, clock: clock),
      )
      ..registerSingleton<JoinApplicationRepository>(
        MockJoinApplicationRepository(source, clock: clock),
      );
  }

  /// Tüm kayıtları siler (testler arasında).
  static Future<void> reset() => GetIt.I.reset();

  static Future<String> _loadMockAsset(String name) => rootBundle.loadString(
    '${AppConstants.mockAssetDir}/$name${AppConstants.mockAssetExtension}',
  );
}
