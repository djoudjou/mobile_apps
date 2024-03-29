import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:familytrusts/src/domain/search_user/search_user_failure.dart';
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

  ApiUserRepository(
    this._apiService,
  );

  @override
  Future<Either<UserFailure, Unit>> update(
    User user, {
    String? pickedFilePath,
  }) async {
    try {
      final PersonDTO person = PersonDTO.fromUser(user);

      //person = await updatePhoto(user, person);

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
      final PersonDTO result = await _apiService
          .getPersonRestClient()
          .findPersonById(id)
          .catchError((Object obj) {
        log("$obj");
        // non-200 error goes here.
        switch (obj.runtimeType) {
          case DioError:
            // Here's the sample to get the failed response error code and message
            final res = (obj as DioError).response;
            log("Got error : ${res?.statusCode} -> ${res?.statusMessage}");
            break;
          default:
            break;
        }
      });

      final List<FamilyDTO> families = await _apiService
          .getFamilyRestClient()
          .findMatchingFamiliesByMemberIdQuery(id)
          .catchError((Object obj) {
        log("$obj"); // non-200 error goes here.
        switch (obj.runtimeType) {
          case DioError:
            // Here's the sample to get the failed response error code and message
            final res = (obj as DioError).response;
            log("Got error : ${res?.statusCode} -> ${res?.statusMessage}");
            break;
          default:
            break;
        }
      });

      final User user =
          result.toDomain(families.isNotEmpty ? families.first : null);

      return right(user);
    } on DioError catch (e) {
      log("error in getUser method : $e");
      return left(const UserFailure.unexpected());
    } catch (e2) {
      log("error in getUser method : $e2");
      return left(const UserFailure.unexpected());
    }
  }

  @override
  Future<Either<UserFailure, Unit>> saveToken(
    String userId,
    String token,
  ) async {
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

  @override
  Future<Either<SearchUserFailure, List<User>>> searchUsers(
    String userLookupText, {
    List<String>? excludedUsers,
  }) async {
    try {
      final List<PersonDTO> result =
          await _apiService.getPersonRestClient().findAll();

      final List<PersonDTO> filtered = (excludedUsers != null)
          ? result.where((p) => !excludedUsers.contains(p.personId)).toList()
          : result;

      return right(filtered.map((p) => p.toDomain(null)).toList());
    } catch (e) {
      log("error in searchUsers method : $e");
      return left(const SearchUserFailure.serverError());
    }
  }
}
