import 'dart:convert';

/// Sahte veri dosyasının metnini veren işlev. Uygulama bunu
/// `rootBundle.loadString('assets/mock/$name.json')` ile bağlar; testler
/// doğrudan metin döndürür.
typedef MockAssetLoader = Future<String> Function(String name);

/// Sahte veri kaynağı: her dosya ilk erişimde bir kez okunur ve ayrıştırılır.
///
/// [latency] verilirse her okuma o kadar gecikir; arayüzde "yükleniyor"
/// durumunu görmek içindir.
final class MockDataSource {
  /// Kaynak oluşturur.
  MockDataSource(this._load, {this.latency = Duration.zero});

  final MockAssetLoader _load;

  /// Her okumaya eklenen yapay gecikme.
  final Duration latency;

  final Map<String, Future<Object?>> _cache = {};

  /// `<name>.json` içindeki kayıt listesi; her öğe bir nesnedir.
  Future<List<Map<String, Object?>>> readList(String name) async {
    final raw = await _read(name);
    if (raw is! List) {
      throw FormatException('$name.json: liste bekleniyordu');
    }
    return [
      for (final item in raw)
        if (item is Map)
          Map<String, Object?>.from(item)
        else
          throw FormatException('$name.json: nesne bekleniyordu'),
    ];
  }

  /// `<name>.json` içindeki tek nesne.
  Future<Map<String, Object?>> readMap(String name) async {
    final raw = await _read(name);
    if (raw is! Map) {
      throw FormatException('$name.json: nesne bekleniyordu');
    }
    return Map<String, Object?>.from(raw);
  }

  Future<Object?> _read(String name) async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    return _cache[name] ??= _load(name).then(jsonDecode);
  }
}
