// Package imports:
import 'package:intl/intl.dart';

import '../../generated/l10n.dart';

String formatStringToDateView(timestamp) {
  if (timestamp != "") {
    DateTime dateTime = DateTime.parse(timestamp);
    var date = DateFormat('dd-MM-yyyy').format(dateTime);

    DateTime now = DateTime.now();
    var currentDate = DateFormat('dd-MM-yyyy').format(now);

    DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
    var yesterdayDate = DateFormat('dd-MM-yyyy').format(yesterday);

    print(yesterdayDate);

    if (date == currentDate) {
      return DateFormat('HH:mm').format(dateTime);
    } else if (date == yesterdayDate) {
      return "Ieri";
    } else if (date != currentDate) {
      return DateFormat('dd/MM/yy').format(yesterday).toString();
    }
  }
  return "";
}

String formatDateToDateView(DateTime dateTime) {
  var date = DateFormat('dd-MM-yyyy').format(dateTime);

  DateTime now = DateTime.now();
  var currentDate = DateFormat('dd-MM-yyyy').format(now);

  DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
  var yesterdayDate = DateFormat('dd-MM-yyyy').format(yesterday);

  //print(yesterdayDate);

  if (date == currentDate) {
    return DateFormat('HH:mm').format(dateTime);
  } else if (date == yesterdayDate) {
    return DateTime.now().subtract(const Duration(days: 1)) as String;
  } else if (date != currentDate) {
    return DateFormat('dd/MM/yy').format(dateTime).toString();
  }

  return "";
}
