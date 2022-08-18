import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/application/auth/sign_in_form/sign_in_form_event.dart';
import 'package:familytrusts/src/application/auth/sign_in_form/sign_in_form_state.dart';
import 'package:familytrusts/src/domain/auth/auth_failure.dart';
import 'package:familytrusts/src/domain/auth/i_auth_facade.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:familytrusts/src/helper/analytics_svc.dart';
import 'package:familytrusts/src/helper/bloc_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  final IAuthFacade _authFacade;
  final AnalyticsSvc _analyticsSvc;
  static const Duration duration = Duration(milliseconds: 500);

  SignInFormBloc(this._authFacade, this._analyticsSvc)
      : super(SignInFormState.initial()) {
    on<EmailChanged>(
      _onEmailChanged,
      transformer: debounce(duration),
    );
    on<PasswordChanged>(
      _onPasswordChanged,
      transformer: debounce(duration),
    );
    on<RegisterWithEmailAndPasswordPressed>(
      _onRegisterWithEmailAndPasswordPressed,
      transformer: restartable(),
    );
    on<SignInWithEmailAndPasswordPressed>(
      _onSignInWithEmailAndPasswordPressed,
      transformer: restartable(),
    );
    on<SignInWithGooglePressed>(
      _onSignInWithGooglePressed,
      transformer: restartable(),
    );
    on<SignInWithFacebookPressed>(
      _onSignInWithFacebookPressed,
      transformer: restartable(),
    );
  }

  FutureOr<void> _performActionOnAuthFacadeWithEmailAndPassword(
    Future<Either<AuthFailure, String>> Function({
      required EmailAddress emailAddress,
      required Password password,
    })
        forwardedCall,
    Emitter<SignInFormState> emit,
  ) async {
    Either<AuthFailure, String>? failureOrSuccess;

    final bool isEmailValid = state.emailAddress.isValid();
    final bool isPasswordValid = state.password.isValid();

    if (isEmailValid && isPasswordValid) {
      emit(
        state.copyWith(
          isSubmitting: true,
          authFailureOrSuccessOption: none(),
        ),
      );

      failureOrSuccess = await forwardedCall(
        emailAddress: state.emailAddress,
        password: state.password,
      );

      await failureOrSuccess.fold(
        (l) => null,
        (userId) => _analyticsSvc.loginWithLoginPwd(userId),
      );

      emit(
        state.copyWith(
          isSubmitting: false,
          showErrorMessages: true,
          authFailureOrSuccessOption: optionOf(failureOrSuccess),
        ),
      );
    }
  }

  FutureOr<void> _onEmailChanged(
      EmailChanged event, Emitter<SignInFormState> emit) async {
    emit(
      state.copyWith(
        emailAddress: EmailAddress(event.emailStr),
        authFailureOrSuccessOption: none(),
      ),
    );
  }

  FutureOr<void> _onPasswordChanged(
    PasswordChanged event,
    Emitter<SignInFormState> emit,
  ) async {
    emit(
      state.copyWith(
        password: Password(event.passwordStr),
        authFailureOrSuccessOption: none(),
      ),
    );
  }

  FutureOr<void> _onRegisterWithEmailAndPasswordPressed(
    RegisterWithEmailAndPasswordPressed event,
    Emitter<SignInFormState> emit,
  ) async {
    _performActionOnAuthFacadeWithEmailAndPassword(
      _authFacade.registerWithEmailAndPassword,
      emit,
    );
  }

  FutureOr<void> _onSignInWithEmailAndPasswordPressed(
    SignInWithEmailAndPasswordPressed event,
    Emitter<SignInFormState> emit,
  ) async {
    await _performActionOnAuthFacadeWithEmailAndPassword(
      _authFacade.signInWithEmailAndPassword,
      emit,
    );
  }

  FutureOr<void> _onSignInWithGooglePressed(
    SignInWithGooglePressed event,
    Emitter<SignInFormState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        authFailureOrSuccessOption: none(),
      ),
    );

    final failureOrSuccess = await _authFacade.signInWithGoogle();
    failureOrSuccess.fold(
      (l) => null,
      (userId) => _analyticsSvc.loginWithGoogle(userId),
    );

    emit(
      state.copyWith(
        isSubmitting: false,
        authFailureOrSuccessOption: some(failureOrSuccess),
      ),
    );
  }

  FutureOr<void> _onSignInWithFacebookPressed(
    SignInWithFacebookPressed event,
    Emitter<SignInFormState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        authFailureOrSuccessOption: none(),
      ),
    );

    final failureOrSuccess = await _authFacade.signInWithFacebook();
    failureOrSuccess.fold(
      (l) => null,
      (userId) => _analyticsSvc.loginWithFacebook(userId),
    );

    emit(
      state.copyWith(
        isSubmitting: false,
        authFailureOrSuccessOption: some(failureOrSuccess),
      ),
    );
  }
}
