import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:familytrusts/src/application/family/trusted/bloc.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:quiver/strings.dart' as quiver;

@injectable
class TrustedUserWatcherBloc
    extends Bloc<TrustedUserWatcherEvent, TrustedUserWatcherState> {
  final IFamilyRepository _familyRepository;
  StreamSubscription? _trustedUsersSubscription;

  TrustedUserWatcherBloc(
    this._familyRepository,
  ) : super(const TrustedUserWatcherState.trustedUsersLoading()) {
    on<TrustedUserWatcherEvent>(
      (event, emit) => mapEventToState(event, emit),
      transformer: sequential(),
    );
  }

  void mapEventToState(
    TrustedUserWatcherEvent event,
    Emitter<TrustedUserWatcherState> emit,
  ) {
    event.map(
      loadTrustedUsers: (event) {
        _mapLoadTrustedUsersToState(event, emit);
      },
      trustedUsersUpdated: (event) {
        _mapTrustedUsersUpdatedToState(event, emit);
      },
    );
  }

  void _mapLoadTrustedUsersToState(
    LoadTrustedUsers event,
    Emitter<TrustedUserWatcherState> emit,
  ) {
    if (quiver.isNotBlank(event.familyId)) {
      emit(const TrustedUserWatcherState.trustedUsersLoading());

    /*
      TODO ADJ no more stream

      _trustedUsersSubscription?.cancel();
      _trustedUsersSubscription =
          _familyRepository.getTrustedUsers(event.familyId!).listen(
        (event) {
          add(
            TrustedUserWatcherEvent.trustedUsersUpdated(
              eitherTrustedUsers: event,
            ),
          );
        },
        onError: (_) {
          _trustedUsersSubscription?.cancel();
        },
      );

     */
    } else {
      emit(const TrustedUserWatcherState.trustedUsersNotLoaded());
    }
  }

  void _mapTrustedUsersUpdatedToState(
    TrustedUsersUpdated event,
    Emitter<TrustedUserWatcherState> emit,
  ) {
    emit(
      TrustedUserWatcherState.trustedUsersLoaded(
        eitherTrustedUsers: event.eitherTrustedUsers,
      ),
    );
  }

  @override
  Future<void> close() {
    _trustedUsersSubscription?.cancel();
    return super.close();
  }
}
