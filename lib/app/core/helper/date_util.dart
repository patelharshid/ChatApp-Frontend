import 'package:chatapp/app/core/utils/app_constants.dart';
import 'package:intl/intl.dart';

class DateUtil {
  static String dateFormat(String value) {
    try {
      final DateTime dateTime = DateTime.parse(value);

      final DateFormat formatter = DateFormat(AppConstants.dateFormat);
      return formatter.format(dateTime);
    } on FormatException catch (e) {
      print('Error parsing date: $e');
      return 'Invalid Date';
    }
  }
}
