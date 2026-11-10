// Kaynak: gu_kulupler/packages/gu_data field_validators.dart içindeki FieldError (MIT, aynı yazar).

/// Bir alan doğrulamasının başarısızlık nedeni. Arayüz her değeri kendi
/// metnine çevirir; `RepositoryHelpers.rejectInvalidFields` adını hata
/// mesajına yazar.
enum FieldError {
  /// Zorunlu değer yok: boş (ya da yalnızca boşluk) metin, boş liste, eksik
  /// alan.
  empty,

  /// Alt sınırın altında: çok kısa metin ya da çok az öğe.
  tooShort,

  /// Üst sınırın üstünde: çok uzun metin ya da çok fazla öğe.
  tooLong,

  /// Biçim bozuk, değer bilinen tabloda yok ya da başka bir alanla tutarsız.
  invalidFormat,

  /// Sayı, an ya da seçenek izinli aralığın / kümenin dışında.
  outOfRange,
}
