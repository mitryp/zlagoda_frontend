typedef FieldValidator = String? Function(String?);

FieldValidator all(List<FieldValidator> validators) {
  return (s) {
    for (final validator in validators) {
      final String? error = validator(s);
      if (error != null) return error;
    }

    return null;
  };
}

FieldValidator get noValidation => (s) => null;

FieldValidator get notEmpty => (s) => s?.isEmpty ?? true ? 'Поле не має бути порожнім' : null;

FieldValidator hasLength(int length) => all([notEmpty, (s) => _exactLengthValidator(s, length)]);

FieldValidator get isInteger => all([notEmpty, _integerValidator]);

FieldValidator get isDouble => all([notEmpty, _doubleValidator]);

String? _exactLengthValidator(String? s, int length) =>
    s!.length != length ? 'Довжина поля повинна складати $length символів' : null;

String? _integerValidator(String? s) =>
    int.tryParse(s!) == null ? 'Значення повинно бути цілим числом' : null;

String? _doubleValidator(String? s) =>
    double.tryParse(s!) == null ? 'Значення повинно бути дробовим числом' : null;
