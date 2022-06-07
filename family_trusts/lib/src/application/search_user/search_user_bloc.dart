import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/auth/i_auth_facade.dart';
import 'package:familytrusts/src/domain/search_user/search_user_failure.dart';
import 'package:familytrusts/src/domain/user/i_user_repository.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:injectable/injectable.dart';
import 'package:quiver/strings.dart' as quiver;

import 'bloc.dart';

@injectable
class SearchUserBloc extends Bloc<SearchUserEvent, SearchUserState> {
  final IUserRepository _userRepository;
  final IAuthFacade _authFacade;

  SearchUserBloc(this._userRepository, this._authFacade)
      : super(SearchUserState.initial());

  @override
  Stream<SearchUserState> mapEventToState(
    SearchUserEvent event,
  ) async* {
    yield* event.map(userLookupChanged: (e) async* {
      if (quiver.isNotBlank(e.userLookupText) && e.userLookupText.isNotEmpty) {
        yield state.copyWith(
          searchUserFailureOrSuccessOption: none(),
          isSubmitting: true,
        );

        final String userId = _authFacade.getSignedInUserId().toNullable()!;

        final Either<SearchUserFailure, Stream<List<User>>> result =
            await _userRepository.searchUsers(
          e.userLookupText,
          excludedUsers: [userId],
        );

        final Option<Either<SearchUserFailure, Stream<List<User>>>>
            searchUserFailureOrSuccessOption = optionOf(result);

        yield state.copyWith(
          searchUserFailureOrSuccessOption: searchUserFailureOrSuccessOption,
          isSubmitting: false,
        );
      }
    });
  }
}
