import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_accountant/src/core/database/database.dart';
import 'package:money_accountant/src/core/database/src/utils/color_extension.dart';
import 'package:money_accountant/src/core/database/src/utils/icon_extension.dart';
import 'package:money_accountant/src/core/ui_kit/dashboard_item.dart';
import 'package:money_accountant/src/feature/category_edit/category_prototype_screen.dart';
import 'package:money_accountant/src/feature/dashboard/category_prototype.dart';
import 'package:money_accountant/src/feature/dashboard/dashboard_bloc.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _pushDialog(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      CupertinoPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => screen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<AccountantBloc, AccountantState>(
        builder: (context, state) => Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Incomes'),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 12,
                      runSpacing: 20,
                      children: [
                        ...state.incomeCategories.map(
                          (item) => DashBoardItem(
                            onTap: () {
                              // _pushDialog(context, EditCategoryScreen)
                            },
                            data: item,
                            title: item.title,
                            color: item.color,
                            child: Icon(item.icon),
                          ),
                        ),
                        _AddItem(
                          onTap: () => _pushDialog(
                            context,
                            PrototypeScreen.createIncomeCategory(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Accounts'),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 12,
                      runSpacing: 20,
                      children: [
                        ...state.accounts.map(
                          (item) => DashBoardItem<Account, IncomeCategory>(
                            onAccept: (data) {},
                            data: item,
                            subtitle: item.amount.toStringAsFixed(2).replaceAll('.00', ''),
                            title: item.title,
                            color: item.color,
                            child: Icon(item.icon),
                          ),
                        ),
                        _AddItem(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (context) => PrototypeScreen.createAccount(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Expenses'),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 12,
                      runSpacing: 20,
                      children: [
                        ...state.expenseCategories.map(
                          (item) => DashBoardItem<ExpenseCategory, Account>(
                            onAccept: (data) {},
                            onTap: () {
                              _pushDialog(
                                context,
                                PrototypeScreen.edit(
                                  prototype: ExpensePrototype(
                                    iconIndex: item.iconIndex,
                                    title: item.title,
                                    colorIndex: item.colorIndex,
                                    subcategories: [],
                                  ),
                                  id: item.id,
                                ),
                              );
                            },
                            title: item.title,
                            color: item.color,
                            child: Icon(item.icon),
                          ),
                        ),
                        _AddItem(
                          onTap: () => _pushDialog(
                            context,
                            PrototypeScreen.createExpenseCategory(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}

class _AddItem extends StatelessWidget {
  const _AddItem({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => DashBoardItem(
        color: Colors.blueGrey,
        onTap: onTap,
        child: const Icon(Icons.add),
      );
}
