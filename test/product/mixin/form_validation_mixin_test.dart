import 'package:flutter_test/flutter_test.dart';
import 'package:gu_teknofest/product/form/form_field_error.dart';
import 'package:gu_teknofest/product/mixin/form_validation_mixin.dart';
import 'package:tf_data/tf_data.dart';

enum _Field { name, email, about }

final class _Form with FormValidationMixin<_Field> {}

void main() {
  final form = _Form();

  test('validateFields yalnızca hatalı alanları döner', () {
    final errors = form.validateFields({
      _Field.name: () => form.requiredError('  '),
      _Field.email: () => form.emailError('ornek@example.com'),
      _Field.about: () => form.lengthError('', min: 0, max: 10),
    });

    expect(errors, {_Field.name: FormFieldError.required});
  });

  test('emailError boş ve bozuk adresi ayırır', () {
    expect(form.emailError(''), FormFieldError.required);
    expect(form.emailError('ornek'), FormFieldError.invalidEmail);
    expect(form.emailError('ornek@alan'), FormFieldError.invalidEmail);
    expect(form.emailError(' ornek@example.com '), isNull);
  });

  test('lengthError alt ve üst sınırı uygular', () {
    expect(form.lengthError('', min: 1, max: 5), FormFieldError.required);
    expect(form.lengthError('ab', min: 3, max: 5), FormFieldError.tooShort);
    expect(form.lengthError('abcdef', min: 3, max: 5), FormFieldError.tooLong);
    expect(form.lengthError('abcd', min: 3, max: 5), isNull);
  });

  test('fromFieldError veri katmanı hatasını form hatasına çevirir', () {
    expect(form.fromFieldError(null), isNull);
    expect(form.fromFieldError(FieldError.empty), FormFieldError.required);
    expect(
      form.fromFieldError(FieldError.outOfRange),
      FormFieldError.limitExceeded,
    );
  });

  test('firstErrorField verilen sıradaki ilk hatalı alanı bulur', () {
    final errors = {
      _Field.about: FormFieldError.tooLong,
      _Field.email: FormFieldError.invalidEmail,
    };

    expect(form.firstErrorField(errors, _Field.values), _Field.email);
    expect(form.firstErrorField(const {}, _Field.values), isNull);
  });
}
