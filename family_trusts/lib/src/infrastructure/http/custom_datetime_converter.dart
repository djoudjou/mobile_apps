import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

class CustomDateTimeConverter implements JsonConverter<DateTime, String> {
  const CustomDateTimeConverter();

  @override
  DateTime fromJson(String json) {
    final DateFormat format = DateFormat("dd/MM/yyyy HH:mm:ss");
    return format.parse(json.split(".").first);
  }

  @override
  String toJson(DateTime json) => json.toIso8601String();
}