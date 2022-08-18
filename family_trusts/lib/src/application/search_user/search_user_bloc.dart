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
    on<SearchUserEvent>(
      (event, emit) => mapEventToState(event, emit),
      transformer: debounce(duration),
    );
  }

  void mapEventToState(
    SearchUserEvent event,
    Emitter<SearchUserState> emit,
  ) {
    event.map(
      userLookupChanged: (e) async {
        if (quiver.isNotBlank(e.userLookupText) &&
            e.userLookupText.isNotEmpty) {
          emit(
            state.copyWith(
              searchUserFailureOrSuccessOption: none(),
              isSubmitting: true,
            ),
          );

          final String userId = _authFacade.getSignedInUserId().toNullable()!;

          /* todo plus de stream
          final Either<SearchUserFailure, Stream<List<User>>> result =
              await _userRepository.searchUsers(
            e.userLookupText,
            excludedUsers: [userId],
          );

          final Option<Either<SearchUserFailure, Stream<List<User>>>>
              searchUserFailureOrSuccessOption = optionOf(result);

          emit(
            state.copyWith(
              searchUserFailureOrSuccessOption:
                  searchUserFailureOrSuccessOption,
              isSubmitting: false,
            ),
          );

           */
        }
      },
    );
  }
}
