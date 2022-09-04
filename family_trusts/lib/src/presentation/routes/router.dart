import 'package:auto_route/auto_route.dart';
import 'package:familytrusts/src/presentation/ask/children_lookup/children_lookup_details_page.dart';
import 'package:familytrusts/src/presentation/ask/children_lookup/children_lookup_page.dart';
import 'package:familytrusts/src/presentation/child/child_page.dart';
import 'package:familytrusts/src/presentation/family/family_page.dart';
import 'package:familytrusts/src/presentation/home/home_page.dart';
import 'package:familytrusts/src/presentation/home/home_page_without_family.dart';
import 'package:familytrusts/src/presentation/profile/locations/location_form/location_page.dart';
import 'package:familytrusts/src/presentation/profile/locations/location_form/search/search_address_page.dart';
import 'package:familytrusts/src/presentation/profile/locations/location_form/widgets/select_place_picker.dart';
import 'package:familytrusts/src/presentation/profile/trust_user/trust_user_page.dart';
import 'package:familytrusts/src/presentation/register/register_page.dart';
import 'package:familytrusts/src/presentation/routes/auth_guard.dart';
import 'package:familytrusts/src/presentation/search_family/search_family_page.dart';
import 'package:familytrusts/src/presentation/search_user/search_user_page.dart';
import 'package:familytrusts/src/presentation/sign_in/sign_in_page.dart';
import 'package:familytrusts/src/presentation/splash/splash_page.dart';
import 'package:familytrusts/src/presentation/splash/unknown_page.dart';
import 'package:familytrusts/src/presentation/user/user_page.dart';

//part 'router.gr.dart';

@MaterialAutoRouter(

  routes: <AutoRoute>[
    AutoRoute(page: SignInPage, usesPathAsKey: true),
    AutoRoute(page: RegisterPage, usesPathAsKey: true),
    AutoRoute(page: SearchUserPage, guards: [AuthGuard], usesPathAsKey: true),
    AutoRoute(page: ChildPage, guards: [AuthGuard], usesPathAsKey: true),
    AutoRoute(page: UserPage, guards: [AuthGuard], usesPathAsKey: true),
    AutoRoute(page: LocationPage, guards: [AuthGuard], usesPathAsKey: true),
    AutoRoute(page: FamilyPage, guards: [AuthGuard], usesPathAsKey: true),
    AutoRoute(page: SearchFamilyPage, guards: [AuthGuard], usesPathAsKey: true),
    AutoRoute(page: SelectPlacePickerPage, guards: [AuthGuard], usesPathAsKey: true),
    AutoRoute(page: SearchAddressPage, guards: [AuthGuard], usesPathAsKey: true),
    AutoRoute(page: ChildrenLookupPage, guards: [AuthGuard], usesPathAsKey: true),
    AutoRoute(page: HomePage, guards: [AuthGuard], usesPathAsKey: true),
    AutoRoute(page: HomePageWithoutFamily, guards: [AuthGuard], usesPathAsKey: true),
    AutoRoute(page: TrustUserPage, guards: [AuthGuard], usesPathAsKey: true),
    AutoRoute(page: ChildrenLookupDetailsPage, guards: [AuthGuard], usesPathAsKey: true),
    AutoRoute(path: "*", page: UnknownPage),
    AutoRoute(page: SplashPage, initial: true),
  ],
)
class $MyAppRouter{}
