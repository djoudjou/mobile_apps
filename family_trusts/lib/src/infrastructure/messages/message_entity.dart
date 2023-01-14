import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_entity.freezed.dart';

@freezed
abstract class MessageEntity implements _$MessageEntity {
  const MessageEntity._(); // Added constructor
  const factory MessageEntity({
    required String title,
    required String body,
  }) = _MessageEntity;

  factory MessageEntity.fromData(RemoteNotification? notification) {
    return MessageEntity(
      title: notification!.title!,
      body: notification.body!,
    );
  }
}
