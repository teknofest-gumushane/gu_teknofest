import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tf_data/tf_data.dart';

/// Depodaki gerçek `assets/mock/*.json` dosyalarının modellere ayrıştığını
/// doğrular: bozuk bir sahte veri dosyası uygulamada değil burada yakalanır.
void main() {
  MockDataSource source() => MockDataSource(
    (name) => File('assets/mock/$name.json').readAsString(),
  );

  test('club_info.json okunur', () async {
    final result = await MockClubInfoRepository(source()).fetchClubInfo();

    expect(result.isSuccess, isTrue, reason: '${result.errorOrNull}');
    expect(result.dataOrNull!.memberCount, greaterThan(0));
  });

  test('projects.json okunur; silinmiş kayıt listede yoktur', () async {
    final result = await MockProjectRepository(source()).fetchProjects();

    expect(result.isSuccess, isTrue, reason: '${result.errorOrNull}');
    expect(result.dataOrNull, isNotEmpty);
    expect(result.dataOrNull!.every((project) => project.isLive), isTrue);
    expect(
      File('assets/mock/projects.json').readAsStringSync(),
      contains('"isDeleted": true'),
      reason: 'süzmeyi denemek için en az bir silinmiş örnek kayıt olmalı',
    );
  });

  test(
    'events.json okunur; en az bir yaklaşan ve bir geçmiş etkinlik var',
    () async {
      final result = await MockEventRepository(source()).fetchEvents();
      final now = DateTime.utc(2026, 11, 10);

      expect(result.isSuccess, isTrue, reason: '${result.errorOrNull}');
      expect(
        result.dataOrNull!.any((event) => event.isUpcomingAt(now)),
        isTrue,
      );
      expect(
        result.dataOrNull!.any((event) => !event.isUpcomingAt(now)),
        isTrue,
      );
    },
  );

  test('members.json okunur; pasif üye varsayılan listede yoktur', () async {
    final repository = MockMemberRepository(source());

    final active = await repository.fetchMembers();
    final all = await repository.fetchMembers(includeInactive: true);

    expect(active.isSuccess, isTrue, reason: '${active.errorOrNull}');
    expect(active.dataOrNull, isNotEmpty);
    expect(all.dataOrNull!.length, greaterThan(active.dataOrNull!.length));
  });

  test(
    'gallery.json okunur; her görsel yolu galeri yolu biçimindedir',
    () async {
      final result = await MockGalleryRepository(source()).fetchGallery();

      expect(result.isSuccess, isTrue, reason: '${result.errorOrNull}');
      expect(result.dataOrNull, isNotEmpty);
      for (final item in result.dataOrNull!) {
        expect(
          StoragePaths.isGalleryImage(item.imagePath, item.id),
          isTrue,
          reason: item.imagePath,
        );
      }
    },
  );

  test('sahte veri referans siteden içerik taşımaz', () {
    for (final file in Directory('assets/mock').listSync().whereType<File>()) {
      final text = file.readAsStringSync().toLowerCase();

      expect(text, isNot(contains('maltepe')), reason: file.path);
      expect(text, isNot(contains('mauteknofest')), reason: file.path);
    }
  });
}
