import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_accountant/src/core/constant/item_colors.dart';
import 'package:money_accountant/src/core/constant/item_icons.dart';
import 'package:money_accountant/src/core/ui_kit/icon_card.dart';
import 'package:money_accountant/src/feature/dashboard/dashboard_bloc.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<AccountantBloc, AccountantState>(
        builder: (context, state) => Scaffold(
          body: ListView.builder(
            itemCount: state.incomeCategories.length,
            itemBuilder: (context, index) {
              final item = state.incomeCategories[index];
              return Column(
                children: [
                  CategoryCard(
                    color: CategoryColors.getIndexed(item.colorIndex),
                    icon: Icon(CategoryIcons.getIndexed(item.iconIndex)),
                  ),
                  Text(item.title),
                ],
              );
            },
          ),
        ),
      );
}
