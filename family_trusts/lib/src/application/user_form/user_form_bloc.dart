import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/application/user_form/bloc.dart';
import 'package:familytrusts/src/domain/family/family_failure.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:familytrusts/src/domain/user/i_user_repository.dart';
import 'package:familytrusts/src/domain/user/submit_user_failure.dart';
import 'package:familytrusts/src/domain/user/user_failure.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:familytrusts/src/helper/analytics_svc.dart';
import 'package:familytrusts/src/helper/bloc_helper.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:quiver/strings.dart' as quiver;

class UserFormBloc extends Bloc<UserFormEvent, UserFormState> with LogMixin {
  final IUserRepository _userRepository;
  final IFamilyRepository _familyRepository;
  final AnalyticsSvc _analyticsSvc;
  static const Duration duration = Duration(milliseconds: 500);

  UserFormBloc(
    this._userRepository,
    this._familyRepository,
    this._analyticsSvc,
  ) : super(UserFormState.initial()) {
    on<Init>(_initialize, transformer: sequential());
    on<LeaveFamily>(_mapLeaveFamily, transformer: sequential());
    on<NameChanged>(_mapNameChanged, transformer: debounce(duration));
    on<SurnameChanged>(_mapSurnameChanged, transformer: debounce(duration));
    on<PictureChanged>(_mapPictureChanged, transformer: sequential());
    on<UserSubmitted>(_performSubmit, transformer: sequential());
  }

  FutureOr<void> _mapLeaveFamily(
    LeaveFamily event,
    Emitter<UserFormState> emit,
  ) async {
    emit(
      state.copyWith(
        status: UserFormStateEnum.submiting,
        submitUserFailureOrSuccessOption: none(),
      ),
    );

    final Either<FamilyFailure, Unit> result = await _familyRepository
        .removeMember(userId: event.connectedUser.id!, family: event.family);

    emit(
      result.fold(
        (l) {
          _analyticsSvc
              .debug("unable to leave family ${event.family.displayName} > $l");
          return state.copyWith(
            status: UserFormStateEnum.none,
            submitUserFailureOrSuccessOption: none(),
            leaveFamilyFailureOrSuccessOption: some(left(l)),
          );
        },
        (r) => state.copyWith(
          status: UserFormStateEnum.none,
          submitUserFailureOrSuccessOption: none(),
          leaveFamilyFailureOrSuccessOption: some(right(unit)),
        ),
      ),
    );
  }

  FutureOr<void> _mapNameChanged(
    NameChanged event,
    Emitter<UserFormState> emit,
  ) {
    emit(
      state.copyWith(
        name: Name(event.name),
      ),
    );
  }

  FutureOr<void> _mapSurnameChanged(
    SurnameChanged event,
    Emitter<UserFormState> emit,
  ) {
    emit(
      state.copyWith(
        surname: Surname(event.surname),
      ),
    );
  }

  FutureOr<void> _mapPictureChanged(
    PictureChanged event,
    Emitter<UserFormState> emit,
  ) {
    emit(
      state.copyWith(
        imagePath: event.pickedFilePath,
      ),
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
}
