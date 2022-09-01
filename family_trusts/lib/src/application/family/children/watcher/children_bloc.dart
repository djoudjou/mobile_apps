import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/application/family/children/bloc.dart';
import 'package:familytrusts/src/domain/family/child.dart';
import 'package:familytrusts/src/domain/family/children_failure.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:quiver/strings.dart' as quiver;

@injectable
class ChildrenBloc extends Bloc<ChildrenEvent, ChildrenState> {
  final IFamilyRepository _familyRepository;

  ChildrenBloc(
    this._familyRepository,
  ) : super(const ChildrenState.childrenLoading()) {
    on<LoadChildren>(
      _mapLoadChildrenToState,
      transformer: restartable(),
    );
  }

  Future<void> _mapLoadChildrenToState(
    LoadChildren event,
    Emitter<ChildrenState> emit,
  ) async {
    if (quiver.isNotBlank(event.familyId)) {
      emit(const ChildrenState.childrenLoading());

      final Either<ChildrenFailure, List<Child>> result =
          await _familyRepository.getChildren(event.familyId!);

      emit(
        result.fold(
          (failure) =>
              ChildrenState.childrenLoaded(eitherChildren: left(failure)),
          (children) =>
              ChildrenState.childrenLoaded(eitherChildren: right(children)),
        ),
      );
    } else {
      emit(const ChildrenState.childrenNotLoaded());
    }
  }
}
