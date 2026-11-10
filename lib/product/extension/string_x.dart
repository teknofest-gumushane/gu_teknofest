// Kaynak: gu_kulupler/packages/gu_ui string_x.dart (MIT, aynı yazar); yerel seçimi çıkarıldı
// (bu site yalnız Türkçe).

/// Bir ya da daha çok boşluk karakteri.
final RegExp _whitespace = RegExp(r'\s+');

/// Türkçe küçük harf alfabesi (sıralama ağırlığı = konum).
const String _trAlphabet = 'abcçdefgğhıijklmnoöpqrsştuüvwxyz';

int _trWeight(String char) {
  const base = 0x61;
  final index = _trAlphabet.indexOf(char);
  if (index >= 0) return base + index;
  final code = char.codeUnitAt(0);
  return code < base ? code : code + _trAlphabet.length;
}

/// Önceden [TurkishCaseX.trLower] ile küçültülmüş iki metnin Türkçe alfabe
/// karşılaştırması.
int trCompareLowered(String a, String b) {
  final n = a.length < b.length ? a.length : b.length;
  for (var i = 0; i < n; i++) {
    final diff = _trWeight(a[i]) - _trWeight(b[i]);
    if (diff != 0) return diff.sign;
  }
  return (a.length - b.length).sign;
}

/// Türkçe büyük/küçük harf dönüşümleri.
///
/// Dart'ın `toUpperCase()` / `toLowerCase()` çağrıları yerelden bağımsızdır:
/// `'i'.toUpperCase() == 'I'`. Türkçede noktalı ve noktasız i ayrı harflerdir
/// (`i ↔ İ`, `ı ↔ I`).
extension TurkishCaseX on String {
  /// Türkçe büyük harf: `'istanbul'.trUpper() == 'İSTANBUL'`.
  String trUpper() => replaceAll('i', 'İ').replaceAll('ı', 'I').toUpperCase();

  /// Türkçe küçük harf: `'ISPARTA'.trLower() == 'ısparta'`.
  String trLower() => replaceAll('I', 'ı').replaceAll('İ', 'i').toLowerCase();

  /// Türkçe alfabe sırasıyla, büyük/küçük harf duyarsız karşılaştırma.
  int trCompareTo(String other) => trCompareLowered(trLower(), other.trLower());

  /// Baş harfler: parça yoksa `'?'`; tek parça → ilk harf; çok parça → ilk ve
  /// son parçanın ilk harfi. `'Ayşe Demir'.initials == 'AD'`.
  String get initials {
    final parts = trim()
        .split(_whitespace)
        .where((part) => part.isNotEmpty)
        .toList(growable: false);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].trUpper();
    return '${parts.first[0]}${parts.last[0]}'.trUpper();
  }
}
