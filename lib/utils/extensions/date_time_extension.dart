import 'package:intl/intl.dart';

extension NumberFormaterExtension on int {
  String get price {
    return NumberFormat('#,###,###,###').format(this);
  }
}

String pointsFormatter(inputPoint) {
  return NumberFormat("#,###,###,###.##").format(inputPoint).toString();
}

String bounzPointsFormatter(inputPoint) {
  return NumberFormat("#,###,###,###").format(inputPoint).toString();
}

extension DateTimeFormater on DateTime {
  String get dmyFormat {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  String get dateTimeWithTZFormat {
    return DateFormat('yyyy-MM-ddTHH:mm:ssZ').format(this);
  }

  String get ymddateFormat {
    return DateFormat('E, dd MMM yyyy').format(this);
  }

  String get monthName {
    return DateFormat('MMMM yyyy').format(this);
  }

  String get ymddateFormatWithoutDay {
    return DateFormat('dd MMM yyyy').format(this);
  }
}

List<Map<String, dynamic>> getMonthsInYear() {
  DateTime userCreatedDate = DateTime.now();
  List<Map<String, dynamic>> dates = [];
  final now = DateTime.now();
  final sixMonthFromNow = DateTime(now.year, now.month - 6);
  DateTime date = userCreatedDate;

  while (date.isAfter(sixMonthFromNow)) {
    dates.add({
      'title': date.month == now.month ? 'This Month' : date.monthName,
      'month': date.month.toString() + ", " + date.year.toString(),
    });
    date = DateTime(date.year, date.month - 1);
  }
  return dates;
}
