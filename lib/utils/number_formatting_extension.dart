import 'package:intl/intl.dart';

extension NumberFormatting on double? {
  String formatThousands() {
    var formatter = NumberFormat('###,###,###,###.#');
    return formatter.format(this);
  }
}
