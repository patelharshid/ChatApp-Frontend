import 'package:intl/intl.dart';

class DateUtil {
    static String formatTime(String value) {
    try {
      final DateTime dateTime = DateTime.parse(value);
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return '';
    }
  }
}
