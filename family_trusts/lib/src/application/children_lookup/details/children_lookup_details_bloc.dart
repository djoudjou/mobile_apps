import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/application/children_lookup/details/bloc.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_details.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_failure.dart';
import 'package:familytrusts/src/domain/children_lookup/i_children_lookup_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChildrenLookupDetailsBloc
    extends Bloc<ChildrenLookupDetailsEvent, ChildrenLookupDetailsState> {
  final IChildrenLookupRepository _childrenLookupRepository;

  ChildrenLookupDetailsBloc(
    this._childrenLookupRepository,
  ) : super(ChildrenLookupDetailsState.initial()) {
    on<ChildrenLookupDetailsInit>(
      _mapChildrenLookupDetailsInit,
      transformer: sequential(),
    );
    on<ChildrenLookupDetailsCancel>(
      _mapChildrenLookupDetailsCancel,
      transformer: sequential(),
    );
  }

  Future<FutureOr<void>> _mapChildrenLookupDetailsInit(
    ChildrenLookupDetailsInit event,
    Emitter<ChildrenLookupDetailsState> emit,
  ) async {
    emit(
      state.copyWith(
        isInitializing: true,
      ),
    );

    final Either<ChildrenLookupFailure, ChildrenLookupDetails>
        resultChildrenLookupDetails =
        await _childrenLookupRepository.findChildrenLookupDetailsById(
      childrenLookupId: event.childrenLookup.id!,
    );

    emit(
      resultChildrenLookupDetails.fold(
        (failure) => state.copyWith(
          showErrorMessages: true,
          isInitializing: false,
          failureOrSuccessOption: some(left(failure)),
        ),
        (childrenLookupDetails) => state.copyWith(
          optionChildrenLookupDetails: some(childrenLookupDetails),
          isIssuer: event.connectedUser.id ==
              childrenLookupDetails.childrenLookup.issuer?.id,
          failureOrSuccessOption: none(),
        ),
      ),
    );
  }

  Future<FutureOr<void>> _mapChildrenLookupDetailsCancel(
    ChildrenLookupDetailsCancel event,
    Emitter<ChildrenLookupDetailsState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        failureOrSuccessOption: none(),
      ),
    );

    final Either<ChildrenLookupFailure, Unit> resultCancel =
        await _childrenLookupRepository.cancel(
      connectedUser: event.connectedUser,
      childrenLookup: event.childrenLookup,
    );

    emit(
      resultCancel.fold(
        (failure) => state.copyWith(
          showErrorMessages: true,
          isInitializing: false,
          failureOrSuccessOption: some(left(failure)),
        ),
        (success) => state.copyWith(
          isSubmitting: false,
          failureOrSuccessOption: some(right(unit)),
        ),
      ),
    );
  }
}
