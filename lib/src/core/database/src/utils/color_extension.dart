import 'dart:ui';

import 'package:money_accountant/src/core/constant/item_colors.dart';
import 'package:money_accountant/src/core/database/database.dart';

extension IncomeColor on IncomeCategory {
  Color get color => CategoryColors.getIndexed(colorIndex);
}

extension ExpenseColor on ExpenseCategory {
  Color get color => CategoryColors.getIndexed(colorIndex);
}

extension AccountColor on Account {
  Color get color => CategoryColors.getIndexed(colorIndex);
}
