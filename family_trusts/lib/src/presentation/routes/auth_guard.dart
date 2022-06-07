import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/domain/auth/i_auth_facade.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final Option<String> optionUser = getIt<IAuthFacade>().getSignedInUserId();
    resolver.next(optionUser.isSome());
  }
}
