import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tf_data/tf_data.dart';

import '../fakes/fake_app_clock.dart';

/// Dosya adı → JSON metni veren sahte yükleyiciyle kaynak kurar.
MockDataSource _sourceOf(Map<String, Object?> files) => MockDataSource(
  (name) async => files.containsKey(name)
      ? jsonEncode(files[name])
      : throw StateError('dosya yok: $name'),
);

Map<String, Object?> _project(
  String id, {
  required int order,
  String? name,
  bool deleted = false,
}) => {
  'id': id,
  FirestoreFields.name: name ?? 'Proje $id',
  FirestoreFields.displayOrder: order,
  FirestoreFields.isDeleted: deleted,
};

void main() {
  final now = DateTime.utc(2026, 10, 8, 20, 15);
  late FakeAppClock clock;

  setUp(() => clock = FakeAppClock(now));

  group('MockDataSource', () {
    test('her dosyayı yalnızca bir kez okur', () async {
      var reads = 0;
      final source = MockDataSource((name) async {
        reads++;
        return '[]';
      });

      await source.readList('projects');
      await source.readList('projects');

      expect(reads, 1);
    });

    test('liste yerine nesne gelirse FormatException fırlatır', () {
      final source = _sourceOf({'projects': <String, Object?>{}});

      expect(() => source.readList('projects'), throwsFormatException);
    });
  });

  group('MockProjectRepository', () {
    MockProjectRepository repositoryOf(List<Map<String, Object?>> items) =>
        MockProjectRepository(_sourceOf({'projects': items}), clock: clock);

    test('silinmişleri süzer ve sıra numarasına göre dizer', () async {
      final repository = repositoryOf([
        _project('p03', order: 3),
        _project('p01', order: 1),
        _project('p04', order: 0, deleted: true),
        _project('p02', order: 2),
      ]);

      final result = await repository.fetchProjects();

      expect(result.dataOrNull!.map((p) => p.id), ['p01', 'p02', 'p03']);
    });

    test('bozuk veri parse başarısızlığıdır', () async {
      final repository = repositoryOf([
        {'id': 'p01', FirestoreFields.status: 'bilinmeyen'},
      ]);

      final result = await repository.fetchProjects();

      expect(result.errorOrNull, FirestoreError.parse);
    });

    test(
      'kimliği boş kayıt oluşturulur: kimlik ve zaman damgası alır',
      () async {
        final repository = repositoryOf([]);

        final saved = await repository.saveProject(
          const ProjectModel(name: 'Yeni'),
        );

        expect(saved.dataOrNull!.id, isNotEmpty);
        expect(saved.dataOrNull!.createdAt, now);
        expect((await repository.fetchProjects()).dataOrNull, hasLength(1));
      },
    );

    test('var olan kayıt güncellenir; olmayan kayıt notFound döner', () async {
      final repository = repositoryOf([_project('p01', order: 1)]);
      final existing = (await repository.fetchProjects()).dataOrNull!.single;

      final updated = await repository.saveProject(
        existing.copyWith(name: 'Değişti'),
      );
      final missing = await repository.saveProject(
        const ProjectModel(id: 'yok', name: 'Yok'),
      );

      expect(updated.dataOrNull!.name, 'Değişti');
      expect(updated.dataOrNull!.updatedAt, now);
      expect(missing.errorOrNull, FirestoreError.notFound);
    });

    test(
      'soft delete kaydı listeden çıkarır, geri alma geri getirir',
      () async {
        final repository = repositoryOf([_project('p01', order: 1)]);

        expect((await repository.softDeleteProject('p01')).isSuccess, isTrue);
        expect((await repository.fetchProjects()).dataOrNull, isEmpty);

        expect((await repository.restoreProject('p01')).isSuccess, isTrue);

        final restored = (await repository.fetchProjects()).dataOrNull!.single;

        expect(restored.isDeleted, isFalse);
        expect(restored.deletedAt, isNull);
        expect(
          (await repository.softDeleteProject('yok')).errorOrNull,
          FirestoreError.notFound,
        );
      },
    );
  });

  group('MockEventRepository', () {
    test('en yeni etkinlik önce gelir', () async {
      final repository = MockEventRepository(
        _sourceOf({
          'events': [
            {
              'id': 'eski',
              FirestoreFields.name: 'Eski',
              FirestoreFields.eventTime: '2026-01-01T10:00:00Z',
            },
            {
              'id': 'yeni',
              FirestoreFields.name: 'Yeni',
              FirestoreFields.eventTime: '2027-01-01T10:00:00Z',
            },
          ],
        }),
        clock: clock,
      );

      final result = await repository.fetchEvents();

      expect(result.dataOrNull!.map((e) => e.id), ['yeni', 'eski']);
    });
  });

  group('MockMemberRepository', () {
    final files = {
      'members': [
        {
          'id': 'm02',
          FirestoreFields.name: 'İki',
          FirestoreFields.displayOrder: 2,
        },
        {
          'id': 'm03',
          FirestoreFields.name: 'Üç',
          FirestoreFields.displayOrder: 3,
          FirestoreFields.isActive: false,
        },
        {
          'id': 'm01',
          FirestoreFields.name: 'Bir',
          FirestoreFields.displayOrder: 1,
        },
      ],
    };

    test('varsayılan olarak yalnızca aktif üyeler, sırayla', () async {
      final repository = MockMemberRepository(_sourceOf(files), clock: clock);

      final result = await repository.fetchMembers();

      expect(result.dataOrNull!.map((m) => m.id), ['m01', 'm02']);
    });

    test('includeInactive pasif üyeleri de getirir', () async {
      final repository = MockMemberRepository(_sourceOf(files), clock: clock);

      final result = await repository.fetchMembers(includeInactive: true);

      expect(result.dataOrNull!.map((m) => m.id), ['m01', 'm02', 'm03']);
    });
  });

  group('MockGalleryRepository · MockClubInfoRepository', () {
    test('galeri sıra numarasına göre gelir', () async {
      final repository = MockGalleryRepository(
        _sourceOf({
          'gallery': [
            {
              'id': 'g02',
              FirestoreFields.imagePath: 'gallery/g02/b.jpg',
              FirestoreFields.displayOrder: 2,
            },
            {
              'id': 'g01',
              FirestoreFields.imagePath: 'gallery/g01/a.jpg',
              FirestoreFields.displayOrder: 1,
            },
          ],
        }),
        clock: clock,
      );

      final result = await repository.fetchGallery();

      expect(result.dataOrNull!.map((g) => g.id), ['g01', 'g02']);
    });

    test(
      'kulüp bilgisi okunur; kaydedilen değer sonraki okumada gelir',
      () async {
        final repository = MockClubInfoRepository(
          _sourceOf({
            'club_info': {FirestoreFields.memberCount: 48},
          }),
          clock: clock,
        );

        final first = (await repository.fetchClubInfo()).dataOrNull!;
        await repository.saveClubInfo(first.copyWith(memberCount: 50));
        final second = (await repository.fetchClubInfo()).dataOrNull!;

        expect(first.memberCount, 48);
        expect(second.memberCount, 50);
        expect(second.updatedAt, now);
      },
    );

    test('kulüp bilgisi dosyası yoksa parse başarısızlığı döner', () async {
      final repository = MockClubInfoRepository(_sourceOf({}), clock: clock);

      expect(
        (await repository.fetchClubInfo()).errorOrNull,
        FirestoreError.parse,
      );
    });
  });

  group('MockJoinApplicationRepository', () {
    const application = JoinApplicationModel(
      id: 'disaridan-gelen-kimlik',
      firstName: 'Ad',
      lastName: 'Soyad',
      classYear: '2. sınıf',
      department: 'Örnek Bölüm',
      email: 'ornek@example.com',
      phone: '+90 000 000 00 00',
    );

    test('boş başlar; her gönderim yeni kimlikli yeni kayıttır', () async {
      final repository = MockJoinApplicationRepository(
        _sourceOf({}),
        clock: clock,
      );

      expect((await repository.fetchApplications()).dataOrNull, isEmpty);

      final first = await repository.submitApplication(application);
      final second = await repository.submitApplication(application);

      expect(first.dataOrNull!.id, isNot('disaridan-gelen-kimlik'));
      expect(first.dataOrNull!.id, isNot(second.dataOrNull!.id));
      expect(first.dataOrNull!.createdAt, now);
      expect((await repository.fetchApplications()).dataOrNull, hasLength(2));
    });

    test('en yeni başvuru önce gelir; silinen listeden çıkar', () async {
      final repository = MockJoinApplicationRepository(
        _sourceOf({}),
        clock: clock,
      );
      final older = (await repository.submitApplication(
        application,
      )).dataOrNull!;
      clock.advance(const Duration(minutes: 5));
      final newer = (await repository.submitApplication(
        application,
      )).dataOrNull!;

      final listed = (await repository.fetchApplications()).dataOrNull!;

      expect(listed.map((a) => a.id), [newer.id, older.id]);

      await repository.softDeleteApplication(newer.id);

      expect(
        (await repository.fetchApplications()).dataOrNull!.map((a) => a.id),
        [older.id],
      );
    });
  });
}
