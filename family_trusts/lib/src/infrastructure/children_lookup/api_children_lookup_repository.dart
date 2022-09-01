import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_details.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_failure.dart';
import 'package:familytrusts/src/domain/children_lookup/children_lookup_history.dart';
import 'package:familytrusts/src/domain/children_lookup/i_children_lookup_repository.dart';
import 'package:familytrusts/src/domain/planning/planning.dart';
import 'package:familytrusts/src/domain/planning/planning_failure.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:familytrusts/src/infrastructure/http/api_service.dart';
import 'package:injectable/injectable.dart';

@Environment(Environment.prod)
@LazySingleton(as: IChildrenLookupRepository)
class ApiChildrenLookupRepository
    with LogMixin
    implements IChildrenLookupRepository {
  final ApiService _apiService;

  ApiChildrenLookupRepository(this._apiService);

  @override
  Future<Either<ChildrenLookupFailure, Unit>> cancel({required ChildrenLookup childrenLookup, required User connectedUser}) {
    // TODO: implement cancel
    throw UnimplementedError();
  }

  @override
  Future<Either<ChildrenLookupFailure, Unit>> createChildrenLookup({required ChildrenLookup childrenLookup}) {
    // TODO: implement createChildrenLookup
    throw UnimplementedError();
  }

  @override
  Future<Either<ChildrenLookupFailure, ChildrenLookupDetails>> findChildrenLookupDetailsById({required String childrenLookupId}) {
    // TODO: implement findChildrenLookupDetailsById
    throw UnimplementedError();
  }

  @override
  Future<Either<ChildrenLookupFailure, List<ChildrenLookupHistory>>> getChildrenLookupHistories({required String childrenLookupId}) {
    // TODO: implement getChildrenLookupHistories
    throw UnimplementedError();
  }

  @override
  Future<Either<ChildrenLookupFailure, List<ChildrenLookup>>> getInProgressChildrenLookupsByFamilyId({required String familyId}) {
    // TODO: implement getInProgressChildrenLookupsByFamilyId
    throw UnimplementedError();
  }

  @override
  Future<Either<ChildrenLookupFailure, List<ChildrenLookup>>> getPassedChildrenLookupsByFamilyId({required String familyId}) {
    // TODO: implement getPassedChildrenLookupsByFamilyId
    throw UnimplementedError();
  }

  @override
  Future<Either<PlanningFailure, Planning>> getPlanning({required String userId}) {
    // TODO: implement getPlanning
    throw UnimplementedError();
  }
}
