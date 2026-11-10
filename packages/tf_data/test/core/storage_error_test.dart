// Kaynak: gu_kulupler/packages/tf_data/test (MIT, aynı yazar). Yorumlardaki D-xx / CD-xx / T-xx / PLAN
// kimlikleri o projeye aittir.
// T-08 · StorageError: üye listesi, hata kodu eşleme tablosu ve PLAN paritesi
// (PLAN §4.2, §10.1).
import 'package:flutter_test/flutter_test.dart';
import 'package:tf_data/tf_data.dart';

/// PLAN §4.2 ağaç satırındaki sırayla 10 üye.
const List<String> _members = [
  'unauthorized',
  'notFound',
  'canceled',
  'quotaExceeded',
  'retryLimitExceeded',
  'unknown',
  'sizeLimit',
  'invalidType',
  'noFile',
  'timeout',
];

/// `firebase_storage` `FirebaseException.code` → beklenen üye (PLAN §10.1
/// tablosunun SDK satırları).
const Map<String, StorageError> _sdkCodes = {
  'unauthorized': StorageError.unauthorized,
  'unauthenticated': StorageError.unauthorized,
  'object-not-found': StorageError.notFound,
  'canceled': StorageError.canceled,
  'quota-exceeded': StorageError.quotaExceeded,
  'retry-limit-exceeded': StorageError.retryLimitExceeded,
  'invalid-checksum': StorageError.unknown,
  'bucket-not-found': StorageError.unknown,
  'project-not-found': StorageError.unknown,
  'invalid-url': StorageError.unknown,
  'invalid-argument': StorageError.unknown,
  'no-default-bucket': StorageError.unknown,
};

/// SDK'nın üretmediği, yalnızca uygulama kodunun kurduğu üyeler.
const Set<StorageError> _appOnly = {
  StorageError.sizeLimit,
  StorageError.invalidType,
  StorageError.noFile,
  StorageError.timeout,
};

void main() {
  group('T-08 · StorageError · üyeler', () {
    test('10 üye, PLAN sırasıyla', () {
      expect([for (final e in StorageError.values) e.name], _members);
      expect(StorageError.values, hasLength(10));
    });

    test('her üye ya SDK eşlemesinde ya da uygulama kümesinde (ayrık)', () {
      final fromSdk = _sdkCodes.values.toSet();

      expect(fromSdk.intersection(_appOnly), isEmpty);
      expect({...fromSdk, ..._appOnly}, StorageError.values.toSet());
    });
  });

  group('T-08 · StorageError.fromCode · tablo', () {
    _sdkCodes.forEach((code, expected) {
      test('$code → ${expected.name}', () {
        expect(StorageError.fromCode(code), expected);
      });
    });

    test('unauthenticated ayrı üye değil, unauthorized', () {
      expect(
        StorageError.fromCode('unauthenticated'),
        StorageError.fromCode('unauthorized'),
      );
    });

    test('Storage yazımı "canceled" (tek l); "cancelled" eşleşmez', () {
      expect(StorageError.fromCode('canceled'), StorageError.canceled);
      expect(StorageError.fromCode('cancelled'), StorageError.unknown);
    });
  });

  group('T-08 · StorageError.fromCode · eşleşmeyen', () {
    for (final code in const [
      '',
      ' ',
      'x',
      'UNAUTHORIZED',
      'Unauthorized',
      ' unauthorized',
      'unauthorized ',
      'firebase_storage/unauthorized',
      '[firebase_storage/object-not-found]',
      'object_not_found',
      'objectNotFound',
      'not-found',
      'notFound',
      'permission-denied',
      'quotaExceeded',
      'retry-limit',
      'unknown',
      'server-file-wrong-size',
      'cannot-slice-blob',
    ]) {
      test('"$code" → unknown', () {
        expect(StorageError.fromCode(code), StorageError.unknown);
      });
    }

    test('uygulama üyelerinin adları SDK kodu sayılmaz', () {
      for (final code in const [
        'sizeLimit',
        'size-limit',
        'invalidType',
        'invalid-type',
        'noFile',
        'no-file',
        'timeout',
      ]) {
        expect(
          StorageError.fromCode(code),
          StorageError.unknown,
          reason: code,
        );
      }
    });

    test('fromCode hiçbir girdide uygulama üyesi döndürmez', () {
      final candidates = [
        ..._sdkCodes.keys,
        for (final error in StorageError.values) error.name,
      ];

      for (final code in candidates) {
        expect(_appOnly, isNot(contains(StorageError.fromCode(code))));
      }
    });
  });
}
