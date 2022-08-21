import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/user/i_user_repository.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/user_failure.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:familytrusts/src/infrastructure/http/api_service.dart';
import 'package:familytrusts/src/infrastructure/http/families/family_dto.dart';
import 'package:familytrusts/src/infrastructure/http/persons/login_person_dto.dart';
import 'package:familytrusts/src/infrastructure/http/persons/person_dto.dart';
import 'package:injectable/injectable.dart';

@Environment(Environment.prod)
@LazySingleton(as: IUserRepository)
class ApiUserRepository with LogMixin implements IUserRepository {
  final ApiService _apiService;

  ApiUserRepository(this._apiService);

  @override
  Future<Either<UserFailure, Unit>> update(
    User user, {
    String? pickedFilePath,
  }) async {
    try {
      final PersonDTO person = PersonDTO.fromUser(user);

      /**
          TODO ADJ gérer les images dans le backend
          post image > File(pickedFilePath!)

          if (quiver.isNotBlank(pickedFilePath)) {
          final firebase_storage.Reference ref =
          _storageReference.userPhotoStorage(userEntity.id!);

          final String downloadUrl =
          await FirebaseHelper.addImage(File(pickedFilePath!), ref);

          userEntity = userEntity.copyWith(photoUrl: downloadUrl);
          }
       */
      await _apiService.getPersonRestClient().update(person.personId!, person);
      return right(unit);
    } catch (e) {
      log("error in update method : $e");
      return left(const UserFailure.unexpected());
    }
  }

  @override
  Future<Either<UserFailure, Unit>> create(
    User user, {
    String? pickedFilePath,
  }) async {
    try {
      final PersonDTO person = PersonDTO.fromUser(user);

      /**
          TODO ADJ gérer les images dans le backend
          post image > File(pickedFilePath!)

          if (quiver.isNotBlank(pickedFilePath)) {
          final firebase_storage.Reference ref =
          _storageReference.userPhotoStorage(userEntity.id!);

          final String downloadUrl =
          await FirebaseHelper.addImage(File(pickedFilePath!), ref);

          userEntity = userEntity.copyWith(photoUrl: downloadUrl);
          }
       */
      await _apiService.getPersonRestClient().createPerson(person);
      return right(unit);
    } catch (e) {
      log("error in create method : $e");
      return left(const UserFailure.unexpected());
    }
  }

  @override
  Future<Either<UserFailure, User>> getUser(String id) async {
    try {
      final PersonDTO result =
          await _apiService.getPersonRestClient().findPersonById(id);

      final List<FamilyDTO> families = await _apiService.getFamilyRestClient().findMatchingFamiliesByMemberIdQuery(id);

      final User user = result.toDomain(families.isNotEmpty?families.first:null);

      return right(user);
    } catch (e) {
      log("error in getUser method : $e");
      return left(const UserFailure.unexpected());
    }
  }

  @override
  Future<Either<UserFailure, Unit>> saveToken(
      String userId, String token,) async {
    try {
      await _apiService
          .getPersonRestClient()
          .login(userId, LoginPersonDTO(token: token));
      return right(unit);
    } catch (e) {
      log("error in saveToken method : $e");
      return left(const UserFailure.unexpected());
    }
  }
}
