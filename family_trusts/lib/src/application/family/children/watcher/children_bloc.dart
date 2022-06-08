import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:familytrusts/src/application/family/children/bloc.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:quiver/strings.dart' as quiver;

@injectable
class ChildrenBloc extends Bloc<ChildrenEvent, ChildrenState> {
  final IFamilyRepository _familyRepository;
  StreamSubscription? _childrenSubscription;

  ChildrenBloc(
    this._familyRepository,
  ) : super(const ChildrenState.childrenLoading()) {
    on<ChildrenEvent>(
      (event, emit) => mapEventToState(event, emit),
      transformer: restartable(),
    );
  }

  void mapEventToState(
    ChildrenEvent event,
    Emitter<ChildrenState> emit,
  ) {
    event.map(
      loadChildren: (event) {
        _mapLoadChildrenToState(event, emit);
      },
      childrenUpdated: (event) {
        _mapChildrenUpdatedToState(event, emit);
      },
    );
  }

  void _mapLoadChildrenToState(
    LoadChildren event,
    Emitter<ChildrenState> emit,
  ) {
    if (quiver.isNotBlank(event.familyId)) {
      emit(const ChildrenState.childrenLoading());
      //await Future.delayed(const Duration(seconds: 10));
      _childrenSubscription?.cancel();
      _childrenSubscription =
          _familyRepository.getChildren(event.familyId!).listen(
        (event) {
          add(ChildrenUpdated(eitherChildren: event));
        },
        onError: (_) {
          _childrenSubscription?.cancel();
        },
      );
    } else {
      emit(const ChildrenState.childrenNotLoaded());
    }
  }

  void _mapChildrenUpdatedToState(
    ChildrenUpdated event,
    Emitter<ChildrenState> emit,
  ) {
    emit(ChildrenState.childrenLoaded(eitherChildren: event.eitherChildren));
  }

  @override
  Future<void> close() {
    _childrenSubscription?.cancel();
    return super.close();
  }
}
