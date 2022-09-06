import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/application/core/loader/simple_loader_bloc.dart';
import 'package:familytrusts/src/application/core/loader/simple_loader_event.dart';
import 'package:familytrusts/src/domain/children_lookup/i_children_lookup_repository.dart';
import 'package:familytrusts/src/domain/planning/planning.dart';
import 'package:familytrusts/src/domain/planning/planning_failure.dart';
import 'package:familytrusts/src/domain/user/i_user_repository.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/user_failure.dart';
import 'package:injectable/injectable.dart';

@injectable
class PlanningBloc extends SimpleLoaderBloc<Either<PlanningFailure, Planning>> {
  final IChildrenLookupRepository _childrenLookupRepository;
  final IUserRepository _userRepository;

  PlanningBloc(this._childrenLookupRepository, this._userRepository) : super();

  @override
  Future<Either<PlanningFailure, Planning>> load(StartLoading event) async {
    try {
      final Either<UserFailure, User> result =
          await _userRepository.getUser(event.userId!);
      return result.fold(
        (failure) => left(const PlanningFailure.serverError()),
        (user) =>
            _childrenLookupRepository.getPlanning(familyId: user.family!.id!),
      );
    } catch (e) {
      return left(const PlanningFailure.serverError());
    }
  }
}
