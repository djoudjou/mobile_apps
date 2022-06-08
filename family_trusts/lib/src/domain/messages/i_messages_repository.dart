import 'dart:async';

import 'package:dartz/dartz.dart';

import 'package:familytrusts/src/domain/messages/message.dart';
import 'package:familytrusts/src/domain/messages/messages_failure.dart';

abstract class IMessagesRepository {
  Future<Either<MessagesFailure, Unit>> init();

  Future<Either<MessagesFailure, String>> saveToken(String userId);

  Stream<Either<MessagesFailure, Message>> getMessages();

  Future<void> close();
}
