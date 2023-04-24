import 'package:flutter/cupertino.dart';

List<Widget> makeSeparated(List<Widget> widgets, [int separatorWidth = 16]) {
  final nOfElements = widgets.length;

  return widgets
      .asMap()
      .entries
      .map((entry) => entry.key == nOfElements - 1
          ? entry.value
          : Row(children: [entry.value, const SizedBox(width: 10)]))
      .toList();
}
