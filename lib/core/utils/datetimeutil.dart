import 'package:intl/intl.dart';

/// Converts the provided DateTime to a string in 'yyyyMMddHHmmss' format
String convertDateToTimestampString(DateTime date) {
  final formatter = DateFormat('yyyyMMddHHmmss');
  return formatter.format(date);
}
