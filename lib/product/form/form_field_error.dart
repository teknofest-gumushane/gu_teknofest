/// Bir form alanının doğrulama hatası. Arayüz her değeri ARB'deki metnine
/// çevirir.
enum FormFieldError {
  /// Zorunlu alan boş.
  required,

  /// Çok kısa.
  tooShort,

  /// Çok uzun.
  tooLong,

  /// Biçim bozuk.
  invalidFormat,

  /// E-posta biçimi bozuk.
  invalidEmail,

  /// İzinli aralığın dışında.
  limitExceeded,
}
