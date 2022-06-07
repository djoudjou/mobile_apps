import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:familytrusts/src/domain/auth/i_auth_facade.dart';
import 'package:injectable/injectable.dart';

import 'authentication_event.dart';
import 'authentication_state.dart';

@injectable
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final IAuthFacade _authFacade;

  AuthenticationBloc(this._authFacade)
      : super(const AuthenticationState.initial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    yield* event.map(
      authCheckRequested: (e) async* {
        final userOption = _authFacade.getSignedInUserId();
        yield userOption.fold(
          () => const AuthenticationState.unauthenticated(),
          (userId) => AuthenticationState.authenticated(userId),
        );
      },
      signedOut: (e) async* {
        await _authFacade.signOut();
        yield const AuthenticationState.unauthenticated();
      },
    );
  }
}
