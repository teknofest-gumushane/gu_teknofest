// Uyarlama: gu_kulupler form_validation_mixin.dart (MIT, aynı yazar). Projeden bağımsız kurallar
// alındı; e-posta alan adı ve parola kuralları o projeye özeldi, alınmadı.
import 'package:gu_teknofest/product/form/form_field_error.dart';
import 'package:tf_data/tf_data.dart';

/// Form view model'leri için ortak doğrulama yardımcıları. [F] formun alan
/// enum'ıdır.
mixin FormValidationMixin<F extends Enum> {
  static final RegExp _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  /// [rules] içindeki her kuralı çalıştırır; yalnızca hatalı alanları döner.
  Map<F, FormFieldError> validateFields(
    Map<F, FormFieldError? Function()> rules,
  ) => <F, FormFieldError>{
    for (final MapEntry(key: field, value: rule) in rules.entries)
      field: ?rule(),
  };

  /// Veri katmanının alan hatasını form hatasına çevirir.
  FormFieldError? fromFieldError(FieldError? error) => switch (error) {
    null => null,
    FieldError.empty => FormFieldError.required,
    FieldError.tooShort => FormFieldError.tooShort,
    FieldError.tooLong => FormFieldError.tooLong,
    FieldError.invalidFormat => FormFieldError.invalidFormat,
    FieldError.outOfRange => FormFieldError.limitExceeded,
  };

  /// Zorunlu alan: boş ya da yalnızca boşluksa hata.
  FormFieldError? requiredError(String value) =>
      value.trim().isEmpty ? FormFieldError.required : null;

  /// E-posta: boşsa `required`, biçimi bozuksa `invalidEmail`.
  FormFieldError? emailError(String value) {
    final address = value.trim();
    if (address.isEmpty) return FormFieldError.required;
    return _email.hasMatch(address) ? null : FormFieldError.invalidEmail;
  }

  /// Uzunluk: [min] sıfırdan büyükse alan zorunludur.
  FormFieldError? lengthError(
    String value, {
    required int min,
    required int max,
  }) {
    final length = value.trim().runes.length;
    if (length == 0) return min > 0 ? FormFieldError.required : null;
    if (length < min) return FormFieldError.tooShort;
    if (length > max) return FormFieldError.tooLong;
    return null;
  }

  /// [order] sırasındaki ilk hatalı alan (odağı oraya taşımak için).
  F? firstErrorField(Map<F, FormFieldError> errors, List<F> order) {
    for (final field in order) {
      if (errors.containsKey(field)) return field;
    }
    return null;
  }
}
