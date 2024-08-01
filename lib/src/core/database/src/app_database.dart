import 'package:drift/drift.dart';
import 'package:money_accountant/src/core/database/database.dart';
import 'package:money_accountant/src/core/database/src/converters/datetime_converter.dart';

part 'app_database.g.dart';

/// {@template app_database}
/// The drift-managed database configuration
/// {@endtemplate}
@DriftDatabase(include: {'tables.drift'})
class AppDatabase extends _$AppDatabase {
  /// {@macro app_database}
  AppDatabase([QueryExecutor? executor]) : super(executor ?? createExecutor());

  @override
  int get schemaVersion => 1;

  /// returns sum of amount in transactions like expense or income
  Future<double> getMonthlySumFromTable({
    required TableInfo<Table, dynamic> table,
    required DateTime month,
  }) async {
    const amount = 'total_amount';

    final startOfMonthMillis = DateTime(month.year, month.month).millisecondsSinceEpoch;
    final endOfMonthMillis = DateTime(month.year, month.month + 1).millisecondsSinceEpoch;

    final result = await customSelect(
      'SELECT SUM(amount) AS $amount FROM ${table.actualTableName} WHERE date BETWEEN ? AND ?',
      variables: [Variable<int>(startOfMonthMillis), Variable<int>(endOfMonthMillis)],
    ).getSingle();

    return (result.data[amount] as double?) ?? 0.0;
  }
}
