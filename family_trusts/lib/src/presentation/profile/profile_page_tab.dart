import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/application/family/children/watcher/children_bloc.dart';
import 'package:familytrusts/src/application/family/children/watcher/children_event.dart';
import 'package:familytrusts/src/application/family/location/watcher/locations_bloc.dart';
import 'package:familytrusts/src/application/family/location/watcher/locations_event.dart';
import 'package:familytrusts/src/application/family/trusted/trusted_watcher/trusted_user_watcher_bloc.dart';
import 'package:familytrusts/src/application/family/trusted/trusted_watcher/trusted_user_watcher_event.dart';
import 'package:familytrusts/src/application/profil/tab/bloc.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:familytrusts/src/domain/profil/profil_tab.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/presentation/profile/widgets/profile_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePageTab extends StatelessWidget {
  final User connectedUser;
  final User? spouse;

  const ProfilePageTab({
    super.key,
    required this.connectedUser,
    this.spouse,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProfileTabBloc()
            ..add(
              const ProfileTabEvent.init(
                ProfilTab.children,
              ),
            ),
        ),
        BlocProvider(
          create: (BuildContext context) => ChildrenBloc(
            getIt<IFamilyRepository>(),
          )..add(ChildrenEvent.loadChildren(connectedUser.family!.id)),
        ),
        BlocProvider<LocationsBloc>(
          create: (BuildContext context) =>
              LocationsBloc(getIt<IFamilyRepository>())
                ..add(LocationsEvent.loadLocations(connectedUser.family!.id)),
        ),
        BlocProvider<TrustedUserWatcherBloc>(
          create: (BuildContext context) => TrustedUserWatcherBloc(
            getIt<IFamilyRepository>(),
          )..add(
              TrustedUserWatcherEvent.loadTrustedUsers(
                connectedUser.family!.id,
              ),
            ),
        ),
      ],
      child: ProfileContent(
        key: const PageStorageKey<String>('ProfileContent'),
        user: connectedUser,
        spouse: spouse,
      ),
    );
  }
}
