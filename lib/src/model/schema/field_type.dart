import 'package:flutter/material.dart';

typedef TypeConverter<T> = T Function(String);
typedef PresentationFunction<T> = String Function(T);

enum FieldType<T> {
  auto<dynamic>(_never),
  serializable<dynamic>(_never),
  constrainedToEnum<dynamic>(_never),
  transitive<dynamic>(_never),
  text<String>(_stringConverter),
  number<int>(int.parse),
  currency<int>(_currencyConverter, _presentCurrency),
  date<DateTime>(_dateConverter, _presentDate),
  datetime<DateTime>(_dateTimeConverter, _presentDateTime),
  boolean<bool>(_boolConverter, _presentBool),
  password<String>(_stringConverter),
  stringForeignKey<String>(_stringConverter),
  intForeignKey<int>(int.parse);

  final TypeConverter<T> converter;
  final PresentationFunction<T> presentation;

  const FieldType(this.converter, [this.presentation = _toString]);

  TextInputType? get inputType => _fieldTypesToInputTypes[this];
}

_never(_) {}

String _presentBool(b) => b as bool ? 'Так' : 'Ні';

String _stringConverter(string) => (string as String).trim();

int _currencyConverter(coins) => (double.parse(_stringConverter(coins as String)) * 100).toInt();

String _toString(d) => d.toString();

String _padWithZeros(int i) => '$i'.padLeft(2, '0');

String _presentDate(d) {
  final date = d as DateTime;

  return '${_padWithZeros(date.day)}.${_padWithZeros(date.month)}.${date.year}';
}

String _presentDateTime(d) {
  final date = d as DateTime;

  return '${_padWithZeros(date.hour)}:${_padWithZeros(date.minute)} ${_presentDate(d)}';
}

bool _boolConverter(boolStr) => (boolStr as String) == 'Так';

String _presentCurrency(coins) => ((coins as int) / 100).toStringAsFixed(2);

DateTime _dateConverter(String date) {
  final parts = date.split('.').map(int.parse).toList();
  return DateTime(parts[2], parts[1], parts[0]);
}

DateTime _dateTimeConverter(String dateStr) {
  final parts = dateStr.split(' ');
  final date = _dateConverter(parts[1]);
  final hm = parts[0].split('.').map(int.parse).toList();

  return date.copyWith(hour: hm[0], minute: hm[1]);
}

const _fieldTypesToInputTypes = <FieldType, TextInputType>{
  FieldType.number: TextInputType.number,
  FieldType.currency: TextInputType.number,
  FieldType.date: TextInputType.datetime
};
