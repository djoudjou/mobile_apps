import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/application/family/trusted/bloc.dart';
import 'package:familytrusts/src/domain/auth/i_auth_facade.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:familytrusts/src/domain/family/trusted_user/trusted.dart';
import 'package:familytrusts/src/domain/family/trusted_user/trusted_failure.dart';
import 'package:familytrusts/src/domain/family/trusted_user/value_objects.dart';
import 'package:familytrusts/src/domain/notification/event.dart';
import 'package:familytrusts/src/domain/notification/i_notification_repository.dart';
import 'package:familytrusts/src/domain/notification/value_objects.dart';
import 'package:familytrusts/src/domain/search_user/search_user_failure.dart';
import 'package:familytrusts/src/domain/user/i_user_repository.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/user_failure.dart';
import 'package:familytrusts/src/helper/analytics_svc.dart';
import 'package:injectable/injectable.dart';
import 'package:quiver/strings.dart' as quiver;

@injectable
class TrustedUserFormBloc
    extends Bloc<TrustedUserFormEvent, TrustedUserFormState> {
  final IFamilyRepository _familyRepository;
  final IAuthFacade _authFacade;
  final IUserRepository _userRepository;
  final INotificationRepository _notificationRepository;
  final AnalyticsSvc _analyticsSvc;
  StreamSubscription? _trustedUsersSubscription;

  TrustedUserFormBloc(
    this._familyRepository,
    this._notificationRepository,
    this._authFacade,
    this._userRepository,
    this._analyticsSvc,
  ) : super(TrustedUserFormState.initial()) {
    on<TrustedUserFormEvent>(
      (event, emit) => mapEventToState(event, emit),
      transformer: sequential(),
    );
  }

  Future<void> mapEventToState(
    TrustedUserFormEvent event,
    Emitter<TrustedUserFormState> emit,
  ) async {
    event.map(
      addTrustedUser: (event) {
        _mapAddTrustedUserToState(event, emit);
      },
      //deleteTrustedUser: (event) {
      //  return _mapDeleteTrustedUserToState(event);
      //},
      userLookupChanged: (event) {
        _mapUserLookupChangedToState(event, emit);
      },
    );
  }

  FutureOr<void> _mapUserLookupChangedToState(
    UserLookupChanged event,
    Emitter<TrustedUserFormState> emit,
  ) async {
    try {
      if (quiver.isNotBlank(event.userLookupText) &&
          event.userLookupText.isNotEmpty) {
        emit(
          state.copyWith(
            state: TrustedUserFormStateEnum.searching,
            searchUserFailureOrSuccessOption: none(),
            addTrustedUserFailureOrSuccessOption: none(),
          ),
        );

        final String userId = _authFacade.getSignedInUserId().toNullable()!;

        final Either<UserFailure, List<TrustedUser>> userFailreOrTrustedUsers =
            await _familyRepository
                .getFutureTrustedUsers(event.currentUser.familyId!);
        final List<String> trustedUsersId = userFailreOrTrustedUsers.fold(
          (l) => [],
          (r) => r.map((e) => e.user.id!).toList(),
        );

        /* todo no more stream
        final Either<SearchUserFailure, Stream<List<User>>> result =
            await _userRepository.searchUsers(
          event.userLookupText,
          excludedUsers: [...trustedUsersId, userId],
        );

        emit(
          result.fold(
            (failure) {
              _analyticsSvc.debug("error during trusted user search $failure");
              return state.copyWith(
                state: TrustedUserFormStateEnum.none,
                searchUserFailureOrSuccessOption:
                    some(left(const SearchUserFailure.serverError())),
                addTrustedUserFailureOrSuccessOption: none(),
              );
            },
            (success) {
              //return TrustedUserFormState.usersLoaded(searchUserFailureOrSuccess: result);
              return state.copyWith(
                state: TrustedUserFormStateEnum.none,
                searchUserFailureOrSuccessOption: some(right(success)),
                addTrustedUserFailureOrSuccessOption: none(),
              );
            },
          ),
        );

         */
      }
    } catch (_) {
      emit(
        state.copyWith(
          state: TrustedUserFormStateEnum.none,
          searchUserFailureOrSuccessOption:
              some(left(const SearchUserFailure.serverError())),
          addTrustedUserFailureOrSuccessOption: none(),
        ),
      );
    }
  }

  FutureOr<void> _mapAddTrustedUserToState(
    AddTrustedUser event,
    Emitter<TrustedUserFormState> emit,
  ) async {
    try {
      //yield const TrustedUserFormState.addTrustedUserInProgress();
      emit(
        state.copyWith(
          state: TrustedUserFormStateEnum.adding,
          addTrustedUserFailureOrSuccessOption: none(),
        ),
      );
      final User user = event.currentUser;
      final Either<UserFailure, Unit> result =
          await _familyRepository.addTrustedUser(
        familyId: user.familyId!,
        trustedUser: TrustedUser(
          user: event.userToAdd,
          since: event.time,
        ),
      );

      emit(
        result.fold(
          (failure) {
            _analyticsSvc.debug("error during add trusted user $failure");
            return state.copyWith(
              state: TrustedUserFormStateEnum.none,
              addTrustedUserFailureOrSuccessOption:
                  some(left(const TrustedUserFailure.unableToAddTrustedUser())),
            );
          },
          (success) {
            return state.copyWith(
              state: TrustedUserFormStateEnum.none,
              addTrustedUserFailureOrSuccessOption: some(right(unit)),
            );
          },
        ),
      );

      if (result.isRight()) {
        final createTrustUserEvent = Event(
          date: event.time,
          seen: false,
          from: user,
          to: event.userToAdd,
          type: EventType.trustAdded(),
          fromConnectedUser: true,
          subject: event.userToAdd.displayName,
        );

        await _notificationRepository.createEvent(
          user.id!,
          createTrustUserEvent,
        );
        if (quiver.isNotBlank(user.spouse)) {
          await _notificationRepository.createEvent(
            user.spouse!,
            createTrustUserEvent,
          );
        }
      }
    } catch (_) {
      emit(
        state.copyWith(
          state: TrustedUserFormStateEnum.none,
          searchUserFailureOrSuccessOption: none(),
          addTrustedUserFailureOrSuccessOption:
              some(left(const TrustedUserFailure.unableToAddTrustedUser())),
        ),
      );
    }
  }

  /*
  Stream<TrustedUserFormState> _mapDeleteTrustedUserToState(
      DeleteTrustedUser event) async* {
    try {
      yield const TrustedUserFormState.deleteTrustedUserInProgress();
      final User user = event.currentUser;

      final Either<UserFailure, Unit> result =
          await _familyRepository.deleteTrustedUser(
        familyId: user.familyId!,
        trustedUser: TrustedUser(
          user: event.userToRemove,
          since: TimestampVo.now(),
        ),
      );

      yield result.fold(
        (failure) {
          _analyticsSvc.debug("error during delete trusted user $failure");
          return const TrustedUserFormState.deleteTrustedUserFailure();
        },
        (success) {
          return const TrustedUserFormState.deleteTrustedUserSuccess();
        },
      );

      if (result.isRight()) {
        final removeTrustUserEvent = Event(
          date: TimestampVo.now(),
          seen: false,
          from: user,
          to: event.userToRemove,
          type: EventType.trustRemoved(),
          fromConnectedUser: true,
          subject: '',
        );
        await _notificationRepository.createEvent(
          user.id!,
          removeTrustUserEvent,
        );

        if (quiver.isNotBlank(user.spouse)) {
          await _notificationRepository.createEvent(
            user.spouse!,
            removeTrustUserEvent,
          );
        }
      }
    } catch (_) {
      yield const TrustedUserFormState.deleteTrustedUserFailure();
    }
  }
   */

  @override
  Future<void> close() {
    _trustedUsersSubscription?.cancel();
    return super.close();
  }
}
