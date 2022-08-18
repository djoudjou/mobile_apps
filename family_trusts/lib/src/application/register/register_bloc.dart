import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/application/register/bloc.dart';
import 'package:familytrusts/src/domain/auth/auth_failure.dart';
import 'package:familytrusts/src/domain/auth/i_auth_facade.dart';
import 'package:familytrusts/src/domain/auth/user_info.dart';
import 'package:familytrusts/src/domain/register/register_failure.dart';
import 'package:familytrusts/src/domain/user/i_user_repository.dart';
import 'package:familytrusts/src/domain/user/user.dart' as backend_user;
import 'package:familytrusts/src/domain/user/user_failure.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:injectable/injectable.dart';

@injectable
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> with LogMixin {
  final IAuthFacade _authFacade;
  final IUserRepository _userRepository;

  RegisterBloc(this._userRepository, this._authFacade)
      : super(RegisterState.initial()) {
    on<Init>(_mapInit, transformer: sequential());
    on<RegisterEmailChanged>(
      _mapRegisterEmailChanged,
      transformer: sequential(),
    );
    on<RegisterPasswordChanged>(
      _mapRegisterPasswordChanged,
      transformer: sequential(),
    );
    on<RegisterNameChanged>(_mapRegisterNameChanged, transformer: sequential());
    on<RegisterSurnameChanged>(
      _mapRegisterSurnameChanged,
      transformer: sequential(),
    );
    on<RegisterSubmitted>(_mapRegisterSubmitted, transformer: sequential());
    on<RegisterPictureChanged>(
      _mapRegisterPictureChanged,
      transformer: sequential(),
    );
  }

  FutureOr<void> _mapInit(
    Init event,
    Emitter<RegisterState> emit,
  ) async {
    final Option<MyUserInfo> optionUserInfo =
        await _authFacade.getSignedUserInfo();

    log("optionUserInfo ===> $optionUserInfo");
    if (optionUserInfo.isSome()) {
      final MyUserInfo userInfo = optionUserInfo.toNullable()!;

      emit(
        state.copyWith(
          registerFailureOrSuccessOption: none(),
          emailAddress: EmailAddress(userInfo.email),
          name: Name(userInfo.displayName),
          isEditEmailPwdEnabled: false,
          isInitializing: false,
          photoUrl: userInfo.photoUrl,
        ),
      );
    } else {
      emit(
        state.copyWith(
          registerFailureOrSuccessOption: none(),
          isInitializing: false,
          isEditEmailPwdEnabled: true,
        ),
      );
    }
  }

  FutureOr<void> _mapRegisterEmailChanged(
    RegisterEmailChanged event,
    Emitter<RegisterState> emit,
  ) async {
    emit(
      state.copyWith(
        emailAddress: EmailAddress(event.email),
        registerFailureOrSuccessOption: none(),
      ),
    );
  }

  FutureOr<void> _mapRegisterPasswordChanged(
    RegisterPasswordChanged event,
    Emitter<RegisterState> emit,
  ) async {
    emit(
      state.copyWith(
        password: Password(event.password),
        registerFailureOrSuccessOption: none(),
      ),
    );
  }

  FutureOr<void> _mapRegisterNameChanged(
    RegisterNameChanged event,
    Emitter<RegisterState> emit,
  ) async {
    emit(
      state.copyWith(
        name: Name(event.name),
        registerFailureOrSuccessOption: none(),
      ),
    );
  }

  FutureOr<void> _mapRegisterSurnameChanged(
    RegisterSurnameChanged event,
    Emitter<RegisterState> emit,
  ) async {
    emit(
      state.copyWith(
        surname: Surname(event.surname),
        registerFailureOrSuccessOption: none(),
      ),
    );
  }

  FutureOr<void> _mapRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    if (validInputsBeforeRegister()) {
      emit(
        state.copyWith(
          isSubmitting: true,
          registerFailureOrSuccessOption: none(),
        ),
      );

      final Either<AuthFailure, String> eitherFailureOrUserId =
          await doRegisterNewUserOrGetConnectedUser();

      Either<RegisterFailure, String>? registerFailureOrSuccess =
          eitherFailureOrUserId.fold(
        (failure) => left(mapRegisterFailureToErrorMessage(failure)),
        (userId) => right(userId),
      );

      if (registerFailureOrSuccess!.isRight()) {
        registerFailureOrSuccess = await doCreateUserInBackend(
          registerFailureOrSuccess.toOption().toNullable()!,
        );
      }
      log("_performRegister result $registerFailureOrSuccess");

      emit(
        state.copyWith(
          isSubmitting: false,
          showErrorMessages: true,
          registerFailureOrSuccessOption: optionOf(registerFailureOrSuccess),
        ),
      );
    }
  }

  FutureOr<void> _mapRegisterPictureChanged(
    RegisterPictureChanged event,
    Emitter<RegisterState> emit,
  ) async {
    emit(
      state.copyWith(
        imagePath: event.pickedFilePath,
        registerFailureOrSuccessOption: none(),
      ),
    );
  }

  RegisterFailure mapRegisterFailureToErrorMessage(AuthFailure failure) {
    return failure.map(
      cancelledByUser: (_) => const RegisterFailure.cancelledByUser(),
      serverError: (_) => const RegisterFailure.serverError(),
      emailAlreadyInUse: (_) => const RegisterFailure.emailAlreadyInUse(),
      invalidEmailAndPasswordCombination: (_) =>
          const RegisterFailure.emailAlreadyInUse(),
      alreadySignWithAnotherMethod: (e) =>
          RegisterFailure.alreadySignWithAnotherMethod(
        e.providerName,
      ),
    );
  }

  Future<Either<RegisterFailure, String>> doCreateUserInBackend(
    String userId,
  ) async {
       final backend_user.User user = backend_user.User(
      id: userId,
      email: state.emailAddress,
      name: state.name,
      surname: state.surname,
      photoUrl: state.photoUrl,
    );

    final Either<UserFailure, Unit> createUserFailureOrSuccess =
        await _userRepository.create(
      user,
      pickedFilePath: state.imagePath,
    );


    log("_userRepository create result $createUserFailureOrSuccess");

    final Either<RegisterFailure, String> registerFailureOrSuccess =
        createUserFailureOrSuccess.fold(
      (failure) => left(const RegisterFailure.serverError()),
      (_) => right(userId),
    );
    return registerFailureOrSuccess;
  }

  Future<Either<AuthFailure, String>>
      doRegisterNewUserOrGetConnectedUser() async {
    Either<AuthFailure, String> eitherFailureOrUserId;
    if (state.isEditEmailPwdEnabled) {
      eitherFailureOrUserId = await _authFacade.registerWithEmailAndPassword(
        emailAddress: state.emailAddress,
        password: state.password,
      );
    } else {
      final String userId = _authFacade.getSignedInUserId().getOrElse(() => '');
      eitherFailureOrUserId = right(userId);
    }
    log("result eitherFailureOrUserId $eitherFailureOrUserId");
    return eitherFailureOrUserId;
  }

  bool validInputsBeforeRegister() {
    final bool isEmailValid = state.emailAddress.isValid();
    final bool isPasswordValid = state.password.isValid();

    log("isEmailValid $isEmailValid, isPasswordValid $isPasswordValid");
    return !state.isEditEmailPwdEnabled || (isEmailValid && isPasswordValid);
  }
}
