import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/search_user/search_user_failure.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/user_failure.dart';

abstract class IUserRepository {
  Future<Either<UserFailure, Unit>> saveToken(String userId, String token);

  Future<Either<UserFailure, Unit>> create(User user, {String? pickedFilePath});

  Future<Either<UserFailure, Unit>> update(User user, {String? pickedFilePath});

  Future<Either<UserFailure, User>> getUser(String id);

  Future<Either<SearchUserFailure, List<User>>> searchUsers(
    String userLookupText, {
    List<String>? excludedUsers,
  });
}
