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
import 'package:familytrusts/src/domain/search_user/search_user_failure.dart';
import 'package:familytrusts/src/domain/user/i_user_repository.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/user_failure.dart';
import 'package:familytrusts/src/helper/analytics_svc.dart';
import 'package:familytrusts/src/helper/bloc_helper.dart';
import 'package:injectable/injectable.dart';
import 'package:quiver/strings.dart' as quiver;

@injectable
class TrustedUserFormBloc
    extends Bloc<TrustedUserFormEvent, TrustedUserFormState> {
  final IFamilyRepository _familyRepository;
  final IAuthFacade _authFacade;
  final IUserRepository _userRepository;
  final AnalyticsSvc _analyticsSvc;

  TrustedUserFormBloc(
    this._familyRepository,
    this._authFacade,
    this._userRepository,
    this._analyticsSvc,
  ) : super(TrustedUserFormState.initial()) {
    on<UserLookupChanged>(
      _mapUserLookupChangedToState,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
    on<AddTrustedUser>(_mapAddTrustedUserToState, transformer: sequential());
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

        final Either<UserFailure, List<TrustedUser>> userFailureOrTrustedUsers =
            await _familyRepository
                .getFutureTrustedUsers(event.currentUser.family!.id!);
        final List<String> trustedUsersId = userFailureOrTrustedUsers.fold(
          (l) => [],
          (r) => r.map((e) => e.user.id!).toList(),
        );

        final Either<SearchUserFailure, List<User>> result =
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
        familyId: user.family!.id!,
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
}
