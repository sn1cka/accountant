import 'dart:math';

import 'package:flutter/material.dart';

/// Util class for colors of  ExpenseCategory and IncomeCategory
abstract final class CategoryColors {
  /// Returns random [Color] from predefined list [colors]
  static Color get random => colors[Random().nextInt(length)];

  /// Returns [Color] predefined in list
  static Color getIndexed(int index) {
    assert(index >= 0 && index < length, 'Color index in getIndexed is $index and out of range 0..${length-1}');
    return colors[index];
  }

  /// Count of colors
  static int get length => colors.length;

  /// The first index of element in this list.
  /// return -1 if value not found
  static int indexOf(Color icon) => colors.indexOf(icon);

  /// All available colors for ExpenseCategory and IncomeCategory
  static const colors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.black,
    Colors.white,
    Colors.indigoAccent,
  ];
}
