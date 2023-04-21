import 'package:flutter/material.dart';

typedef TypeConverter<T> = T Function(String);
typedef PresentationFunction<T> = String Function(T);

enum FieldType<T> {
  auto<dynamic>(_never),
  text<String>(_stringConverter),
  number<int>(int.parse),
  currency<int>(_currencyConverter, _presentCurrency),
  date<DateTime>(DateTime.parse, _presentDate),
  constrainedToEnum<dynamic>(_never),
  foreignKey<dynamic>(_never);

  final TypeConverter<T> converter;
  final PresentationFunction<T> presentation;

  const FieldType(this.converter, [this.presentation = _toString]);

  TextInputType? get inputType => _fieldTypesToInputTypes[this];
}

_never(_) {}

String _stringConverter(String string) => string.trim();

int _currencyConverter(String coins) => (double.parse(_stringConverter(coins)) * 100).toInt();

String _toString(d) => d.toString();

String _presentDate(DateTime date) => '${date.day}.${date.month}.${date.year}';

String _presentCurrency(int coins) => (coins / 100).toStringAsFixed(2);

const _fieldTypesToInputTypes = <FieldType, TextInputType>{
  FieldType.number: TextInputType.number,
  FieldType.currency: TextInputType.number,
  FieldType.date: TextInputType.datetime
};
