import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:gu_teknofest/core/di/project_dependency.dart';
import 'package:gu_teknofest/core/di/project_dependency_mixin.dart';
import 'package:gu_teknofest/core/env/app_environment.dart';
import 'package:tf_data/tf_data.dart';

final class _Consumer with ProjectDependencyMixin {}

void main() {
  setUp(ProjectDependency.reset);
  tearDown(ProjectDependency.reset);

  Future<String> loader(String name) async =>
      name == MockClubInfoRepository.asset ? '{"memberCount": 7}' : '[]';

  test('setup tüm repository arayüzlerini kaydeder', () async {
    await ProjectDependency.setup(mockAssetLoader: loader);

    expect(GetIt.I.isRegistered<AppClock>(), isTrue);
    expect(GetIt.I.isRegistered<ClubInfoRepository>(), isTrue);
    expect(GetIt.I.isRegistered<ProjectRepository>(), isTrue);
    expect(GetIt.I.isRegistered<EventRepository>(), isTrue);
    expect(GetIt.I.isRegistered<MemberRepository>(), isTrue);
    expect(GetIt.I.isRegistered<GalleryRepository>(), isTrue);
    expect(GetIt.I.isRegistered<JoinApplicationRepository>(), isTrue);
  });

  test('mixin kayıtlı repository üzerinden veri okur', () async {
    await ProjectDependency.setup(mockAssetLoader: loader);

    final info = await _Consumer().clubInfoRepository.fetchClubInfo();

    expect(info.dataOrNull!.memberCount, 7);
  });

  test(
    'backend bağlanana dek diğer ortamlar da sahte veriyle açılır',
    () async {
      await ProjectDependency.setup(
        env: AppEnv.production,
        mockAssetLoader: loader,
      );

      expect(GetIt.I<ProjectRepository>(), isA<MockProjectRepository>());
    },
  );

  test('reset kayıtları siler', () async {
    await ProjectDependency.setup(mockAssetLoader: loader);
    await ProjectDependency.reset();

    expect(GetIt.I.isRegistered<ProjectRepository>(), isFalse);
  });
}
