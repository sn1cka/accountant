import 'package:drift/drift.dart';

/// Converter for DateTime mapped from database
class DateTimeConverter extends TypeConverter<DateTime, int> {
  /// Converter for DateTime mapped from database
  const DateTimeConverter();

  @override
  DateTime fromSql(int fromDb) => DateTime.fromMillisecondsSinceEpoch(fromDb);

  @override
  int toSql(DateTime value) => value.millisecondsSinceEpoch;
}
