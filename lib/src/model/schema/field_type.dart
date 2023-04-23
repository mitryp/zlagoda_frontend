import 'package:flutter/material.dart';

typedef TypeConverter<T> = T Function(String);
typedef PresentationFunction<T> = String Function(T);

enum FieldType<T> {
  auto<dynamic>(_never),
  serializable<dynamic>(_never),
  text<String>(_stringConverter),
  number<int>(int.parse),
  currency<int>(_currencyConverter, _presentCurrency),
  date<DateTime>(_parseDate, _presentDate),
  constrainedToEnum<dynamic>(_never),
  foreignKey<dynamic>(_never);

  final TypeConverter<T> converter;
  final PresentationFunction<T> presentation;

  const FieldType(this.converter, [this.presentation = _toString]);

  TextInputType? get inputType => _fieldTypesToInputTypes[this];
}

_never(_) {}

String _stringConverter(string) => (string as String).trim();

int _currencyConverter(coins) => (double.parse(_stringConverter(coins as String)) * 100).toInt();

String _toString(d) => d.toString();

String _presentDate(d) {
  String padWithZeros(int i) => '$i'.padLeft(2, '0');
  final date = d as DateTime;

  return '${padWithZeros(date.day)}.${padWithZeros(date.month)}.${date.year}';
}

String _presentCurrency(coins) => ((coins as int) / 100).toStringAsFixed(2);

DateTime _parseDate(String date) {
  final parts = date.split('.').map(int.parse).toList();
  return DateTime(parts[2], parts[1], parts[0]);
}

const _fieldTypesToInputTypes = <FieldType, TextInputType>{
  FieldType.number: TextInputType.number,
  FieldType.currency: TextInputType.number,
  FieldType.date: TextInputType.datetime
};