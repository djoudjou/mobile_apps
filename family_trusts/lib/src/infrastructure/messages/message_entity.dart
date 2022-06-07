import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_entity.freezed.dart';

@freezed
abstract class MessageEntity implements _$MessageEntity {
  const MessageEntity._(); // Added constructor
  const factory MessageEntity({
    required String title,
    required String body,
  }) = _MessageEntity;

  factory MessageEntity.fromData(Map<String, dynamic> data) {
    return MessageEntity(
      title:data['notification']['title'] as String,
      body:data['notification']['body'] as String,
    );
  }
}
