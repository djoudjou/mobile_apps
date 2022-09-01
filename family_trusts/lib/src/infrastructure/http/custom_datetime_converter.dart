import 'package:json_annotation/json_annotation.dart';

class CustomDateTimeConverter implements JsonConverter<DateTime, String> {
  const CustomDateTimeConverter();

  @override
  DateTime fromJson(String json) {
    if (json.contains("+")) {
      return DateTime.parse(json.replaceFirst("+", "-"));
    } else {
      return DateTime.parse(json.replaceFirst("-", "+"));
    }
  }

  @override
  String toJson(DateTime json) => json.toIso8601String();
}
