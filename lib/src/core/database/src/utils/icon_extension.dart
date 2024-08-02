import 'package:flutter/cupertino.dart';
import 'package:money_accountant/src/core/constant/item_icons.dart';
import 'package:money_accountant/src/core/database/database.dart';

extension AccountIcon on Account {
  IconData get icon => CategoryIcons.getIndexed(iconIndex);
}

extension ExpenseIcon on ExpenseCategory {
  IconData get icon => CategoryIcons.getIndexed(iconIndex);
}

extension IncomeIcon on IncomeCategory {
  IconData get icon => CategoryIcons.getIndexed(iconIndex);
}
