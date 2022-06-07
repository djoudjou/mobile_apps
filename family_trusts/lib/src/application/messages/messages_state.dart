import 'package:familytrusts/src/domain/messages/message.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'messages_state.freezed.dart';

@freezed
class MessagesState with _$MessagesState {
  const factory MessagesState.initial() = MessagesInitial;
  const factory MessagesState.tokenSaved(String token) = TokenSaved;
  const factory MessagesState.messageReceived(Message message) = MessageReceived;
  const factory MessagesState.errorReceived() = ErrorReceived;
}
