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

FieldValidator get isPositiveInteger => all([
      isInteger,
      (s) => _positiveIntegerValidator(int.parse(s!)),
    ]);

FieldValidator get isNonNegativeInteger => all([
      isInteger,
      (s) => _nonNegativeIntegerValidator(int.parse(s!)),
    ]);

FieldValidator isIntegerInRange(int min, int max) => all([
      isInteger,
      (s) => _rangeIntegerValidator(int.parse(s!), min, max),
    ]);

FieldValidator get isDouble => all([notEmpty, _doubleValidator]);

FieldValidator get isPhoneNumber => all([
      startsWith('+'),
      hasLength(13),
      (s) => isInteger(s!.replaceFirst('+', '')),
    ]);

FieldValidator startsWith(String pattern) =>
    all([notEmpty, (s) => _startsWithValidator(s, pattern)]);

String? _rangeIntegerValidator(int value, int min, int max) =>
    value >= min && value <= max ? null : 'Число повинно знаходитися в межах від $min до $max';

String? _startsWithValidator(String? s, String pattern) =>
    !s!.startsWith(pattern) ? 'Стрічка повинна починатися з "$pattern"' : null;

String? _exactLengthValidator(String? s, int length) =>
    s!.length != length ? 'Довжина поля повинна складати $length символів' : null;

String? _integerValidator(String? s) =>
    int.tryParse(s!) == null ? 'Значення повинно бути цілим числом' : null;

String? _positiveIntegerValidator(int n) => n <= 0 ? 'Число повинно бути більшим за 0' : null;

String? _nonNegativeIntegerValidator(int n) => n < 0 ? 'Число повинно бути не меншим за 0' : null;

String? _doubleValidator(String? s) =>
    double.tryParse(s!) == null ? 'Значення повинно бути дробовим числом' : null;
