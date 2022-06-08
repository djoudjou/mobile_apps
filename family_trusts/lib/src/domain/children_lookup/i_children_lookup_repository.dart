import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_failure.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_history.dart';
import 'package:familytrusts/src/domain/planning/planning.dart';
import 'package:familytrusts/src/domain/planning/planning_failure.dart';

abstract class IChildrenLookupRepository {
  Stream<List<Either<ChildrenLookupFailure, ChildrenLookup>>>
      getChildrenLookupsByFamilyId({
    required String familyId,
  });

  Stream<List<Either<ChildrenLookupFailure, ChildrenLookup>>>
      getChildrenLookupsByTrustedId({required String trustedUserId});

  Stream<List<Either<ChildrenLookupFailure, ChildrenLookupHistory>>>
      getChildrenLookupHistories({
    required String childrenLookupId,
  });

  Future<Either<ChildrenLookupFailure, Unit>> addChildrenLookupHistory({
    required String childrenLookupId,
    required ChildrenLookupHistory childrenLookupHistory,
  });

  Future<Either<ChildrenLookupFailure, Unit>> addUpdateChildrenLookup({
    required ChildrenLookup childrenLookup,
  });

  Stream<Either<ChildrenLookupFailure, ChildrenLookup>> watchChildrenLookup({
    required String childrenLookupId,
  });

  Stream<Either<PlanningFailure, Planning>> getPlanning({
    required String userId,
  });
}
