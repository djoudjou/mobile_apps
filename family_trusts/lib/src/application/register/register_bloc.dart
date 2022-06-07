import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/domain/auth/auth_failure.dart';
import 'package:familytrusts/src/domain/auth/i_auth_facade.dart';
import 'package:familytrusts/src/domain/auth/user_info.dart';
import 'package:familytrusts/src/domain/register/register_failure.dart';
import 'package:familytrusts/src/domain/user/i_user_repository.dart';
import 'package:familytrusts/src/domain/user/user.dart' as current;
import 'package:familytrusts/src/domain/user/user_failure.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';

import 'bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> with LogMixin {
  late IAuthFacade _authFacade;
  late IUserRepository _userRepository;

  RegisterBloc() : super(RegisterState.initial()) {
    _userRepository = getIt<IUserRepository>();
    _authFacade = getIt<IAuthFacade>();
  }

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    yield* event.map(
      init: (e) async* {
        final Option<MyUserInfo> optionUserInfo =
            await _authFacade.getSignedUserInfo();

        log("optionUserInfo ===> $optionUserInfo");
        if (optionUserInfo.isSome()) {
          final MyUserInfo userInfo = optionUserInfo.toNullable()!;

          yield state.copyWith(
            registerFailureOrSuccessOption: none(),
            emailAddress: EmailAddress(userInfo.email),
            name: Name(userInfo.displayName),
            isEditEmailPwdEnabled: false,
            isInitializing: false,
            photoUrl: userInfo.photoUrl,
          );
        } else {
          yield state.copyWith(
            registerFailureOrSuccessOption: none(),
            isInitializing: false,
            isEditEmailPwdEnabled: true,
          );
        }
      },
      registerPictureChanged: (e) async* {
        yield state.copyWith(
          imagePath: e.pickedFilePath,
          registerFailureOrSuccessOption: none(),
        );
      },
      registerEmailChanged: (e) async* {
        yield state.copyWith(
          emailAddress: EmailAddress(e.email),
          registerFailureOrSuccessOption: none(),
        );
      },
      registerPasswordChanged: (e) async* {
        yield state.copyWith(
          password: Password(e.password),
          registerFailureOrSuccessOption: none(),
        );
      },
      registerNameChanged: (e) async* {
        yield state.copyWith(
          name: Name(e.name),
          registerFailureOrSuccessOption: none(),
        );
      },
      registerSurnameChanged: (e) async* {
        yield state.copyWith(
          surname: Surname(e.surname),
          registerFailureOrSuccessOption: none(),
        );
      },
      registerSubmitted: (e) async* {
        yield* _performRegister();
      },
    );
  }

  Stream<RegisterState> _performRegister() async* {
    Either<RegisterFailure, String>? registerFailureOrSuccess;

    final bool isEmailValid = state.emailAddress.isValid();
    final bool isPasswordValid = state.password.isValid();

    log("isEmailValid $isEmailValid, isPasswordValid $isPasswordValid");

    if (!state.isEditEmailPwdEnabled || (isEmailValid && isPasswordValid)) {
      yield state.copyWith(
        isSubmitting: true,
        registerFailureOrSuccessOption: none(),
      );

      Either<AuthFailure, String> authenticationFailureOrSuccess;

      if (state.isEditEmailPwdEnabled) {
        authenticationFailureOrSuccess =
            await _authFacade.registerWithEmailAndPassword(
          emailAddress: state.emailAddress,
          password: state.password,
        );
      } else {
        final String userId =
            _authFacade.getSignedInUserId().getOrElse(() => '');
        authenticationFailureOrSuccess = right(userId);
      }

      log("result authenticationFailureOrSuccess $authenticationFailureOrSuccess");
      registerFailureOrSuccess = authenticationFailureOrSuccess.fold(
          (failure) => left(
                failure.map(
                  cancelledByUser: (_) =>
                      const RegisterFailure.cancelledByUser(),
                  serverError: (_) => const RegisterFailure.serverError(),
                  emailAlreadyInUse: (_) =>
                      const RegisterFailure.emailAlreadyInUse(),
                  invalidEmailAndPasswordCombination: (_) =>
                      const RegisterFailure.emailAlreadyInUse(),
                  alreadySignWithAnotherMethod: (e) =>
                      RegisterFailure.alreadySignWithAnotherMethod(
                          e.providerName),
                ),
              ),
          (userId) => right(userId));

      if (registerFailureOrSuccess!.isRight()) {
        final String userId = registerFailureOrSuccess.toOption().toNullable()!;

        final Either<UserFailure, Unit> userFailureOrSuccess =
            await _userRepository.create(
          current.User(
            id: userId,
            email: state.emailAddress,
            name: state.name,
            surname: state.surname,
            photoUrl: state.photoUrl,
          ),
          pickedFilePath: state.imagePath,
        );

        log("_userRepository create result $userFailureOrSuccess");

        registerFailureOrSuccess = userFailureOrSuccess.fold(
          (failure) => left(const RegisterFailure.serverError()),
          (_) => right(userId),
        );
      }
    }

    log("_performRegister result $registerFailureOrSuccess");

    yield state.copyWith(
      isSubmitting: false,
      showErrorMessages: true,
      registerFailureOrSuccessOption: optionOf(registerFailureOrSuccess),
    );
  }
}
