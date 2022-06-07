import 'dart:async';

import 'package:dartz/dartz.dart';

import 'message.dart';
import 'messages_failure.dart';

abstract class IMessagesRepository {
  Future<Either<MessagesFailure, Unit>> init();

  Future<Either<MessagesFailure, String>> saveToken(String userId);

  Stream<Either<MessagesFailure, Message>> getMessages();

  Future<void> close();
}
