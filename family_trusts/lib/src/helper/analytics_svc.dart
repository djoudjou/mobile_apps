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

  void loginWithGoogle(String userId) {
    _firebaseAnalytics.setUserId(id: userId);
    _firebaseAnalytics.logLogin(loginMethod: "LogWithGoogleSignIn");
  }

  void loginWithLoginPwd(String userId) {
    _firebaseAnalytics.setUserId(id: userId);
    _firebaseAnalytics.logLogin(loginMethod: "LogWithLoginPwd");
  }

  void missingUser(String userId) {
    _firebaseAnalytics.logEvent(
      name: 'getUserError',
      parameters: <String, dynamic>{
        "method": "getUser",
        "param": userId,
      },
    );
  }

  void debug(String msg) {
    log(msg);
    _errorService.logInfo(msg);
    //_crashlytics.log(msg);
  }

  void loginWithFacebook(String userId) {
    _firebaseAnalytics.setUserId(id: userId);
    _firebaseAnalytics.logLogin(loginMethod: "LogWithFacebookSignIn");
  }
}
