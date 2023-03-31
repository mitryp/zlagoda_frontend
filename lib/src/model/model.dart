import 'package:flutter/material.dart';

abstract class Model {
  const Model();

  Map<String, dynamic> toJSON();

  dynamic get primaryKey;

  DataRow buildRow(BuildContext context);
}

