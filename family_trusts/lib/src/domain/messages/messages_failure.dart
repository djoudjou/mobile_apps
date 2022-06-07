import 'package:freezed_annotation/freezed_annotation.dart';

part 'messages_failure.freezed.dart';

@freezed
abstract class MessagesFailure with _$MessagesFailure {
  const factory MessagesFailure.serverError() = ServerError;
}
