import 'package:intl/intl.dart';

abstract class DateTimeParse {
  /// Parse Date/Time String - Return Custom Date/Time String
  static parseDateTimeReturnDateString(String dateTimeString) {
    var dateTime = DateTime.parse(dateTimeString).toLocal();
    String dateString = DateFormat('d/M/y').format(dateTime);
    return dateString;
  }

  /// Parse Date/Time String - Return Custom Date/Time String
  static parseDateTimeReturnMonthString(String dateTimeString) {
    var dateTime = DateTime.parse(dateTimeString).toLocal();
    String dateString = DateFormat('MMM - y').format(dateTime);
    return dateString;
  }
}
