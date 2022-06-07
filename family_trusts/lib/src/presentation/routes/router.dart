import 'package:auto_route/auto_route.dart';
import 'package:familytrusts/src/presentation/ask/children_lookup/children_lookup_details_page.dart';
import 'package:familytrusts/src/presentation/ask/children_lookup/children_lookup_page.dart';
import 'package:familytrusts/src/presentation/demands/demands_page.dart';
import 'package:familytrusts/src/presentation/home/home_page.dart';
import 'package:familytrusts/src/presentation/profile/locations/location_form/location_page.dart';
import 'package:familytrusts/src/presentation/profile/locations/location_form/search/search_address_page.dart';
import 'package:familytrusts/src/presentation/profile/locations/location_form/widgets/select_place_picker.dart';
import 'package:familytrusts/src/presentation/profile/trusted_users/trusted_user_form/trusted_user_form_page.dart';
import 'package:familytrusts/src/presentation/register/register_page.dart';
import 'package:familytrusts/src/presentation/search_user/search_user_page.dart';
import 'package:familytrusts/src/presentation/sign_in/sign_in_page.dart';
import 'package:familytrusts/src/presentation/child/child_page.dart';
import 'package:familytrusts/src/presentation/splash/splash_page.dart';
import 'package:familytrusts/src/presentation/splash/unknown_page.dart';
import 'package:familytrusts/src/presentation/user/user_page.dart';

import 'auth_guard.dart';


@MaterialAutoRouter(
  routes: <AutoRoute>[
    MaterialRoute(page: SignInPage, usesPathAsKey: true),
    MaterialRoute(page: RegisterPage, usesPathAsKey: true),
    MaterialRoute(page: SearchUserPage, guards: [AuthGuard], usesPathAsKey: true),
    MaterialRoute(page: ChildPage, guards: [AuthGuard], usesPathAsKey: true),
    MaterialRoute(page: UserPage, guards: [AuthGuard], usesPathAsKey: true),
    MaterialRoute(page: LocationPage, guards: [AuthGuard], usesPathAsKey: true),
    MaterialRoute(page: SelectPlacePickerPage, guards: [AuthGuard], usesPathAsKey: true),
    MaterialRoute(page: SearchAddressPage, guards: [AuthGuard], usesPathAsKey: true),
    MaterialRoute(page: ChildrenLookupPage, guards: [AuthGuard], usesPathAsKey: true),
    MaterialRoute(page: DemandsPage, guards: [AuthGuard], usesPathAsKey: true),
    MaterialRoute(page: HomePage, guards: [AuthGuard], usesPathAsKey: true),
    MaterialRoute(page: TrustedUserFormPage, guards: [AuthGuard], usesPathAsKey: true),
    MaterialRoute(page: ChildrenLookupDetailsPage, guards: [AuthGuard], usesPathAsKey: true),
    MaterialRoute(path: "*", page: UnknownPage),
    MaterialRoute(page: SplashPage, initial: true),
  ],
)
class $MyAppRouter {}
