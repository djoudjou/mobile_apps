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
import 'package:familytrusts/src/infrastructure/http/children_lookup/child_lookup_details_dto.dart';
import 'package:familytrusts/src/infrastructure/http/children_lookup/child_lookup_dto.dart';
import 'package:familytrusts/src/infrastructure/http/children_lookup/children_lookup_rest_client.dart';
import 'package:familytrusts/src/infrastructure/http/children_lookup/create_child_lookup_dto.dart';
import 'package:familytrusts/src/infrastructure/http/children_lookup/planning_dto.dart';
import 'package:familytrusts/src/infrastructure/http/families/family_dto.dart';
import 'package:injectable/injectable.dart';

@Environment(Environment.prod)
@LazySingleton(as: IChildrenLookupRepository)
class ApiChildrenLookupRepository
    with LogMixin
    implements IChildrenLookupRepository {
  final ApiService _apiService;

  ChildrenLookupRestClient get childrenLookupRestClient =>
      _apiService.getChildrenLookupRestClient();

  ApiChildrenLookupRepository(this._apiService);

  @override
  Future<Either<ChildrenLookupFailure, Unit>> cancel({
    required ChildrenLookup childrenLookup,
    required User connectedUser,
  }) async {
    try {
      await childrenLookupRestClient.cancel(
        childrenLookup.id!,
        connectedUser.id!,
      );
      return right(unit);
    } catch (e) {
      log("error in cancel method : $e");
      return left(const ChildrenLookupFailure.serverError());
    }
  }

  @override
  Future<Either<ChildrenLookupFailure, Unit>> createChildrenLookup({
    required String familyId,
    required ChildrenLookup childrenLookup,
  }) async {
    try {
      final CreateChildLookupDTO createChildLookupDTO =
          CreateChildLookupDTO.from(childrenLookup);
      await childrenLookupRestClient.create(createChildLookupDTO);

      return right(unit);
    } catch (e) {
      log("error in createChildrenLookup method : $e");
      return left(const ChildrenLookupFailure.serverError());
    }
  }

  @override
  Future<Either<ChildrenLookupFailure, ChildrenLookupDetails>>
      findChildrenLookupDetailsById({
    required String familyId,
    required String childrenLookupId,
  }) async {
    try {
      final FamilyDTO familyDTO =
          await _apiService.getFamilyRestClient().findFamilyByIdQuery(familyId);
      final ChildLookupDetailsDTO childLookupDetailsDTO =
          await childrenLookupRestClient
              .findChildrenLookupDetailsById(childrenLookupId);

      return right(childLookupDetailsDTO.toDomain(familyDTO));
    } catch (e) {
      log("error in findChildrenLookupDetailsById method : $e");
      return left(const ChildrenLookupFailure.serverError());
    }
  }

  @override
  Future<Either<ChildrenLookupFailure, List<ChildrenLookupHistory>>>
      getChildrenLookupHistories({
    required String familyId,
    required String childrenLookupId,
  }) async {
    try {
      final FamilyDTO familyDTO =
          await _apiService.getFamilyRestClient().findFamilyByIdQuery(familyId);
      final ChildLookupDetailsDTO childLookupDetailsDTO =
          await childrenLookupRestClient
              .findChildrenLookupDetailsById(childrenLookupId);

      return right(childLookupDetailsDTO.toDomain(familyDTO).histories);
    } catch (e) {
      log("error in getChildrenLookupHistories method : $e");
      return left(const ChildrenLookupFailure.serverError());
    }
  }

  @override
  Future<Either<ChildrenLookupFailure, List<ChildrenLookup>>>
      getInProgressChildrenLookupsByFamilyId({required String familyId}) async {
    try {
      final FamilyDTO familyDTO =
          await _apiService.getFamilyRestClient().findFamilyByIdQuery(familyId);
      final List<ChildLookupDTO> childLookupDTOs =
          await childrenLookupRestClient.findInProgressByFamilyId(familyId);

      return right(childLookupDTOs.map((f) => f.toDomain(familyDTO)).toList());
    } catch (e) {
      log("error in getInProgressChildrenLookupsByFamilyId method : $e");
      return left(const ChildrenLookupFailure.serverError());
    }
  }

  @override
  Future<Either<ChildrenLookupFailure, List<ChildrenLookup>>>
      getPassedChildrenLookupsByFamilyId({required String familyId}) async {
    try {
      final FamilyDTO familyDTO =
          await _apiService.getFamilyRestClient().findFamilyByIdQuery(familyId);
      final List<ChildLookupDTO> childLookupDTOs =
          await childrenLookupRestClient.findPastByFamilyId(familyId);

      return right(childLookupDTOs.map((f) => f.toDomain(familyDTO)).toList());
    } catch (e) {
      log("error in getPassedChildrenLookupsByFamilyId method : $e");
      return left(const ChildrenLookupFailure.serverError());
    }
  }

  @override
  Future<Either<PlanningFailure, Planning>> getPlanning({
    required String familyId,
  }) async {
    try {
      final FamilyDTO familyDTO =
          await _apiService.getFamilyRestClient().findFamilyByIdQuery(familyId);
      final PlanningDTO planningDTO =
          await childrenLookupRestClient.getPlanningByFamilyId(familyId);
      return right(planningDTO.toDomain(familyDTO));
    } catch (e) {
      log("error in getPlanning method : $e");
      return left(const PlanningFailure.serverError());
    }
  }
}
