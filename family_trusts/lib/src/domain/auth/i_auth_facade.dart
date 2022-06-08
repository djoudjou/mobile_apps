import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/auth/auth_failure.dart';
import 'package:familytrusts/src/domain/auth/user_info.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthFacade {
  Option<String> getSignedInUserId();

  Future<Either<AuthFailure, String>> registerWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
  });

  Future<Either<AuthFailure, String>> signInWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
  });

  Future<Either<AuthFailure, String>> signInWithGoogle();

  Future<Either<AuthFailure, String>> signInWithFacebook();

  Future<void> signOut();

  Option<User> getSignedInUser();

  Future<Option<MyUserInfo>> getSignedUserInfo();
}
