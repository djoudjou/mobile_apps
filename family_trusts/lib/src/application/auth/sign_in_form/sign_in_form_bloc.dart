import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/application/auth/sign_in_form/sign_in_form_event.dart';
import 'package:familytrusts/src/application/auth/sign_in_form/sign_in_form_state.dart';
import 'package:familytrusts/src/domain/auth/auth_failure.dart';
import 'package:familytrusts/src/domain/auth/i_auth_facade.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:familytrusts/src/helper/analytics_svc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  final IAuthFacade _authFacade;
  final AnalyticsSvc _analyticsSvc;

  SignInFormBloc(this._authFacade, this._analyticsSvc)
      : super(SignInFormState.initial()) {
    on<SignInFormEvent>(
      (event, emit) => mapEventToState(event, emit),
      transformer: restartable(),
    );
  }

  Future<void> mapEventToState(
    SignInFormEvent event,
    Emitter<SignInFormState> emit,
  ) async {
    event.map(
      emailChanged: (e) {
        emit(
          state.copyWith(
            emailAddress: EmailAddress(e.emailStr),
            authFailureOrSuccessOption: none(),
          ),
        );
      },
      passwordChanged: (e) {
        emit(
          state.copyWith(
            password: Password(e.passwordStr),
            authFailureOrSuccessOption: none(),
          ),
        );
      },
      registerWithEmailAndPasswordPressed: (e) {
        _performActionOnAuthFacadeWithEmailAndPassword(
          _authFacade.registerWithEmailAndPassword,
          emit,
        );
      },
      signInWithEmailAndPasswordPressed: (e) async* {
        _performActionOnAuthFacadeWithEmailAndPassword(
          _authFacade.signInWithEmailAndPassword,
          emit,
        );
      },
      signInWithGooglePressed: (e) async* {
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
      },
      signInWithFacebookPressed: (SignInWithFacebookPressed value) async* {
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
      },
    );
  }

  Future<void> _performActionOnAuthFacadeWithEmailAndPassword(
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

      failureOrSuccess.fold(
        (l) => null,
        (userId) => _analyticsSvc.loginWithLoginPwd(userId),
      );
    }

    emit(
      state.copyWith(
        isSubmitting: false,
        showErrorMessages: true,
        authFailureOrSuccessOption: optionOf(failureOrSuccess),
      ),
    );
  }
}
