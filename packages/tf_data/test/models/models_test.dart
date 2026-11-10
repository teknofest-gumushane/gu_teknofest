import 'package:flutter_test/flutter_test.dart';
import 'package:tf_data/tf_data.dart';

void main() {
  final instant = DateTime.utc(2026, 10, 8, 20, 15);

  group('ClubInfoModel', () {
    test('fromJson alanları okur; eksik alanlar varsayılanı alır', () {
      final model = ClubInfoModel.fromJson(const {
        FirestoreFields.memberCount: 48,
        FirestoreFields.isApplicationOpen: true,
      });

      expect(model.memberCount, 48);
      expect(model.activeMemberCount, 0);
      expect(model.isApplicationOpen, isTrue);
      expect(model.logoPath, isNull);
    });

    test('copyWith clearLogoPath logoyu kaldırır', () {
      const model = ClubInfoModel(logoPath: 'club/main/a.jpg');

      expect(model.copyWith(clearLogoPath: true).logoPath, isNull);
      expect(model.copyWith(memberCount: 3).logoPath, 'club/main/a.jpg');
    });
  });

  group('ProjectModel', () {
    test("kimlik JSON'dan değil parametreden gelir ve JSON'a yazılmaz", () {
      final model = ProjectModel.fromJson(const {
        'id': 'veri-icindeki-kimlik',
        FirestoreFields.name: 'Örnek',
        FirestoreFields.status: 'completed',
        FirestoreFields.tags: ['Robotik'],
      }, id: 'p01');

      expect(model.id, 'p01');
      expect(model.status, ProjectStatus.completed);
      expect(model.tags, ['Robotik']);
      expect(model.toJson().containsKey('id'), isFalse);
    });

    test('ISO-8601 zaman dizgisi UTC ana çevrilir', () {
      final model = ProjectModel.fromJson(const {
        FirestoreFields.name: 'Örnek',
        FirestoreFields.createdAt: '2026-10-08T20:15:00Z',
      }, id: 'p01');

      expect(model.createdAt, instant);
    });

    test('bilinmeyen durum değeri ayrıştırma hatasıdır', () {
      expect(
        () => ProjectModel.fromJson(const {
          FirestoreFields.name: 'Örnek',
          FirestoreFields.status: 'bilinmeyen',
        }, id: 'p01'),
        throwsA(anything),
      );
    });

    test(
      'isLive silinmiş kayıtta false; clearDeletion silme izini temizler',
      () {
        final deleted = ProjectModel(
          name: 'Örnek',
          isDeleted: true,
          deletedAt: instant,
          deletedBy: 'yonetici',
        );

        expect(deleted.isLive, isFalse);

        final restored = deleted.copyWith(
          isDeleted: false,
          clearDeletion: true,
        );

        expect(restored.isLive, isTrue);
        expect(restored.deletedAt, isNull);
        expect(restored.deletedBy, isNull);
      },
    );
  });

  group('EventModel', () {
    test('gömülü görseller ayrıştırılır ve geri yazılır', () {
      final model = EventModel.fromJson(const {
        FirestoreFields.name: 'Örnek',
        FirestoreFields.eventTime: '2026-10-08T20:15:00Z',
        FirestoreFields.images: [
          {
            FirestoreFields.path: 'events/e01/a.jpg',
            FirestoreFields.title: 'A',
          },
        ],
      }, id: 'e01');

      expect(model.images.single.path, 'events/e01/a.jpg');
      expect(model.images.single.title, 'A');

      final images = model.toJson()[FirestoreFields.images]! as List<Object?>;

      expect(
        (images.single! as Map<String, Object?>)[FirestoreFields.path],
        'events/e01/a.jpg',
      );
    });

    test('etkinlik anı zorunludur', () {
      expect(
        () => EventModel.fromJson(const {
          FirestoreFields.name: 'Örnek',
        }, id: 'e01'),
        throwsA(anything),
      );
    });

    test('isUpcomingAt etkinlik anını verilen anla karşılaştırır', () {
      final model = EventModel(name: 'Örnek', eventTime: instant);

      expect(
        model.isUpcomingAt(instant.subtract(const Duration(minutes: 1))),
        isTrue,
      );
      expect(model.isUpcomingAt(instant), isFalse);
      expect(
        model.isUpcomingAt(instant.add(const Duration(minutes: 1))),
        isFalse,
      );
    });
  });

  group('MemberModel · GalleryItemModel · JoinApplicationModel', () {
    test('üye varsayılan olarak aktiftir', () {
      final model = MemberModel.fromJson(const {
        FirestoreFields.name: 'Örnek Üye',
      }, id: 'm01');

      expect(model.isActive, isTrue);
      expect(model.title, isEmpty);
    });

    test('galeri kaydında görsel yolu zorunludur', () {
      expect(
        () => GalleryItemModel.fromJson(const {
          FirestoreFields.title: 'Örnek',
        }, id: 'g01'),
        throwsA(anything),
      );
    });

    test("başvuru gidiş-dönüşte aynı kalır; boş tanıtım JSON'a yazılmaz", () {
      const model = JoinApplicationModel(
        id: 'b01',
        firstName: 'Ad',
        lastName: 'Soyad',
        classYear: '2. sınıf',
        department: 'Örnek Bölüm',
        email: 'ornek@example.com',
        phone: '+90 000 000 00 00',
      );
      final json = model.toJson();

      expect(json.containsKey(FirestoreFields.about), isFalse);
      expect(JoinApplicationModel.fromJson(json, id: 'b01'), model);
    });
  });
}
