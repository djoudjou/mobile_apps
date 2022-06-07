import 'package:dartz/dartz.dart';
import 'package:intl/date_symbol_data_local.dart' as intl_local_date_data;
import 'package:intl/intl.dart';

class DateHelper {
  static const FR = "fr_FR";
  static const staticFr = "fr";

  static String getPrintableDateFromTimestamp(int timestamp) {
    intl_local_date_data.initializeDateFormatting();
    final DateTime now = DateTime.now();
    final DateTime datePost = DateTime.fromMillisecondsSinceEpoch(timestamp);

    DateFormat format;

    if (now.difference(datePost).inDays > 0) {
      format = DateFormat.yMMMd(DateHelper.staticFr);
      return "le ${format.format(datePost).toString()}";
    } else if (now.difference(datePost).inHours > 0) {
      return "il y a ${now.difference(datePost).inHours} heure(s)";
    } else if (now.difference(datePost).inMinutes > 0) {
      return "il y a ${now.difference(datePost).inMinutes} minute(s)";
    } else {
      return "à l'instant";
    }
  }

  static String getPrintableDate(String timestamp) {
    final int timeInt = int.tryParse(timestamp) ?? 0;

    return getPrintableDateFromTimestamp(timeInt);
  }

  static String birthdayConverterToString(DateTime date) {
    intl_local_date_data.initializeDateFormatting();
    final DateFormat format = DateFormat.yMd(DateHelper.staticFr);
    return format.format(date).toString();
  }

  static Option<DateTime> birthdayConverterToDate(String? date) {
    return parseDate(date);
  }

  static String rendezVousConverterToString(DateTime date) {
    intl_local_date_data.initializeDateFormatting();
    final DateFormat formatDate = DateFormat.yMMMd(DateHelper.staticFr);
    final DateFormat formatHour = DateFormat.Hms(DateHelper.staticFr);

    return "le ${formatDate.format(date)} à ${formatHour.format(date)}";
  }

  static String rendezVousConverterToHourString(DateTime date) {
    intl_local_date_data.initializeDateFormatting();
    final DateFormat formatHour = DateFormat.Hm(DateHelper.staticFr);

    return formatHour.format(date);
  }

  static String getDateToString(DateTime date) {
    intl_local_date_data.initializeDateFormatting();
    final DateFormat formatDate = DateFormat.yMMMd(DateHelper.staticFr);

    return formatDate.format(date);
  }

  static Option<DateTime> rendezVousConverterWithDateTimePickerToDate(String? date) {
    intl_local_date_data.initializeDateFormatting();
    final DateFormat format = DateFormat("yyyy-MM-dd HH:mm");

    try {
      return some(format.parse(date!));
    } catch (exception) {
      return none();
    }
  }

  static Option<DateTime> rendezVousConverterToDate(String? date) {
    intl_local_date_data.initializeDateFormatting();
    final DateFormat format = DateFormat.yMd(DateHelper.staticFr).add_Hms();

    try {
      return some(format.parse(date!));
    } catch (exception) {
      return none();
    }
  }

  static Option<DateTime> parseDate(String? date) {
    intl_local_date_data.initializeDateFormatting();
    final DateFormat format = DateFormat.yMd(DateHelper.staticFr);
    try {
      final DateTime result = format.parse(date!);
      return some(result);
    } catch (exception) {
      return none();
    }
  }

  static String parseRdvDateTimeFromDateTime(DateTime date) {
    intl_local_date_data.initializeDateFormatting();
    final DateFormat format = DateFormat("yyyy-MM-dd HH:mm");

    return format.format(date);
  }
}
