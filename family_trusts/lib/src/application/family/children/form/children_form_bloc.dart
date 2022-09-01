import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:familytrusts/src/application/family/children/bloc.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChildrenFormBloc extends Bloc<ChildrenFormEvent, ChildrenFormState> {
  final IFamilyRepository _familyRepository;

  ChildrenFormBloc(
    this._familyRepository,
  ) : super(const ChildrenFormState.init()) {
    on<AddChild>(_mapAddChildToState, transformer: restartable());
    on<UpdateChild>(_mapUpdateChildToState, transformer: restartable());
    on<DeleteChild>(_mapDeleteChildToState, transformer: restartable());
  }

  FutureOr<void> _mapAddChildToState(
    AddChild event,
    Emitter<ChildrenFormState> emit,
  ) async {
    try {
      emit(const ChildrenFormState.addChildInProgress());
      final User user = event.user;
      await _familyRepository.addUpdateChild(
        familyId: user.family!.id!,
        child: event.child,
        pickedFilePath: event.pickedFilePath,
      );
      emit(const ChildrenFormState.addChildSuccess());
    } catch (_) {
      emit(const ChildrenFormState.addChildFailure());
    }
  }

  FutureOr<void> _mapUpdateChildToState(
    UpdateChild event,
    Emitter<ChildrenFormState> emit,
  ) async {
    try {
      emit(const ChildrenFormState.updateChildInProgress());
      final User user = event.user;
      await _familyRepository.addUpdateChild(
        familyId: user.family!.id!,
        child: event.child,
        pickedFilePath: event.pickedFilePath,
      );
      emit(const ChildrenFormState.updateChildSuccess());
    } catch (_) {
      emit(const ChildrenFormState.updateChildFailure());
    }
  }

  FutureOr<void> _mapDeleteChildToState(
    DeleteChild event,
    Emitter<ChildrenFormState> emit,
  ) async {
    try {
      emit(const ChildrenFormState.deleteChildInProgress());
      final User user = event.user;
      await _familyRepository.deleteChild(
        familyId: user.family!.id!,
        child: event.child,
      );
      emit(const ChildrenFormState.deleteChildSuccess());
    } catch (_) {
      emit(const ChildrenFormState.deleteChildFailure());
    }
  }
}
