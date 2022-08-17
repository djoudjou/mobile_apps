import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/application/home/user/bloc.dart';
import 'package:familytrusts/src/domain/invitation/i_spouse_proposal_repository.dart';
import 'package:familytrusts/src/domain/invitation/invitation.dart';
import 'package:familytrusts/src/domain/invitation/invitation_failure.dart';
import 'package:familytrusts/src/domain/user/i_user_repository.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/user_failure.dart';
import 'package:injectable/injectable.dart';
import 'package:quiver/strings.dart' as quiver;

@injectable
class UserBloc extends Bloc<UserEvent, UserState> {
  final IUserRepository _userRepository;
  final ISpouseProposalRepository _spouseProposalRepository;

  //final AnalyticsSvc _analyticsSvc;

  StreamSubscription? _userSubscription;

  UserBloc(
    this._userRepository,
    this._spouseProposalRepository,
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

  @override
  Future<void> close() async {
    _userSubscription?.cancel();
    await super.close();
  }

  FutureOr<void> _onInit(Init event, Emitter<UserState> emit) {
    add(UserEvent.userStarted(event.connectedUserId));
  }

  FutureOr<void> _onUserStarted(UserStarted event, Emitter<UserState> emit) {
    emit(UserState.userLoadInProgress(event.userId));

    _userSubscription?.cancel();
    _userSubscription = _userRepository.watchUser(event.userId).listen(
          (failureOrUser) => add(UserEvent.userReceived(failureOrUser)),
          onError: (_) => _userSubscription?.cancel(),
        );
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

      //_crashlytics.setUserEmail(user.email.getOrCrash());
      //_crashlytics.setUserName(user.displayName);
      //_crashlytics.setUserIdentifier(user.id);

      Invitation? spouseProposal;

      final Either<InvitationFailure, Invitation?> eitherSpouseProposal =
          await _spouseProposalRepository.getSpouseProposal(user.id!);

      eitherSpouseProposal.fold(
        (invitationFailure) {
          emit(
            invitationFailure.map(
              unexpected: (error) =>
                  UserState.userLoadFailure(error.toString()),
              insufficientPermission: (error) =>
                  UserState.userLoadFailure(error.toString()),
              unableToUpdate: (error) =>
                  UserState.userLoadFailure(error.toString()),
              unknownUser: (error) =>
                  UserState.userLoadFailure(error.toString()),
            ),
          );
        },
        (invitation) {
          spouseProposal = invitation;
        },
      );

      User? spouse;
      Either<UserFailure, User?> eitherSpouse;

      if (quiver.isNotBlank(user.spouse)) {
        eitherSpouse = await _userRepository.getUser(user.spouse!);

        eitherSpouse.fold(
          (userFailure) {
            emit(
              userFailure.map(
                unexpected: (error) =>
                    UserState.userLoadFailure(error.toString()),
                insufficientPermission: (error) =>
                    UserState.userLoadFailure(error.toString()),
                unknownUser: (error) =>
                    UserState.userLoadFailure(error.toString()),
                unableToUpdate: (error) =>
                    UserState.userLoadFailure(error.toString()),
              ),
            );
          },
          (user) => spouse = user,
        );
      } else {
        eitherSpouse = right(null);
      }

      if (eitherSpouseProposal.isRight() && eitherSpouse.isRight()) {
        emit(
          UserState.userLoadSuccess(
            user: user,
            spouseProposal: spouseProposal,
            spouse: spouse,
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
}
