import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/family/child.dart';
import 'package:familytrusts/src/domain/family/children_failure.dart';
import 'package:familytrusts/src/domain/family/family.dart';
import 'package:familytrusts/src/domain/family/family_failure.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:familytrusts/src/domain/family/locations/location.dart';
import 'package:familytrusts/src/domain/family/locations/location_failure.dart';
import 'package:familytrusts/src/domain/family/trusted_user/trusted.dart';
import 'package:familytrusts/src/domain/http/families/create_family_dto.dart';
import 'package:familytrusts/src/domain/user/user_failure.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:familytrusts/src/infrastructure/http/api_service.dart';
import 'package:injectable/injectable.dart';

@Environment(Environment.prod)
@LazySingleton(as: IFamilyRepository)
class ApiFamilyRepository with LogMixin implements IFamilyRepository {
  final ApiService _apiService;

  ApiFamilyRepository(this._apiService);

  @override
  Future<Either<UserFailure, Unit>> addTrustedUser(
      {required String familyId, required TrustedUser trustedUser}) {
    // TODO: implement addTrustedUser
    throw UnimplementedError();
  }

  @override
  Future<Either<ChildrenFailure, Unit>> addUpdateChild(
      {required String familyId,
      required Child child,
      String? pickedFilePath}) {
    // TODO: implement addUpdateChild
    throw UnimplementedError();
  }

  @override
  Future<Either<LocationFailure, Unit>> addUpdateLocation(
      {required String familyId,
      required Location location,
      String? pickedFilePath}) {
    // TODO: implement addUpdateLocation
    throw UnimplementedError();
  }

  @override
  Future<Either<FamilyFailure, Unit>> create(
      {required String userId, required Family family}) async {
    try {
      final CreateFamilyDTO createFamilyDTO = CreateFamilyDTO(
        name: family.name.getOrCrash(),
        memberId: userId,
      );
      await _apiService.getFamilyRestClient().createFamily(createFamilyDTO);
      return right(unit);
    } catch (e) {
      log("error in create method : $e");
      return left(const FamilyFailure.unexpected());
    }
  }

  @override
  Future<Either<ChildrenFailure, Unit>> deleteChild(
      {required String familyId, required Child child}) {
    // TODO: implement deleteChild
    throw UnimplementedError();
  }

  @override
  Future<Either<FamilyFailure, Unit>> deleteFamily({required String familyId}) {
    // TODO: implement deleteFamily
    throw UnimplementedError();
  }

  @override
  Future<Either<LocationFailure, Unit>> deleteLocation(
      {required String familyId, required Location location}) {
    // TODO: implement deleteLocation
    throw UnimplementedError();
  }

  @override
  Future<Either<UserFailure, Unit>> deleteTrustedUser(
      {required String familyId, required String trustedUserId}) {
    // TODO: implement deleteTrustedUser
    throw UnimplementedError();
  }

  @override
  Future<Either<ChildrenFailure, Child>> getChildById(
      {required String familyId, required String childId}) {
    // TODO: implement getChildById
    throw UnimplementedError();
  }

  @override
  Future<Either<UserFailure, List<TrustedUser>>> getFutureTrustedUsers(
      String familyId) {
    // TODO: implement getFutureTrustedUsers
    throw UnimplementedError();
  }

  @override
  Future<Either<LocationFailure, Location>> getLocationById(
      {required String familyId, required String locationId}) {
    // TODO: implement getLocationById
    throw UnimplementedError();
  }
}