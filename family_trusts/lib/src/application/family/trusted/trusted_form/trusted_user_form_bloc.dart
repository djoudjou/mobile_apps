import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/application/family/trusted/bloc.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:familytrusts/src/domain/family/trusted_user/trusted_failure.dart';
import 'package:familytrusts/src/domain/family/trusted_user/value_objects.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:familytrusts/src/helper/analytics_svc.dart';
import 'package:familytrusts/src/helper/bloc_helper.dart';
import 'package:injectable/injectable.dart';
import 'package:quiver/strings.dart' as quiver;

@injectable
class TrustedUserFormBloc
    extends Bloc<TrustedUserFormEvent, TrustedUserFormState> {
  final IFamilyRepository _familyRepository;
  final AnalyticsSvc _analyticsSvc;
  static const Duration duration = Duration(milliseconds: 500);

  TrustedUserFormBloc(
    this._familyRepository,
    this._analyticsSvc,
  ) : super(TrustedUserFormState.initial()) {
    on<Init>(_initialize, transformer: sequential());
    on<RemoveTrustedUser>(_mapRemoveTrustedUser, transformer: sequential());
    on<LastNameChanged>(_mapLastNameChanged, transformer: debounce(duration));
    on<FirstNameChanged>(_mapFirstNameChanged, transformer: debounce(duration));
    on<PhoneNumberChanged>(
      _mapPhoneNumberChanged,
      transformer: debounce(duration),
    );
    on<PictureChanged>(_mapPictureChanged, transformer: sequential());
    on<Submitted>(_performSubmit, transformer: sequential());
  }

  FutureOr<void> _mapRemoveTrustedUser(
    RemoveTrustedUser event,
    Emitter<TrustedUserFormState> emit,
  ) async {
    emit(
      state.copyWith(
        status: TrustedUserFormStateEnum.removing,
        submitTrustedUserFailureOrSuccessOption: none(),
        removeTrustedUserFailureOrSuccessOption: none(),
      ),
    );

    final Either<TrustedUserFailure, Unit> result =
        await _familyRepository.deleteTrustedUser(
      familyId: event.familyId,
      trustedUserId: event.trustedUserId,
    );

    emit(
      result.fold(
        (failure) {
          _analyticsSvc.debug(
            "unable to remove trust person ${event.trustedUserId} > $failure",
          );
          return state.copyWith(
            status: TrustedUserFormStateEnum.none,
            submitTrustedUserFailureOrSuccessOption: none(),
            removeTrustedUserFailureOrSuccessOption: some(left(failure)),
          );
        },
        (r) => state.copyWith(
          status: TrustedUserFormStateEnum.none,
          submitTrustedUserFailureOrSuccessOption: none(),
          removeTrustedUserFailureOrSuccessOption: some(right(unit)),
        ),
      ),
    );
  }

  FutureOr<void> _mapFirstNameChanged(
    FirstNameChanged event,
    Emitter<TrustedUserFormState> emit,
  ) {
    emit(
      state.copyWith(
        firstName: FirstName(event.firstName),
      ),
    );
  }

  FutureOr<void> _mapLastNameChanged(
    LastNameChanged event,
    Emitter<TrustedUserFormState> emit,
  ) {
    emit(
      state.copyWith(
        lastName: LastName(event.lastName),
      ),
    );
  }

  FutureOr<void> _mapPhoneNumberChanged(
    PhoneNumberChanged event,
    Emitter<TrustedUserFormState> emit,
  ) {
    emit(
      state.copyWith(
        phoneNumber: PhoneNumber(event.phoneNumber),
      ),
    );
  }

  FutureOr<void> _mapPictureChanged(
    PictureChanged event,
    Emitter<TrustedUserFormState> emit,
  ) {
    emit(
      state.copyWith(
        imagePath: event.pickedFilePath,
      ),
    );
  }

  FutureOr<void> _initialize(
    Init e,
    Emitter<TrustedUserFormState> emit,
  ) async {
    emit(
      state.copyWith(
        status: TrustedUserFormStateEnum.initializing,
      ),
    );

    emit(
      state.copyWith(
        deleteEnable: e.toEdit.id!=null && quiver.isNotBlank(e.toEdit.id),
        status: TrustedUserFormStateEnum.none,
        phoneNumber: e.toEdit.phoneNumber,
        firstName: e.toEdit.firstName,
        lastName: e.toEdit.lastName,
        imagePath: e.toEdit.photoUrl,
        removeTrustedUserFailureOrSuccessOption: none(),
        submitTrustedUserFailureOrSuccessOption: none(),
      ),
    );
  }

  FutureOr<void> _performSubmit(
    Submitted e,
    Emitter<TrustedUserFormState> emit,
  ) async {
    final bool isValid = e.trustedUser.failureOption.isNone();

    if (isValid) {
      emit(
        state.copyWith(
          status: TrustedUserFormStateEnum.submiting,
          submitTrustedUserFailureOrSuccessOption: none(),
        ),
      );

      // TODO ADJ handle picture
      final Either<TrustedUserFailure, Unit> updateResult =
          await _familyRepository.addUpdateTrustedUser(
        familyId: e.connectedUser.family!.id!,
        trustedUser: e.trustedUser,
      );

      emit(
        updateResult.fold(
          (l) {
            _analyticsSvc
                .debug("unable to update trusted user ${e.trustedUser} > $l");
            return state.copyWith(
              status: TrustedUserFormStateEnum.none,
              submitTrustedUserFailureOrSuccessOption:
                  some(left(const TrustedUserFailure.unableToAddTrustedUser())),
            );
          },
          (r) => state.copyWith(
            status: TrustedUserFormStateEnum.none,
            submitTrustedUserFailureOrSuccessOption: some(right(unit)),
          ),
        ),
      );
    }
  }
}
