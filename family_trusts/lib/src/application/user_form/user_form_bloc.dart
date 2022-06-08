import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/application/user_form/bloc.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:familytrusts/src/domain/family/trusted_user/trusted.dart';
import 'package:familytrusts/src/domain/user/i_user_repository.dart';
import 'package:familytrusts/src/domain/user/submit_user_failure.dart';
import 'package:familytrusts/src/domain/user/untrust_user_failure.dart';
import 'package:familytrusts/src/domain/user/user_failure.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:familytrusts/src/helper/analytics_svc.dart';
import 'package:familytrusts/src/helper/bloc_helper.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:injectable/injectable.dart';
import 'package:quiver/strings.dart' as quiver;

@injectable
class UserFormBloc extends Bloc<UserFormEvent, UserFormState> with LogMixin {
  final IUserRepository _userRepository;
  final IFamilyRepository _familyRepository;
  final AnalyticsSvc _analyticsSvc;
  static const Duration duration = Duration(milliseconds: 500);

  UserFormBloc(
    this._userRepository,
    this._analyticsSvc,
    this._familyRepository,
  ) : super(UserFormState.initial()) {
    on<UserFormEvent>(
      (event, emit) => mapEventToState(event, emit),
      transformer: debounce(duration),
    );
  }

  void mapEventToState(
    UserFormEvent event,
    Emitter<UserFormState> emit,
  ) {
    event.map(
      init: (e) {
        _initialize(e, emit);
      },
      pictureChanged: (e) {
        emit(
          state.copyWith(
            imagePath: e.pickedFilePath,
          ),
        );
      },
      nameChanged: (e) {
        emit(
          state.copyWith(
            name: Name(e.name),
          ),
        );
      },
      surnameChanged: (e) {
        emit(
          state.copyWith(
            surname: Surname(e.surname),
          ),
        );
      },
      userSubmitted: (e) {
        _performSubmit(e, emit);
      },
      userUntrusted: (e) {
        _performUntrust(e, emit);
      },
    );
  }

  FutureOr<void> _initialize(
    Init e,
    Emitter<UserFormState> emit,
  ) async {
    emit(
      state.copyWith(
        status: UserFormStateEnum.initializing,
      ),
    );

    final bool submitUserEnable =
        quiver.equalsIgnoreCase(e.userToEdit.id, e.connectedUser.id);

    bool? unTrustUserEnable = false;

    if (e.connectedUser.familyId != null &&
        e.userToEdit.id != e.connectedUser.id &&
        e.userToEdit.id != e.connectedUser.spouse) {
      final Either<UserFailure, List<TrustedUser>> getFutureTrustedUsersResult =
          await _familyRepository
              .getFutureTrustedUsers(e.connectedUser.familyId!);
      final List<TrustedUser>? trustedUsers =
          getFutureTrustedUsersResult.toOption().toNullable();
      if (trustedUsers != null) {
        unTrustUserEnable =
            trustedUsers.map((e) => e.user.id!).contains(e.userToEdit.id);
      }
    }

    final bool disconnectUserEnable = quiver.isNotBlank(e.userToEdit.spouse) &&
        !quiver.equalsIgnoreCase(e.userToEdit.id, e.connectedUser.id) &&
        quiver.equalsIgnoreCase(e.userToEdit.id, e.connectedUser.spouse);

    emit(
      state.copyWith(
        status: UserFormStateEnum.none,
        emailAddress: e.userToEdit.email,
        surname: e.userToEdit.surname,
        name: e.userToEdit.name,
        imagePath: e.userToEdit.photoUrl,
        submitUserEnable: submitUserEnable,
        unTrustUserEnable: unTrustUserEnable,
        disconnectUserEnable: disconnectUserEnable,
      ),
    );
  }

  FutureOr<void> _performSubmit(
    UserSubmitted e,
    Emitter<UserFormState> emit,
  ) async {
    final bool isValid = e.user.failureOption.isNone();

    if (isValid) {
      emit(
        state.copyWith(
          status: UserFormStateEnum.submiting,
          submitUserFailureOrSuccessOption: none(),
        ),
      );

      final Either<UserFailure, Unit> updateResult = await _userRepository
          .update(e.user, pickedFilePath: e.pickedFilePath);

      emit(
        updateResult.fold(
          (l) {
            _analyticsSvc.debug("unable to update user ${e.user} > $l");
            return state.copyWith(
              status: UserFormStateEnum.none,
              submitUserFailureOrSuccessOption:
                  some(left(const SubmitUserFailure.unableToSubmitUser())),
            );
          },
          (r) => state.copyWith(
            status: UserFormStateEnum.none,
            submitUserFailureOrSuccessOption: some(right(unit)),
          ),
        ),
      );
    }
  }

  FutureOr<void> _performUntrust(
    UserUntrusted e,
    Emitter<UserFormState> emit,
  ) async {
    if (quiver.isNotBlank(e.connectedUser.familyId)) {
      emit(
        state.copyWith(
          status: UserFormStateEnum.unTrusting,
          unTrustUserFailureOrSuccessOption: none(),
        ),
      );

      final Either<UserFailure, Unit> unTrustUserResult =
          await _familyRepository.deleteTrustedUser(
        familyId: e.connectedUser.familyId!,
        trustedUserId: e.user.id!,
      );

      emit(
        unTrustUserResult.fold(
          (l) {
            _analyticsSvc.debug("unable to untrust user ${e.user} > $l");
            return state.copyWith(
              status: UserFormStateEnum.none,
              unTrustUserFailureOrSuccessOption:
                  some(left(const UnTrustUserFailure.unableToUnTrust())),
            );
          },
          (r) => state.copyWith(
            status: UserFormStateEnum.none,
            unTrustUserFailureOrSuccessOption: some(right(unit)),
          ),
        ),
      );
    }
  }
}
