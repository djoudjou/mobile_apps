import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/core/value_objects.dart';
import 'package:familytrusts/src/domain/error/i_error_service.dart';
import 'package:familytrusts/src/domain/messages/i_messages_repository.dart';
import 'package:familytrusts/src/domain/messages/message.dart';
import 'package:familytrusts/src/domain/messages/messages_failure.dart';
import 'package:familytrusts/src/domain/user/i_user_repository.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:familytrusts/src/infrastructure/messages/message_entity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton(as: IMessagesRepository)
class FirebaseMessagesRepository with LogMixin implements IMessagesRepository {
  final FirebaseMessaging _firebaseMessaging;
  final IErrorService _errorService;
  final IUserRepository _userRepository;
  final StreamController<Either<MessagesFailure, Message>> controller =
      StreamController<Either<MessagesFailure, Message>>();

  FirebaseMessagesRepository(
    this._firebaseMessaging,
    this._errorService,
    this._userRepository,
  );

  @override
  Stream<Either<MessagesFailure, Message>> getMessages() {
    return controller.stream.onErrorReturnWith((e, stacktrace) {
      _errorService.logException(e, stackTrace: stacktrace);
      return left(const MessagesFailure.serverError());
    });
  }

  @override
  Future<Either<MessagesFailure, Unit>> init() async {
    try {
      final NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: false,
        provisional: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          log("onMessage: $message");
          final RemoteNotification? notification = message.notification;
          addMessage("onMessage", notification);
        }

            // FirebaseMessaging.onMessageOpenedApp.listen((event) {
            //   log("onMessage: $event");
            //   addMessage("onMessage", event.data);
            // })

            /*M05034
          _firebaseMessaging.configure(
          onMessage: (Map<String, dynamic> message) async {
            log("onMessage: $message");
            addMessage("onMessage", message);
          },
          onLaunch: (Map<String, dynamic> message) async {
            log("onLaunch: $message");
            addMessage("onLaunch", message);
          },
          onResume: (Map<String, dynamic> message) async {
            log("onResume: $message");
            addMessage("onResume", message);
          },
          onBackgroundMessage: (Map<String, dynamic> message) async {
            log("onBackgroundMessage: $message");
            addMessage("onBackgroundMessage", message);
          },
          */
            );
      }

      return right(unit);
    } catch (e) {
      _errorService.logError("Unable to init messages handler > $e");
      return left(const MessagesFailure.serverError());
    }
  }

  void addMessage(String from, RemoteNotification? notification) {
    final MessageEntity me = MessageEntity.fromData(notification);
    controller.add(
      right(
        Message(
          date: TimestampVo.now(),
          title: me.title,
          body: me.body,
        ),
      ),
    );
  }

  @override
  Future<Either<MessagesFailure, String>> saveToken(String userId) async {
    try {
      final String token = (await _firebaseMessaging.getToken())!;

      final result = await _userRepository.saveToken(userId, token);

      return result.fold(
        (failure) {
          _errorService.logError("Unable to save token for user '$userId'");
          return left(const MessagesFailure.serverError());
        },
        (_) => right(token),
      );
    } catch (e) {
      _errorService.logError("Unable to save token for user $userId > $e");
      return left(const MessagesFailure.serverError());
    }
  }

  @override
  Future<void> close() async {
    await controller.close();
  }
}
