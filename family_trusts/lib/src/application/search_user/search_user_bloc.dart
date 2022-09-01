import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/application/search_user/bloc.dart';
import 'package:familytrusts/src/domain/auth/i_auth_facade.dart';
import 'package:familytrusts/src/domain/search_user/search_user_failure.dart';
import 'package:familytrusts/src/domain/user/i_user_repository.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/bloc_helper.dart';
import 'package:injectable/injectable.dart';
import 'package:quiver/strings.dart' as quiver;

@injectable
class SearchUserBloc extends Bloc<SearchUserEvent, SearchUserState> {
  final IUserRepository _userRepository;
  final IAuthFacade _authFacade;
  static const Duration duration = Duration(milliseconds: 500);

  SearchUserBloc(this._userRepository, this._authFacade)
      : super(SearchUserState.initial()) {
    on<UserLookupChanged>(
      _mapUserLookupChanged,
      transformer: debounce(duration),
    );
  }

  Future<FutureOr<void>> _mapUserLookupChanged(
    UserLookupChanged event,
    Emitter<SearchUserState> emit,
  ) async {
    if (quiver.isNotBlank(event.userLookupText) &&
        event.userLookupText.isNotEmpty) {
      emit(
        state.copyWith(
          searchUserFailureOrSuccessOption: none(),
          isSubmitting: true,
        ),
      );

      final String userId = _authFacade.getSignedInUserId().toNullable()!;

      final Either<SearchUserFailure, List<User>> result = await _userRepository
          .searchUsers(event.userLookupText, excludedUsers: [userId]);

      emit(
        result.fold(
          (failure) => state.copyWith(
            searchUserFailureOrSuccessOption: some(left(failure)),
            isSubmitting: false,
          ),
          (users) => state.copyWith(
            searchUserFailureOrSuccessOption: some(right(users)),
            isSubmitting: false,
          ),
        ),
      );
    }
  }
}
