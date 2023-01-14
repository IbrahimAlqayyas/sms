import 'package:intl/intl.dart';

abstract class DateTimeParse {
  /// Parse Date/Time String - Return Date/Time
  static parseDateTimeReturnDateTime(String dateTimeString) {
    var dateTime = DateTime.parse(dateTimeString).toLocal();
    return '$dateTime';
  }

  /// Parse Date/Time String - Return Custom Date/Time String
  static parseDateTimeReturnDateTimeString(String dateTimeString) {
    var dateTime = DateTime.parse(dateTimeString).toLocal();
    String dateString = DateFormat('d/M/y').format(dateTime);
    String timeString = DateFormat('hh:mm a').format(dateTime);
    return '$dateString  $timeString';
  }

  /// Parse Date/Time String - Return Custom Date/Time String
  static parseDateTimeReturnDateString(String dateTimeString) {
    var dateTime = DateTime.parse(dateTimeString).toLocal();
    String dateString = DateFormat('d/M/y').format(dateTime);
    return dateString;
  }

  /// Parse Date/Time - Return Description (today, yesterday .. etc)
  // static parseDateTimeReturnDescriptionString(String dateTimeString) {
  //   DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
  //
  //   bool dateEqualToday = DateTime.now().difference(dateTime).inDays == 0;
  //   bool dateDifferFromTodayByLessThanFiveDays = DateTime.now().difference(dateTime).inDays <= 5;
  //   // print('Difference: ${DateTime.now().difference(dateTime).inDays}');
  //
  //   if (dateEqualToday) {
  //     return activeLocale == SupportedLocales.arabic ? 'هذا اليوم' : 'Today';
  //   } else if (dateDifferFromTodayByLessThanFiveDays) {
  //     int diff = DateTime.now().difference(dateTime).inDays;
  //     if (diff == 1) return activeLocale == SupportedLocales.arabic ? 'أمس' : 'Yesterday';
  //     if (diff == 2) return activeLocale == SupportedLocales.arabic ? 'منذ يومين' : '2 days ago';
  //     return activeLocale == SupportedLocales.arabic
  //         ? 'منذ ${diff} أيام'
  //         : '${diff} days ago';
  //   } else {
  //     String dateString = DateFormat('d/M/y').format(dateTime);
  //     String timeString = DateFormat('hh:mm a').format(dateTime);
  //     return '$dateString  $timeString';
  //   }
  // }
}
