import 'package:tf_data/src/core/app_clock.dart';
import 'package:tf_data/src/core/base_fields.dart';
import 'package:tf_data/src/core/firebase_result.dart';
import 'package:tf_data/src/core/firestore_error.dart';
import 'package:tf_data/src/repositories/mock_data_source.dart';

/// Bir kaydın kimlik ve ortak alanlarını değiştiren kopyalayıcı; modellerin
/// `copyWith` yöntemine bağlanır.
typedef MockStamp<T> = T Function(
  T item, {
  String? id,
  DateTime? createdAt,
  DateTime? updatedAt,
  bool? isDeleted,
  DateTime? deletedAt,
  String? deletedBy,
  bool clearDeletion,
});

/// Bellekte koleksiyon: ilk erişimde sahte veri dosyasından yüklenir; yazmalar
/// oturum boyunca bellekte kalır (sayfa yenilenince sıfırlanır).
///
/// Silme soft delete'tir (D-10): kayıt listeden çıkmaz, işaretlenir.
final class MockCollection<T extends BaseFields> {
  /// Koleksiyon oluşturur. [asset] verilmezse koleksiyon boş başlar.
  MockCollection({
    required this._source,
    required this.idPrefix,
    required this._parse,
    required this._idOf,
    required this._stamp,
    this.asset,
    this._clock = const SystemAppClock(),
  });

  /// Sahte veri dosyasının adı (uzantısız); yoksa `null`.
  final String? asset;

  /// Yeni kayıtlara verilen kimliğin öneki (`<önek>-yeni-<sıra>`).
  final String idPrefix;

  /// Sahte oturumda kayıt silen / oluşturan yöneticinin kimliği.
  static const String mockAdminId = 'mock-admin';

  static const String _idKey = 'id';

  final MockDataSource _source;
  final T Function(Map<String, Object?> json, String id) _parse;
  final String Function(T item) _idOf;
  final MockStamp<T> _stamp;
  final AppClock _clock;

  List<T>? _items;
  int _sequence = 0;

  /// [body] sonucunu başarıya, fırlattığı her hatayı `parse` başarısızlığına
  /// çevirir (bozuk sahte veri dosyası arayüzde hata durumu olarak görünür).
  Future<FirestoreResult<R>> guard<R>(Future<R> Function() body) async {
    try {
      return FirebaseSuccess(await body());
    } on Object catch (error) {
      return FirebaseFailure(FirestoreError.parse, message: '$error');
    }
  }

  /// Silinmemiş kayıtlar (kopya liste).
  Future<List<T>> live() async => [
    for (final item in await _load())
      if (item.isLive) item,
  ];

  /// Kaydı oluşturur ([T] kimliği boşsa) ya da günceller; kaydedileni döner.
  /// Güncellenecek kayıt yoksa `null`.
  Future<T?> save(T item) async {
    final items = await _load();
    final now = _clock.nowUtc();
    final id = _idOf(item);
    if (id.isEmpty) {
      _sequence += 1;
      final created = _stamp(
        item,
        id: '$idPrefix-yeni-$_sequence',
        createdAt: now,
        updatedAt: now,
      );
      items.add(created);
      return created;
    }
    final index = items.indexWhere((existing) => _idOf(existing) == id);
    if (index < 0) return null;
    final updated = _stamp(item, updatedAt: now);
    items[index] = updated;
    return updated;
  }

  /// Kaydı silinmiş olarak işaretler ya da geri alır; kayıt yoksa `false`.
  Future<bool> setDeleted(String id, {required bool deleted}) async {
    final items = await _load();
    final index = items.indexWhere((existing) => _idOf(existing) == id);
    if (index < 0) return false;
    final now = _clock.nowUtc();
    items[index] = deleted
        ? _stamp(
            items[index],
            isDeleted: true,
            deletedAt: now,
            deletedBy: mockAdminId,
            updatedAt: now,
          )
        : _stamp(
            items[index],
            isDeleted: false,
            clearDeletion: true,
            updatedAt: now,
          );
    return true;
  }

  Future<List<T>> _load() async {
    final cached = _items;
    if (cached != null) return cached;
    final name = asset;
    final loaded = <T>[
      if (name != null)
        for (final json in await _source.readList(name))
          _parse(
            Map<String, Object?>.of(json)..remove(_idKey),
            '${json[_idKey] ?? ''}',
          ),
    ];
    return _items = loaded;
  }
}
