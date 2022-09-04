import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/family/child.dart';
import 'package:familytrusts/src/domain/family/children_failure.dart';
import 'package:familytrusts/src/domain/family/family.dart';
import 'package:familytrusts/src/domain/family/family_failure.dart';
import 'package:familytrusts/src/domain/family/locations/location.dart';
import 'package:familytrusts/src/domain/family/locations/location_failure.dart';
import 'package:familytrusts/src/domain/family/trusted_user/trusted.dart';
import 'package:familytrusts/src/domain/family/trusted_user/trusted_failure.dart';

abstract class IFamilyRepository {
  Future<Either<FamilyFailure, String>> create({
    required String userId,
    required Family family,
  });

  Future<Either<FamilyFailure, Unit>> removeMember({
    required String userId,
    required Family family,
  });

  Future<Either<FamilyFailure, List<Family>>> findAllByName({
    required String familyName,
  });

  Future<Either<ChildrenFailure, List<Child>>> getChildren(String familyId);

  Future<Either<ChildrenFailure, Unit>> deleteChild({
    required String familyId,
    required Child child,
  });

  Future<Either<ChildrenFailure, Unit>> addUpdateChild({
    required String familyId,
    required Child child,
    String? pickedFilePath,
  });

  Future<Either<TrustedUserFailure, List<TrustedUser>>> getTrustedUsers(
    String familyId,
  );

  Future<Either<TrustedUserFailure, Unit>> addUpdateTrustedUser({
    required String familyId,
    required TrustedUser trustedUser,
  });

  Future<Either<TrustedUserFailure, Unit>> deleteTrustedUser({
    required String familyId,
    required String trustedUserId,
  });

  /*
  Future<Either<ChildrenFailure, Child>> getChildById({
    required String familyId,
    required String childId,
  });
  Future<Either<LocationFailure, Location>> getLocationById({
    required String familyId,
    required String locationId,
  });
  */

  Future<Either<LocationFailure, List<Location>>> getLocations(String familyId);

  Future<Either<LocationFailure, Unit>> addUpdateLocation({
    required String familyId,
    required Location location,
    String? pickedFilePath,
  });

  Future<Either<LocationFailure, Unit>> deleteLocation({
    required String familyId,
    required Location location,
  });
}
