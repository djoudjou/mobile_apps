import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/application/core/loader/simple_loader_bloc.dart';
import 'package:familytrusts/src/application/core/loader/simple_loader_event.dart';
import 'package:familytrusts/src/domain/children_lookup/i_children_lookup_repository.dart';
import 'package:familytrusts/src/domain/planning/planning.dart';
import 'package:familytrusts/src/domain/planning/planning_failure.dart';
import 'package:injectable/injectable.dart';

@injectable
class PlanningBloc
    extends SimpleLoaderBloc<Either<PlanningFailure, Planning>> {
  final IChildrenLookupRepository _childrenLookupRepository;

  PlanningBloc(this._childrenLookupRepository) : super();

  @override
  Future<Either<PlanningFailure, Planning>> load(StartLoading event) {
    return _childrenLookupRepository.getPlanning(userId:event.userId!);
  }
}
