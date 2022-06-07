

import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:flutter/material.dart';

class LoggerNavigatorObserver extends RouteObserver<PageRoute<dynamic>> with LogMixin {

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    log("didPush from #${previousRoute?.settings}# to #${route.settings}#");
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    log("didReplace old #${oldRoute?.settings}# new #${newRoute?.settings}#");
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);

    log("didPop old #${route.settings}# new #${previousRoute?.settings}#");
  }
}