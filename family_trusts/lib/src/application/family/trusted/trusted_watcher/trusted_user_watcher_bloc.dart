import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/application/family/trusted/bloc.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:familytrusts/src/domain/family/trusted_user/trusted.dart';
import 'package:familytrusts/src/domain/user/user_failure.dart';
import 'package:injectable/injectable.dart';
import 'package:quiver/strings.dart' as quiver;

@injectable
class TrustedUserWatcherBloc
    extends Bloc<TrustedUserWatcherEvent, TrustedUserWatcherState> {
  final IFamilyRepository _familyRepository;

  TrustedUserWatcherBloc(
    this._familyRepository,
  ) : super(const TrustedUserWatcherState.trustedUsersLoading()) {
    on<LoadTrustedUsers>(
      _mapLoadTrustedUsersToState,
      transformer: sequential(),
    );
  }

  Future<void> _mapLoadTrustedUsersToState(
    LoadTrustedUsers event,
    Emitter<TrustedUserWatcherState> emit,
  ) async {
    if (quiver.isNotBlank(event.familyId)) {
      emit(const TrustedUserWatcherState.trustedUsersLoading());

      final Either<UserFailure, List<TrustedUser>> result =
          await _familyRepository.getFutureTrustedUsers(event.familyId!);

      emit(
        result.fold(
          (failure) => TrustedUserWatcherState.trustedUsersLoaded(
            eitherTrustedUsers: left(failure),
          ),
          (trusted) => TrustedUserWatcherState.trustedUsersLoaded(
            eitherTrustedUsers: right(trusted),
          ),
        ),
      );
    } else {
      emit(const TrustedUserWatcherState.trustedUsersNotLoaded());
    }
  }
}
