import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:familytrusts/src/domain/notification/i_notification_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:quiver/strings.dart' as quiver;

import '../bloc.dart';
import 'children_state.dart';

@injectable
class ChildrenBloc extends Bloc<ChildrenEvent, ChildrenState> {
  final IFamilyRepository _familyRepository;
  final INotificationRepository _notificationRepository;
  StreamSubscription? _childrenSubscription;

  ChildrenBloc(
    this._familyRepository,
    this._notificationRepository,
  ) : super(const ChildrenState.childrenLoading());

  @override
  Stream<ChildrenState> mapEventToState(
    ChildrenEvent event,
  ) async* {
    yield* event.map(
      loadChildren: (event) {
        return _mapLoadChildrenToState(event);
      },
      childrenUpdated: (event) {
        return _mapChildrenUpdatedToState(event);
      },
    );
  }

  Stream<ChildrenState> _mapLoadChildrenToState(LoadChildren event) async* {
    if (quiver.isNotBlank(event.familyId)) {
      yield const ChildrenState.childrenLoading();
      //await Future.delayed(const Duration(seconds: 10));
      _childrenSubscription?.cancel();
      _childrenSubscription =
          _familyRepository.getChildren(event.familyId!).listen((event) {
        add(ChildrenUpdated(eitherChildren: event));
      }, onError: (_) {
        _childrenSubscription?.cancel();
      });
    } else {
      yield const ChildrenState.childrenNotLoaded();
    }
  }

  Stream<ChildrenState> _mapChildrenUpdatedToState(
      ChildrenUpdated event) async* {
    yield ChildrenState.childrenLoaded(eitherChildren: event.eitherChildren);
  }

  @override
  Future<void> close() {
    _childrenSubscription?.cancel();
    return super.close();
  }
}
