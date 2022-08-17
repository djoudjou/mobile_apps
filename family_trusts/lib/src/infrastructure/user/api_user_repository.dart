import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/search_user/search_user_failure.dart';
import 'package:familytrusts/src/domain/user/i_user_repository.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/user_failure.dart';
import 'package:familytrusts/src/infrastructure/http/api_service.dart';
import 'package:familytrusts/src/infrastructure/http/login_person_dto.dart';
import 'package:familytrusts/src/infrastructure/http/person_dto.dart';
import 'package:injectable/injectable.dart';

@Environment(Environment.prod)
@LazySingleton(as: IUserRepository)
class ApiUserRepository implements IUserRepository {
  final ApiService _apiService;
  StreamSubscription? _userSubscription;

  ApiUserRepository(this._apiService);

  @override
  Future<Either<UserFailure, Unit>> update(User user,
      {String? pickedFilePath}) {
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

    return _apiService.getPersonRestClient().update(user.id!, person).then(
          (value) => right(unit),
          onError: (error) => left(const UserFailure.unexpected()),
        );
  }

  @override
  Future<Either<UserFailure, Unit>> create(
    User user, {
    String? pickedFilePath,
  }) {
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

    return _apiService.getPersonRestClient().createPerson(person).then(
          (value) => right(unit),
          onError: (error) => left(const UserFailure.unexpected()),
        );
  }

  @override
  Future<Either<UserFailure, User>> getUser(String id) {
    return _apiService.getPersonRestClient().findPersonById(id).then(
          (value) => right(value.toUser()),
          onError: (error) => left(const UserFailure.unexpected()),
        );
  }

  @override
  Future<Either<UserFailure, Unit>> saveToken(String userId, String token) {
    return _apiService
        .getPersonRestClient()
        .login(userId, LoginPersonDTO(token: token))
        .then(
          (value) => right(unit),
          onError: (error) => left(const UserFailure.unexpected()),
        );
  }

  @override
  Future<Either<SearchUserFailure, Stream<List<User>>>> searchUsers(
    String userLookupText, {
    List<String>? excludedUsers,
  }) {
    // TODO ADJ : remove this function
    return _apiService.getPersonRestClient().findAll().then(
          (value) {
            final l = value.map((e) => e.toUser()).toList();

            return right(Stream.from(l));
          },
          onError: (error) => left(const UserFailure.unexpected()),
        );
  }

  @override
  Stream<Either<UserFailure, User>> watchUser(String userId) {
    // TODO: implement watchUser
    throw UnimplementedError();
  }
}
