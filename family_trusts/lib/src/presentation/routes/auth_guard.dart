import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/domain/auth/i_auth_facade.dart';
import 'package:familytrusts/src/presentation/routes/router.gr.dart';
import 'package:flutter/material.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final Option<String> optionUser = getIt<IAuthFacade>().getSignedInUserId();

    if (optionUser.isSome()) {
      resolver.next(true);
    } else {
      router.push(
        SignInPageRoute(
          key: const ValueKey("SignInPage"),
        ),
      );
    }
  }
}
