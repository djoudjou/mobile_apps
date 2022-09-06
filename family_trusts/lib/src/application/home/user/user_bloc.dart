import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/application/home/user/bloc.dart';
import 'package:familytrusts/src/domain/auth/i_auth_facade.dart';
import 'package:familytrusts/src/domain/messages/i_messages_repository.dart';
import 'package:familytrusts/src/domain/messages/messages_failure.dart';
import 'package:familytrusts/src/domain/user/i_user_repository.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/user_failure.dart';
import 'package:quiver/strings.dart' as quiver;

class UserBloc extends Bloc<UserEvent, UserState> {
  final IAuthFacade _authFacade;
  final IUserRepository _userRepository;
  final IMessagesRepository _messagesRepository;

  UserBloc(
    this._authFacade,
    this._userRepository,
    this._messagesRepository,
  ) : super(const UserState.userInitial()) {
    on<Init>(_onInit);
    on<UserStarted>(
      _onUserStarted,
    );
    on<UserReceived>(
      _onUserReceived,
    );
    on<UserSubmitted>(
      _onUserSubmitted,
    );
  }

  FutureOr<void> _onInit(Init event, Emitter<UserState> emit) {
    add(UserEvent.userStarted(event.connectedUserId));
  }

  Future<FutureOr<void>> _onUserStarted(
    UserStarted event,
    Emitter<UserState> emit,
  ) async {
    emit(UserState.userLoadInProgress(event.userId));

    final Either<UserFailure, User> result =
        await _userRepository.getUser(event.userId);

    if (result.isRight()) {
      final Either<MessagesFailure, String> resultSaveToken = await _messagesRepository.saveToken(event.userId);
    }

    add(UserEvent.userReceived(result));
  }

  Future<FutureOr<void>> _onUserReceived(
    UserReceived event,
    Emitter<UserState> emit,
  ) async {
    if (event.failureOrUser.isLeft()) {
      final bool userNotFound = event.failureOrUser.fold(
        (userFailure) => userFailure.maybeMap(
          unknownUser: (_) => true,
          orElse: () => false,
        ),
        (r) => false,
      );

      _authFacade.signOut();

      if (userNotFound) {
        emit(const UserState.userNotFound());
      } else {
        emit(
          UserState.userLoadFailure(
            event.failureOrUser.fold(
              (l) => l.toString(),
              (r) => 'Cas impossible',
            ),
          ),
        );
      }
    } else {
      final User user = event.failureOrUser.toOption().toNullable()!;

      if (quiver.isNotBlank(user.spouse)) {
        final Either<UserFailure, User?> eitherSpouse =
            await _userRepository.getUser(user.spouse!);

        emit(
          eitherSpouse.fold(
            (userFailure) {
              return userFailure.map(
                unexpected: (error) =>
                    UserState.userLoadFailure(error.toString()),
                insufficientPermission: (error) =>
                    UserState.userLoadFailure(error.toString()),
                unknownUser: (error) =>
                    UserState.userLoadFailure(error.toString()),
                unableToUpdate: (error) =>
                    UserState.userLoadFailure(error.toString()),
              );
            },
            (spouse) => UserState.userLoadSuccess(
              user: user,
              spouse: spouse,
            ),
          ),
        );
      } else {
        emit(
          UserState.userLoadSuccess(
            user: user,
          ),
        );
      }
    }
  }

  Future<FutureOr<void>> _onUserSubmitted(
    UserSubmitted event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoadInProgress(event.user.id!));
    final Either<UserFailure, Unit> result = await _userRepository.update(
      event.user,
      pickedFilePath: event.pickedFilePath,
    );

    result.fold(
      (userFailure) {
        emit(UserState.userLoadFailure(userFailure.toString()));
      },
      (_) {
        add(UserEvent.userStarted(event.user.id!));
      },
    );
  }

  @override
  Future<void> close() async {
    await super.close();
  }
}
