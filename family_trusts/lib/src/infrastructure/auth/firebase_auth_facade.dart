import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/auth/auth_failure.dart';
import 'package:familytrusts/src/domain/auth/i_auth_facade.dart';
import 'package:familytrusts/src/domain/auth/user_info.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IAuthFacade)
class FirebaseAuthFacade implements IAuthFacade {
  final fire.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;

  bool _loggedWithGoogle = false;
  bool _loggedWithFacebook = false;

  FirebaseAuthFacade(
    this._firebaseAuth,
    this._googleSignIn,
    this._facebookAuth,
  );

  @override
  Option<String> getSignedInUserId() =>
      optionOf(_firebaseAuth.currentUser?.uid);

  @override
  Option<fire.User> getSignedInUser() => optionOf(_firebaseAuth.currentUser);

  @override
  Future<Either<AuthFailure, String>> registerWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
  }) async {
    final emailAddressStr = emailAddress.getOrCrash();
    final passwordStr = password.getOrCrash();
    try {
      final fire.UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: emailAddressStr,
        password: passwordStr,
      );
      return right(userCredential.user!.uid);
    } on PlatformException catch (e) {
      if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        return left(const AuthFailure.emailAlreadyInUse());
      } else {
        return left(const AuthFailure.serverError());
      }
    } on fire.FirebaseAuthException catch(e) {
      if (e.code == 'email-already-in-use') {
        return left(const AuthFailure.emailAlreadyInUse());
      } else {
        return left(const AuthFailure.serverError());
      }
    } catch(e) {
      return left(const AuthFailure.serverError());
    }
  }

  @override
  Future<Either<AuthFailure, String>> signInWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
  }) async {
    final emailAddressStr = emailAddress.getOrCrash();
    final passwordStr = password.getOrCrash();
    try {
      final fire.UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: emailAddressStr,
        password: passwordStr,
      );

      //await createUserIfNotExist(authResult);

      return right(userCredential.user!.uid);
    } on FirebaseException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'user-not-found') {
        return left(const AuthFailure.invalidEmailAndPasswordCombination());
      } else {
        return left(const AuthFailure.serverError());
      }
    }
  }

  @override
  Future<Either<AuthFailure, String>> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return left(const AuthFailure.cancelledByUser());
      }

      final googleAuthentication = await googleUser.authentication;

      final authCredential = fire.GoogleAuthProvider.credential(
        idToken: googleAuthentication.idToken,
        accessToken: googleAuthentication.accessToken,
      );

      final fire.UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(authCredential);

      //await createUserIfNotExist(authResult);

      _loggedWithGoogle = true;
      return right(userCredential.user!.uid);
    } on PlatformException catch (_) {
      return left(const AuthFailure.serverError());
    }
  }

  @override
  Future<Either<AuthFailure, String>> signInWithFacebook() async {
    try {
      final loginResult = await _facebookAuth.login();

      //if (loginResult == null) {
      //  return left(const AuthFailure.cancelledByUser());
      //}

      switch (loginResult.status) {
        case LoginStatus.success:
          //final userData = await _facebookAuth.getUserData();
          // Create a credential from the access token
          final fire.OAuthCredential facebookAuthCredential =
              fire.FacebookAuthProvider.credential(
            loginResult.accessToken!.token,
          );

          // Once signed in, return the UserCredential
          final fire.UserCredential userCredential =
              await _firebaseAuth.signInWithCredential(facebookAuthCredential);

          _loggedWithFacebook = true;

          return right(userCredential.user!.uid);
        case LoginStatus.cancelled:
          return left(const AuthFailure.cancelledByUser());
        default:
          return left(const AuthFailure.serverError());
      }
    } on fire.FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        final String email = e.email!;
        final List<String> userSignInMethods =
            await _firebaseAuth.fetchSignInMethodsForEmail(email);

        return left(
          AuthFailure.alreadySignWithAnotherMethod(userSignInMethods.first),
        );
        /*

        // The account already exists with a different credential
        final String email = e.email;
        final AuthCredential pendingCredential = e.credential;

        // Fetch a list of what sign-in methods exist for the conflicting user
        final List<String> userSignInMethods = await _firebaseAuth.fetchSignInMethodsForEmail(email);

        // If the user has several sign-in methods,
        // the first method in the list will be the "recommended" method to use.
        if (userSignInMethods.first == 'password') {
          // Prompt the user to enter their password
          const String password = '...';

          // Sign the user in to their account with the password
          final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );

          // Link the pending credential with the existing account
          await userCredential.user.linkWithCredential(pendingCredential);
        }



        // Since other providers are now external, you must now sign the user in with another
        // auth provider, such as Facebook.
        if (userSignInMethods.first == FacebookAuthProvider.PROVIDER_ID) {
          // Create a new Facebook credential
          final String accessToken = await triggerFacebookAuthentication();
          final fire.OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(accessToken);

          // Sign the user in with the credential
          UserCredential userCredential = await _firebaseAuth.signInWithCredential(facebookAuthCredential);

          // Link the pending credential with the existing account
          await userCredential.user.linkWithCredential(pendingCredential);
        }



        // Handle other OAuth providers...

         */
      } else {
        return left(const AuthFailure.serverError());
      }
    } on PlatformException catch (_) {
      return left(const AuthFailure.serverError());
    }
  }

  @override
  Future<void> signOut() async {

    await _firebaseAuth.signOut();

    if(_loggedWithGoogle) {
      await _googleSignIn.signOut();
    }

    if(_loggedWithFacebook) {
      await _facebookAuth.logOut();
    }
  }

  @override
  Future<Option<MyUserInfo>> getSignedUserInfo() async {
    final fire.User? user = _firebaseAuth.currentUser;

    final Option<MyUserInfo> optionUserInfo = await getUserInfo(user);

    if (optionUserInfo.isSome()) {
      final MyUserInfo? userInfo = optionUserInfo.toNullable();
      if (userInfo!.displayName == null) {
        await _firebaseAuth.signOut();
        return none();
      }
    }
    return optionUserInfo;
  }

  Future<Option<MyUserInfo>> getUserInfo(fire.User? user) async {
    if (user != null) {
      if (user.providerData.first.providerId ==
          fire.FacebookAuthProvider.PROVIDER_ID) {
        final email = user.providerData.first.email;
        //final AccessToken accessToken = await _facebookAuth.isLogged;
        final userData = await _facebookAuth.getUserData();
        //final graphResponse = await http.get(
        //    'https://graph.facebook.com/v2.12/me?fields=name,picture.width(800).height(800),first_name,last_name,email&access_token=${accessToken.token}');
        final photoUrl = userData["picture"]["data"]["url"] as String;

        return some(
          MyUserInfo(
            email: email,
            photoUrl: photoUrl,
            displayName: user.providerData.first.displayName,
          ),
        );
      } else {
        return some(
          MyUserInfo(
            email: user.email,
            photoUrl: user.photoURL,
            displayName: user.displayName,
          ),
        );
      }
    } else {
      return none();
    }
  }

  @override
  Future<String> getToken() async {
    final fire.User? user = _firebaseAuth.currentUser;
    if (user != null) {
      return user.getIdToken();
    } else {
      return "";
    }
  }
}
