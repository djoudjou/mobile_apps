import 'package:familytrusts/src/domain/messages/message.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'messages_event.freezed.dart';

@freezed
class MessagesEvent with _$MessagesEvent {
  const factory MessagesEvent.init() = Init;

  const factory MessagesEvent.saveToken(String userId) = SaveToken;

  const factory MessagesEvent.onMessage(Message message) = OnMessage;

  const factory MessagesEvent.onError() = OnError;
}
