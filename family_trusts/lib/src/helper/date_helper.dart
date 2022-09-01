import 'package:dartz/dartz.dart';
import 'package:intl/date_symbol_data_local.dart' as intl_local_date_data;
import 'package:intl/intl.dart';

const fr = "fr_FR";
const staticFr = "fr";

String getPrintableDateFromTimestamp(int timestamp) {
  intl_local_date_data.initializeDateFormatting();
  final DateTime now = DateTime.now();
  final DateTime datePost = DateTime.fromMillisecondsSinceEpoch(timestamp);

  DateFormat format;

  if (now.difference(datePost).inDays < 0) {
    format = DateFormat.yMMMd(staticFr);
    return "le ${format.format(datePost)}";
  } else if (now.difference(datePost).inDays > 0) {
    format = DateFormat.yMMMd(staticFr);
    return "le ${format.format(datePost)}";
  } else if (now.difference(datePost).inHours > 0) {
    return "il y a ${now.difference(datePost).inHours} heure(s)";
  } else if (now.difference(datePost).inMinutes > 0) {
    return "il y a ${now.difference(datePost).inMinutes} minute(s)";
  } else {
    return "à l'instant";
  }
}

String getPrintableDate(String timestamp) {
  final int timeInt = int.tryParse(timestamp) ?? 0;

  return getPrintableDateFromTimestamp(timeInt);
}

String birthdayConverterToString(DateTime date) {
  intl_local_date_data.initializeDateFormatting();
  final DateFormat format = DateFormat.yMd(staticFr);
  return format.format(date);
}

Option<DateTime> birthdayConverterToDate(String? date) {
  return parseDate(date);
}

String rendezVousConverterToString(DateTime date) {
  intl_local_date_data.initializeDateFormatting();
  final DateFormat formatDate = DateFormat.yMMMd(staticFr);
  final DateFormat formatHour = DateFormat.Hms(staticFr);

  return "le ${formatDate.format(date)} à ${formatHour.format(date)}";
}

String rendezVousConverterToHourString(DateTime date) {
  intl_local_date_data.initializeDateFormatting();
  final DateFormat formatHour = DateFormat.Hm(staticFr);

  return formatHour.format(date);
}

String getDateToString(DateTime date) {
  intl_local_date_data.initializeDateFormatting();
  final DateFormat formatDate = DateFormat.yMMMd(staticFr);

  return formatDate.format(date);
}

Option<DateTime> rendezVousConverterWithDateTimePickerToDate(String? date) {
  intl_local_date_data.initializeDateFormatting();
  final DateFormat format = DateFormat("yyyy-MM-dd HH:mm");

  try {
    return some(format.parse(date!));
  } catch (exception) {
    return none();
  }
}

Option<DateTime> rendezVousConverterToDate(String? date) {
  intl_local_date_data.initializeDateFormatting();
  final DateFormat format = DateFormat.yMd(staticFr).add_Hms();

  try {
    return some(format.parse(date!));
  } catch (exception) {
    return none();
  }
}

Option<DateTime> parseDate(String? date) {
  intl_local_date_data.initializeDateFormatting();
  final DateFormat format = DateFormat.yMd(staticFr);
  try {
    final DateTime result = format.parse(date!);
    return some(result);
  } catch (exception) {
    return none();
  }
}

String parseRdvDateTimeFromDateTime(DateTime date) {
  intl_local_date_data.initializeDateFormatting();
  final DateFormat format = DateFormat("yyyy-MM-dd HH:mm");

  return format.format(date);
}
