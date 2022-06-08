import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:familytrusts/src/application/auth/authentication_event.dart';
import 'package:familytrusts/src/application/auth/authentication_state.dart';
import 'package:familytrusts/src/domain/auth/i_auth_facade.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final IAuthFacade _authFacade;

  AuthenticationBloc(this._authFacade)
      : super(const AuthenticationState.initial()) {
    on<AuthenticationEvent>(
      (event, emit) => mapEventToState(event, emit),
      transformer: restartable(),
    );
  }

  Future<void> mapEventToState(
    AuthenticationEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    event.map(
      authCheckRequested: (e) {
        final userOption = _authFacade.getSignedInUserId();
        emit(
          userOption.fold(
            () => const AuthenticationState.unauthenticated(),
            (userId) => AuthenticationState.authenticated(userId),
          ),
        );
      },
      signedOut: (e) async {
        await _authFacade.signOut();
        emit(const AuthenticationState.unauthenticated());
      },
    );
  }
}
