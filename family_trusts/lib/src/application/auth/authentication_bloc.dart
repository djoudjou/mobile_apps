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
    on<AuthCheckRequested>(_mapAuthCheckRequested, transformer: restartable());
    on<SignedOut>(_mapSignedOut, transformer: sequential());
  }

  FutureOr<void> _mapAuthCheckRequested(
      AuthCheckRequested event, Emitter<AuthenticationState> emit) async {
    final userOption = _authFacade.getSignedInUserId();
    emit(
      userOption.fold(
        () => const AuthenticationState.unauthenticated(),
        (userId) => AuthenticationState.authenticated(userId),
      ),
    );
  }

  FutureOr<void> _mapSignedOut(
      SignedOut event, Emitter<AuthenticationState> emit) async {
    await _authFacade.signOut();
    emit(const AuthenticationState.unauthenticated());
  }
}
