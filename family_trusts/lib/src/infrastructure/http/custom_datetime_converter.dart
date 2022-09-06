import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

class CustomDateTimeConverter implements JsonConverter<DateTime, String> {
  const CustomDateTimeConverter();

  static DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm");

  @override
  DateTime fromJson(String json) {
    if(json.length > 15) {
      final dateTime = json.substring(0,16);
      final offset = json.substring(16);
      if (offset.contains("+")) {
        return DateTime.parse(dateTime+offset.replaceFirst("+", "+"));
      } else {
        return DateTime.parse(dateTime+offset.replaceFirst("-", "-"));
      }
    } else {
      return DateTime.parse(json);
    }
  }

  @override
  String toJson(DateTime json) {
    final offset = json.timeZoneOffset;
    final hours =
        offset.inHours > 0 ? offset.inHours : 1; // For fixing divide by 0
    var offsetVal = "";
    if (!offset.isNegative) {
      offsetVal =
          "+${offset.inHours.toString().padLeft(2, '0')}${(offset.inMinutes % (hours * 60)).toString().padLeft(2, '0')}";
    } else {
      offsetVal =
          "-${(-offset.inHours).toString().padLeft(2, '0')}${(offset.inMinutes % (hours * 60)).toString().padLeft(2, '0')}";
    }
    return "${dateFormat.format(json)}$offsetVal";
  }
}
