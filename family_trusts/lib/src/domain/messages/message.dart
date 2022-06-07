import 'package:familytrusts/src/domain/core/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';

@freezed
abstract class Message implements _$Message {
  const Message._(); // Added constructor

  const factory Message({
    required TimestampVo date,
    required String title,
    required String body,
  }) = _Message;
}
