import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_details.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_failure.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_history.dart';
import 'package:familytrusts/src/domain/planning/planning.dart';
import 'package:familytrusts/src/domain/planning/planning_failure.dart';
import 'package:familytrusts/src/domain/user/user.dart';

abstract class IChildrenLookupRepository {
  Future<Either<ChildrenLookupFailure, List<ChildrenLookup>>>
      getPassedChildrenLookupsByFamilyId({
    required String familyId,
  });

  Future<Either<ChildrenLookupFailure, List<ChildrenLookup>>>
      getInProgressChildrenLookupsByFamilyId({
    required String familyId,
  });

  Future<Either<ChildrenLookupFailure, List<ChildrenLookupHistory>>>
      getChildrenLookupHistories({
    required String childrenLookupId,
  });

  Future<Either<ChildrenLookupFailure, ChildrenLookupDetails>> findChildrenLookupDetailsById({
    required String childrenLookupId,
  });

  Future<Either<ChildrenLookupFailure, Unit>> createChildrenLookup({
    required ChildrenLookup childrenLookup,
  });

  Future<Either<PlanningFailure, Planning>> getPlanning({
    required String userId,
  });

  Future<Either<ChildrenLookupFailure,Unit>> cancel({
    required ChildrenLookup childrenLookup,
    required User connectedUser,
  });
}
