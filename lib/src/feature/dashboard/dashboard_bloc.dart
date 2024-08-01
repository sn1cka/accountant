import 'dart:async';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_accountant/src/core/database/database.dart';

part 'dashboard_bloc.freezed.dart';

@freezed
class AccountantState with _$AccountantState {
  const AccountantState._();

  const factory AccountantState.idle({
    required List<ExpenseCategory> expenseCategories,
    required List<IncomeCategory> incomeCategories,
    required List<Account> accounts,
    required double totalIncome,
    required double totalExpense,
  }) = _Idle;

  double get accountSum => accounts.fold<double>(0, (previousValue, element) => previousValue + element.amount);
}

@freezed
class AccountantEvent with _$AccountantEvent {
  const factory AccountantEvent._databaseChanged({
    List<ExpenseCategory>? expenseCategories,
    List<IncomeCategory>? incomeCategories,
    List<Account>? accounts,
    double? totalIncome,
    double? totalExpense,
  }) = _DatabaseChanged;
}

class AccountantBloc extends Bloc<AccountantEvent, AccountantState> {
  final AppDatabase _db;
  late final StreamSubscription<List<IncomeCategory>> _incomeCategoriesStream;
  late final StreamSubscription<List<ExpenseCategory>> _expenseCategoriesStream;
  late final StreamSubscription<List<Account>> _accountsStream;

  AccountantBloc({required AppDatabase dataBase})
      : _db = dataBase,
        super(const AccountantState.idle(
          expenseCategories: [],
          incomeCategories: [],
          accounts: [],
          totalIncome: 0,
          totalExpense: 0,
        )) {
    _initListeners();
    on<_DatabaseChanged>(_databaseChanged);
  }

  @override
  Future<void> close() {
    _incomeCategoriesStream.cancel();
    _expenseCategoriesStream.cancel();
    _accountsStream.cancel();
    return super.close();
  }

  Future<void> _initListeners() async {
    _incomeCategoriesStream = _db.incomeCategories.all().watch().listen(
          (incomes) => add(
            AccountantEvent._databaseChanged(
              incomeCategories: incomes,
            ),
          ),
        );

    _expenseCategoriesStream = _db.expenseCategories.all().watch().listen(
          (expenses) => add(
            AccountantEvent._databaseChanged(expenseCategories: expenses),
          ),
        );

    _accountsStream = _db.accounts.all().watch().listen(
          (accounts) => add(
            AccountantEvent._databaseChanged(accounts: accounts),
          ),
        );
  }

  Future<void> _databaseChanged(_DatabaseChanged event, Emitter<AccountantState> emit) async {
    final month = DateTime.now();
    final totalIncome = event.totalIncome ?? await _db.getMonthlySumFromTable(table: _db.incomes, month: month);
    final totalExpense = event.totalExpense ?? await _db.getMonthlySumFromTable(table: _db.expenses, month: month);

    emit(
      state.copyWith(
        incomeCategories: event.incomeCategories ?? state.incomeCategories,
        accounts: event.accounts ?? state.accounts,
        expenseCategories: event.expenseCategories ?? state.expenseCategories,
        totalExpense: totalExpense,
        totalIncome: totalIncome,
      ),
    );
  }
}
