// Sealed class for CategoryPrototype
import 'package:flutter/material.dart';
import 'package:money_accountant/src/core/constant/item_colors.dart';
import 'package:money_accountant/src/core/constant/item_icons.dart';

sealed class CategoryPrototype {
  const CategoryPrototype({
    required this.title,
    required this.iconIndex,
    required this.colorIndex,
  });

  final String title;
  final int iconIndex;
  final int colorIndex;

  Color get color => CategoryColors.getIndexed(colorIndex);

  IconData get icon => CategoryIcons.getIndexed(iconIndex);
}

// Class for ExpensePrototype
class ExpensePrototype extends CategoryPrototype {
  const ExpensePrototype({
    required super.title,
    required super.iconIndex,
    required super.colorIndex,
    this.subcategories = const [],
  });

  final List<String> subcategories;
}

// Class for IncomePrototype
final class IncomePrototype extends CategoryPrototype {
  const IncomePrototype({
    required super.title,
    required super.iconIndex,
    required super.colorIndex,
    this.subcategories = const [],
  });

  final List<String> subcategories;
}

// Class for AccountPrototype
final class AccountPrototype extends CategoryPrototype {
  const AccountPrototype({
    required super.title,
    required super.iconIndex,
    required super.colorIndex,
    required this.amount,
  });

  final double amount;
}
