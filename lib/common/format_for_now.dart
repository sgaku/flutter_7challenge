import 'package:intl/intl.dart';

String formatForNow() {
  DateTime now = DateTime.now();
  DateFormat outputFormat = DateFormat('yyyy-MM-dd');
  return outputFormat.format(now);
}
