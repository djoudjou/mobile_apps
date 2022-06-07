import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:quiver/strings.dart' as quiver;

import '../bloc.dart';
import 'trusted_user_watcher_state.dart';

@injectable
class TrustedUserWatcherBloc
    extends Bloc<TrustedUserWatcherEvent, TrustedUserWatcherState> {
  final IFamilyRepository _familyRepository;
  StreamSubscription? _trustedUsersSubscription;

  TrustedUserWatcherBloc(
    this._familyRepository,
  ) : super(const TrustedUserWatcherState.trustedUsersLoading());

  @override
  Stream<TrustedUserWatcherState> mapEventToState(
    TrustedUserWatcherEvent event,
  ) async* {
    yield* event.map(
      loadTrustedUsers: (event) {
        return _mapLoadTrustedUsersToState(event);
      },
      trustedUsersUpdated: (event) {
        return _mapTrustedUsersUpdatedToState(event);
      },
    );
  }

  Stream<TrustedUserWatcherState> _mapLoadTrustedUsersToState(
      LoadTrustedUsers event) async* {
    if (quiver.isNotBlank(event.familyId)) {
      yield const TrustedUserWatcherState.trustedUsersLoading();
      _trustedUsersSubscription?.cancel();
      _trustedUsersSubscription =
          _familyRepository.getTrustedUsers(event.familyId!).listen((event) {
        add(TrustedUserWatcherEvent.trustedUsersUpdated(
            eitherTrustedUsers: event));
      }, onError: (_) {
        _trustedUsersSubscription?.cancel();
      });
    } else {
      yield const TrustedUserWatcherState.trustedUsersNotLoaded();
    }
  }

  Stream<TrustedUserWatcherState> _mapTrustedUsersUpdatedToState(
      TrustedUsersUpdated event) async* {
    yield TrustedUserWatcherState.trustedUsersLoaded(
        eitherTrustedUsers: event.eitherTrustedUsers);
  }

  @override
  Future<void> close() {
    _trustedUsersSubscription?.cancel();
    return super.close();
  }
}
