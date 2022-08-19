import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/family/child.dart';
import 'package:familytrusts/src/domain/family/children_failure.dart';
import 'package:familytrusts/src/domain/family/family.dart';
import 'package:familytrusts/src/domain/family/family_failure.dart';
import 'package:familytrusts/src/domain/family/locations/location.dart';
import 'package:familytrusts/src/domain/family/locations/location_failure.dart';
import 'package:familytrusts/src/domain/family/trusted_user/trusted.dart';
import 'package:familytrusts/src/domain/user/user_failure.dart';

abstract class IFamilyRepository {
  Future<Either<FamilyFailure, Unit>> create({
    required String userId,
    required Family family,
  });

  Future<Either<FamilyFailure, Unit>> deleteFamily({
    required String familyId,
  });

  Future<Either<ChildrenFailure, Child>> getChildById({
    required String familyId,
    required String childId,
  });

  //Stream<Either<ChildrenFailure, List<Either<ChildrenFailure, Child>>>>
  //    getChildren(String familyId);

  Future<Either<ChildrenFailure, Unit>> deleteChild({
    required String familyId,
    required Child child,
  });

  Future<Either<ChildrenFailure, Unit>> addUpdateChild({
    required String familyId,
    required Child child,
    String? pickedFilePath,
  });

  //Stream<Either<UserFailure, List<TrustedUser>>> getTrustedUsers(
  //   String familyId,
  //);

  Future<Either<UserFailure, List<TrustedUser>>> getFutureTrustedUsers(
    String familyId,
  );

  Future<Either<UserFailure, Unit>> addTrustedUser({
    required String familyId,
    required TrustedUser trustedUser,
  });

  Future<Either<UserFailure, Unit>> deleteTrustedUser({
    required String familyId,
    required String trustedUserId,
  });

  Future<Either<LocationFailure, Location>> getLocationById({
    required String familyId,
    required String locationId,
  });

  //Stream<Either<LocationFailure, List<Either<LocationFailure, Location>>>>
  //    getLocations(String familyId);

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
