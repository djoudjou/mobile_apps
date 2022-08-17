import 'package:familytrusts/src/domain/error/i_error_service.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

//import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';

@injectable
class AnalyticsSvc with LogMixin {
  final FirebaseAnalytics _firebaseAnalytics;

  //final Crashlytics _crashlytics;
  final IErrorService _errorService;

  AnalyticsSvc(
    this._firebaseAnalytics,
    this._errorService,
    //this._crashlytics,
  );

  Future<void> loginWithGoogle(String userId) async {
    await _firebaseAnalytics.setUserId(id: userId);
    await _firebaseAnalytics.logLogin(loginMethod: "LogWithGoogleSignIn");
  }

  Future<void> loginWithLoginPwd(String userId) async {
    await _firebaseAnalytics.setUserId(id: userId);
    await _firebaseAnalytics.logLogin(loginMethod: "LogWithLoginPwd");
  }

  Future<void> missingUser(String userId) async {
    await _firebaseAnalytics.logEvent(
      name: 'getUserError',
      parameters: <String, dynamic>{
        "method": "getUser",
        "param": userId,
      },
    );
  }

  Future<void> debug(String msg) async {
    log(msg);
    await _errorService.logInfo(msg);
    //_crashlytics.log(msg);
  }

  Future<void> loginWithFacebook(String userId) async {
    await _firebaseAnalytics.setUserId(id: userId);
    await _firebaseAnalytics.logLogin(loginMethod: "LogWithFacebookSignIn");
  }
}
