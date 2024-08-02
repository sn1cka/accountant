import 'dart:async';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_accountant/src/core/database/database.dart';
import 'package:money_accountant/src/core/database/src/app_database.dart';
import 'package:money_accountant/src/feature/dashboard/category_prototype.dart';

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
  const factory AccountantEvent.databaseChanged({
    List<ExpenseCategory>? expenseCategories,
    List<IncomeCategory>? incomeCategories,
    List<Account>? accounts,
    double? totalIncome,
    double? totalExpense,
  }) = _DatabaseChanged;

  const factory AccountantEvent.createCategory({
    required CategoryPrototype prototype,
  }) = _CreateCategory;

  const factory AccountantEvent.editCategory({
    required int id,
    required CategoryPrototype prototype,
  }) = _EditCategory;

  const factory AccountantEvent.deleteCategory({
    required int id,
    required CategoryPrototype type,
  }) = _DeleteCategory;
}

class AccountantBloc extends Bloc<AccountantEvent, AccountantState> {
  final AppDatabase _db;
  late final StreamSubscription<List<IncomeCategory>> _incomeCategoriesStream;
  late final StreamSubscription<List<ExpenseCategory>> _expenseCategoriesStream;
  late final StreamSubscription<List<Account>> _accountsStream;

  AccountantBloc({required AppDatabase dataBase})
      : _db = dataBase,
        super(
          const AccountantState.idle(
            expenseCategories: [],
            incomeCategories: [],
            accounts: [],
            totalIncome: 0,
            totalExpense: 0,
          ),
        ) {
    _initListeners();
    on<_DatabaseChanged>(_databaseChanged);
    on<_CreateCategory>(_createCategory);
    on<_EditCategory>(_editCategory);
    on<_DeleteCategory>(_deleteCategory);
  }

  @override
  Future<void> close() {
    _incomeCategoriesStream.cancel();
    _expenseCategoriesStream.cancel();
    _accountsStream.cancel();
    return super.close();
  }

  Future<void> _initListeners() async {
    _incomeCategoriesStream = _db.incomeCategories
        .all()
        .watch()
        .listen((incomes) => add(AccountantEvent.databaseChanged(incomeCategories: incomes)));

    _expenseCategoriesStream = _db.expenseCategories
        .all()
        .watch()
        .listen((expenses) => add(AccountantEvent.databaseChanged(expenseCategories: expenses)));

    _accountsStream =
        _db.accounts.all().watch().listen((accounts) => add(AccountantEvent.databaseChanged(accounts: accounts)));
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

  Future<void> _createCategory(_CreateCategory event, Emitter<AccountantState> emit) async {
    final item = event.prototype;
    switch (item) {
      case ExpensePrototype():
        await _db.expenseCategories.insert().insert(
              ExpenseCategoriesCompanion.insert(
                title: item.title,
                iconIndex: item.iconIndex,
                colorIndex: item.colorIndex,
              ),
            );
      case IncomePrototype():
        await _db.incomeCategories.insert().insert(
              IncomeCategoriesCompanion.insert(
                title: item.title,
                iconIndex: item.iconIndex,
                colorIndex: item.colorIndex,
              ),
            );
      case AccountPrototype():
        await _db.accounts.insert().insert(
              AccountsCompanion.insert(
                title: item.title,
                iconIndex: item.iconIndex,
                colorIndex: item.colorIndex,
                amount: item.amount,
              ),
            );
    }
  }

  Future<void> _editCategory(_EditCategory event, Emitter<AccountantState> emit) async {
    final item = event.prototype;

    switch (item) {
      case ExpensePrototype():
        final updateStatement = _db.expenseCategories.update();
        updateStatement.where((tbl) => tbl.id.equals(event.id));
        await updateStatement.write(
          ExpenseCategoriesCompanion.insert(
            title: item.title,
            iconIndex: item.iconIndex,
            colorIndex: item.colorIndex,
          ),
        );
      case IncomePrototype():
        final updateStatement = _db.incomeCategories.update();
        updateStatement.where((tbl) => tbl.id.equals(event.id));
        await updateStatement.write(
          IncomeCategoriesCompanion.insert(
            title: item.title,
            iconIndex: item.iconIndex,
            colorIndex: item.colorIndex,
          ),
        );

      case AccountPrototype():
        final updateStatement = _db.accounts.update();
        updateStatement.where((tbl) => tbl.id.equals(event.id));
        await updateStatement.write(
          AccountsCompanion.insert(
            title: item.title,
            iconIndex: item.iconIndex,
            colorIndex: item.colorIndex,
            amount: item.amount,
          ),
        );
    }
  }

  Future<void> _deleteCategory(_DeleteCategory event, Emitter<AccountantState> emit) async {
    switch (event.type) {
      case ExpensePrototype():
        await (_db.expenseCategories.delete()..where((tbl) => tbl.id.equals(event.id))).go();
      case IncomePrototype():
        await (_db.incomeCategories.delete()..where((tbl) => tbl.id.equals(event.id))).go();
      case AccountPrototype():
        await (_db.accounts.delete()..where((tbl) => tbl.id.equals(event.id))).go();
    }
  }
}
