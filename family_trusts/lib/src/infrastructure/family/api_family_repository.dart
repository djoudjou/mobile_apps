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
import 'package:familytrusts/src/domain/family/trusted_user/trusted_failure.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:familytrusts/src/infrastructure/http/api_service.dart';
import 'package:familytrusts/src/infrastructure/http/families/child_dto.dart';
import 'package:familytrusts/src/infrastructure/http/families/create_family_dto.dart';
import 'package:familytrusts/src/infrastructure/http/families/family_dto.dart';
import 'package:familytrusts/src/infrastructure/http/families/location_dto.dart';
import 'package:familytrusts/src/infrastructure/http/families/trust_person_dto.dart';
import 'package:familytrusts/src/infrastructure/http/families/update_child_dto.dart';
import 'package:familytrusts/src/infrastructure/http/families/update_location_dto.dart';
import 'package:familytrusts/src/infrastructure/http/families/update_trust_person_dto.dart';
import 'package:injectable/injectable.dart';

@Environment(Environment.prod)
@LazySingleton(as: IFamilyRepository)
class ApiFamilyRepository with LogMixin implements IFamilyRepository {
  final ApiService _apiService;

  ApiFamilyRepository(this._apiService);

  @override
  Future<Either<TrustedUserFailure, Unit>> addUpdateTrustedUser({
    required String familyId,
    required TrustedUser trustedUser,
  }) async {
    try {
      final UpdateTrustPersonDTO trustPersonDTO =
          UpdateTrustPersonDTO.fromTrustedPerson(trustedUser);

      if (trustedUser.id != null) {
        await _apiService
            .getFamilyRestClient()
            .updateTrustPerson(familyId, trustedUser.id!, trustPersonDTO);
      } else {
        await _apiService
            .getFamilyRestClient()
            .createTrustPerson(familyId, trustPersonDTO);
      }
      return right(unit);
    } catch (e) {
      log("error in addUpdateTrustedUser method : $e");
      return left(const TrustedUserFailure.unexpected());
    }
  }

  @override
  Future<Either<ChildrenFailure, Unit>> addUpdateChild({
    required String familyId,
    required Child child,
    String? pickedFilePath,
  }) async {
    try {
      final UpdateChildDTO dto = UpdateChildDTO.fromChild(child);

      if (child.id != null) {
        await _apiService.getFamilyRestClient().updateChild(
              familyId,
              child.id!,
              dto,
            );
      } else {
        await _apiService.getFamilyRestClient().createChild(
              familyId,
              dto,
            );
      }
      return right(unit);
    } catch (e) {
      log("error in addUpdateChild method : $e");
      return left(const ChildrenFailure.unexpected());
    }
  }

  @override
  Future<Either<LocationFailure, Unit>> addUpdateLocation({
    required String familyId,
    required Location location,
    String? pickedFilePath,
  }) async {
    try {
      final UpdateLocationDTO dto = UpdateLocationDTO.fromLocation(location);

      if (location.id != null) {
        await _apiService.getFamilyRestClient().updateLocation(
              familyId,
              location.id!,
              dto,
            );
      } else {
        await _apiService.getFamilyRestClient().createLocation(
              familyId,
              dto,
            );
      }
      return right(unit);
    } catch (e) {
      log("error in addUpdateLocation method : $e");
      return left(const LocationFailure.unexpected());
    }
  }

  @override
  Future<Either<FamilyFailure, String>> create({
    required String userId,
    required Family family,
  }) async {
    try {
      final CreateFamilyDTO createFamilyDTO = CreateFamilyDTO(
        name: family.name.getOrCrash(),
        memberId: userId,
      );
      final FamilyDTO newFamily =
          await _apiService.getFamilyRestClient().createFamily(createFamilyDTO);
      return right(newFamily.name!);
    } catch (e) {
      log("error in create method : $e");
      return left(const FamilyFailure.unexpected());
    }
  }

  @override
  Future<Either<ChildrenFailure, Unit>> deleteChild({
    required String familyId,
    required Child child,
  }) async {
    try {
      await _apiService.getFamilyRestClient().deleteChild(familyId, child.id!);
      return right(unit);
    } catch (e) {
      log("error in deleteChild method : $e");
      return left(const ChildrenFailure.unexpected());
    }
  }

  @override
  Future<Either<LocationFailure, Unit>> deleteLocation({
    required String familyId,
    required Location location,
  }) async {
    try {
      await _apiService
          .getFamilyRestClient()
          .deleteLocation(familyId, location.id!);
      return right(unit);
    } catch (e) {
      log("error in deleteLocation method : $e");
      return left(const LocationFailure.unexpected());
    }
  }

  @override
  Future<Either<TrustedUserFailure, Unit>> deleteTrustedUser({
    required String familyId,
    required String trustedUserId,
  }) async {
    try {
      await _apiService
          .getFamilyRestClient()
          .deleteTrustPerson(familyId, trustedUserId);
      return right(unit);
    } catch (e) {
      log("error in deleteTrustedUser method : $e");
      return left(const TrustedUserFailure.unexpected());
    }
  }

  @override
  Future<Either<FamilyFailure, List<Family>>> findAllByName({
    required String familyName,
  }) async {
    try {
      final List<FamilyDTO> families = await _apiService
          .getFamilyRestClient()
          .findAvailableFamiliesByNameQuery(familyName);

      return right(families.map((f) => f.toDomain()).toList());
    } catch (e) {
      log("error in findAllByName method : $e");
      return left(const FamilyFailure.unexpected());
    }
  }

  @override
  Future<Either<FamilyFailure, Unit>> removeMember({
    required String userId,
    required Family family,
  }) async {
    try {
      await _apiService.getFamilyRestClient().removeMember(family.id!, userId);
      return right(unit);
    } catch (e) {
      log("error in findAllByName method : $e");
      return left(const FamilyFailure.unexpected());
    }
  }

  @override
  Future<Either<ChildrenFailure, List<Child>>> getChildren(
    String familyId,
  ) async {
    try {
      final List<ChildDTO> dtos = await _apiService
          .getFamilyRestClient()
          .findChildrenByFamilyIdQuery(familyId);

      return right(dtos.map((f) => f.toDomain()).toList());
    } catch (e) {
      log("error in getChildren method : $e");
      return left(const ChildrenFailure.unexpected());
    }
  }

  @override
  Future<Either<LocationFailure, List<Location>>> getLocations(
    String familyId,
  ) async {
    try {
      final List<LocationDTO> dtos = await _apiService
          .getFamilyRestClient()
          .findLocationsByFamilyIdQuery(familyId);

      return right(dtos.map((f) => f.toDomain()).toList());
    } catch (e) {
      log("error in getLocations method : $e");
      return left(const LocationFailure.unexpected());
    }
  }

  @override
  Future<Either<TrustedUserFailure, List<TrustedUser>>> getTrustedUsers(
    String familyId,
  ) async {
    try {
      final List<TrustPersonDTO> dtos = await _apiService
          .getFamilyRestClient()
          .findTrustPersonsByFamilyIdQuery(familyId);

      return right(dtos.map((f) => f.toDomain()).toList());
    } catch (e) {
      log("error in getTrustedUsers method : $e");
      return left(const TrustedUserFailure.unexpected());
    }
  }
}
