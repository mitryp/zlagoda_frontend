import 'package:flutter/cupertino.dart';

List<Widget> makeSeparated(List<Widget> widgets, [int separatorWidth = 16]) {
  final nOfElements = widgets.length;

  return widgets
      .asMap()
      .entries
      .map((entry) => entry.key == nOfElements - 1
      ? [entry.value]
      : [entry.value, const SizedBox(width: 10)])
      .expand((e) => e)
      .toList();
}
