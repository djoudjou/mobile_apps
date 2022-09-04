import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/application/family/children/watcher/children_bloc.dart';
import 'package:familytrusts/src/application/family/children/watcher/children_event.dart';
import 'package:familytrusts/src/application/family/location/watcher/locations_bloc.dart';
import 'package:familytrusts/src/application/family/location/watcher/locations_event.dart';
import 'package:familytrusts/src/application/family/trusted/trusted_watcher/trusted_user_watcher_bloc.dart';
import 'package:familytrusts/src/application/family/trusted/trusted_watcher/trusted_user_watcher_event.dart';
import 'package:familytrusts/src/application/profil/tab/bloc.dart';
import 'package:familytrusts/src/domain/family/child.dart';
import 'package:familytrusts/src/domain/family/locations/location.dart';
import 'package:familytrusts/src/domain/family/trusted_user/trusted.dart';
import 'package:familytrusts/src/domain/family/trusted_user/value_objects.dart';
import 'package:familytrusts/src/domain/family/value_objects.dart';
import 'package:familytrusts/src/domain/profil/profil_tab.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:familytrusts/src/presentation/core/my_apps_bars.dart';
import 'package:familytrusts/src/presentation/core/my_drawer.dart';
import 'package:familytrusts/src/presentation/profile/children/profile_children.dart';
import 'package:familytrusts/src/presentation/profile/locations/profile_locations.dart';
import 'package:familytrusts/src/presentation/profile/trust_user/trusted_user_overview_page.dart';
import 'package:familytrusts/src/presentation/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileContent extends StatefulWidget with LogMixin {
  final User user;
  final User? spouse;

  ProfileContent({
    Key? key,
    required this.user,
    this.spouse,
  }) : super(key: key);

  @override
  _ProfileContentState createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 3,
      vsync: this,
    )..addListener(() {});
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double radius = 60;
    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileTabBloc, ProfileTabState>(
          listener: (context, state) {
            switch (state.current) {
              case ProfilTab.children:
                _tabController?.index = 0;
                break;
              case ProfilTab.trustedUsers:
                _tabController?.index = 1;
                break;
              case ProfilTab.locations:
                _tabController?.index = 2;
                break;
            }
          },
        ),
      ],
      child: BlocBuilder<ProfileTabBloc, ProfileTabState>(
        builder: (profileContext, state) {
          switch (state.current) {
            case ProfilTab.children:
              _tabController?.index = 0;
              break;
            case ProfilTab.trustedUsers:
              _tabController?.index = 1;
              break;
            case ProfilTab.locations:
              _tabController?.index = 2;
              break;
          }

          return DefaultTabController(
            length: 3,
            child: Scaffold(
              drawer: MyDrawer(user: widget.user, spouse: widget.spouse),
              appBar: MyAppBar(
                context: profileContext,
                pageTitle: LocaleKeys.family_title.tr(),
                bottom: TabBar(
                  onTap: (index) {
                    final profileTabBloc =
                        profileContext.read<ProfileTabBloc>();
                    if (index == 0) {
                      profileTabBloc.add(const ProfileTabEvent.gotoChildren());
                    } else if (index == 1) {
                      profileTabBloc
                          .add(const ProfileTabEvent.gotoTrustedUsers());
                    } else if (index == 2) {
                      profileTabBloc.add(const ProfileTabEvent.gotoLocations());
                    }
                  },
                  isScrollable: true,
                  controller: _tabController,
                  tabs: <Tab>[
                    Tab(
                      text: LocaleKeys.profile_tabs_children_tab.tr(),
                      icon: const Icon(FontAwesomeIcons.child),
                    ),
                    Tab(
                      text: LocaleKeys.profile_tabs_trusted_tab.tr(),
                      icon: const Icon(FontAwesomeIcons.handshake),
                    ),
                    Tab(
                      text: LocaleKeys.profile_tabs_locations_tab.tr(),
                      icon: const Icon(FontAwesomeIcons.mapLocation),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  ProfileChildren(
                    connectedUser: widget.user,
                    radius: radius,
                  ),
                  ProfileTrustedUsers(
                    radius: radius,
                    connectedUser: widget.user,
                  ),
                  ProfileLocations(
                    radius: radius,
                    connectedUser: widget.user,
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: _tabController?.index == 0
                    ? Colors.red
                    : (_tabController?.index == 1 ? Colors.green : Colors.blue),
                onPressed: () {
                  if (_tabController?.index == 0) {
                    gotoEditChild(
                      currentUser: widget.user,
                      context: profileContext,
                      child: Child(
                        firstName: FirstName(' '),
                        lastName: LastName(' '),
                        birthday: Birthday.defaultValue(),
                      ),
                      editing: true,
                    );
                  } else if (_tabController?.index == 1) {
                    gotoEditTrustUserScreen(
                      context: context,
                      trustedUser: TrustedUser(
                        firstName: FirstName(''),
                        lastName: LastName(''),
                        email: EmailAddress(''),
                        phoneNumber: PhoneNumber(''),
                      ),
                      currentUser: widget.user,
                      imageTag: '',
                    );
                  } else if (_tabController?.index == 2) {
                    gotoEditLocation(
                      profileContext,
                      Location(
                        address: Address(""),
                        note: NoteBody(""),
                        title: Name(""),
                        photoUrl: "",
                        gpsPosition: GpsPosition.fromPosition(
                          latitude: 0,
                          longitude: 0,
                        ),
                      ),
                      widget.user,
                    );
                  }
                },
                child: const Icon(Icons.add),
              ),
            ),
            //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          );
        },
      ),
    );
  }
}

void gotoEditUserScreen({
  required User user,
  required User currentUser,
  required BuildContext context,
}) {
  AutoRouter.of(context).push(
    UserPageRoute(
      imageTag: "TAG_USER_${user.id}",
      connectedUser: currentUser,
      userToEdit: user,
    ),
  );
}

void gotoEditChild({
  required BuildContext context,
  required User currentUser,
  required bool editing,
  required Child child,
}) {
  AutoRouter.of(context)
      .push(
    ChildPageRoute(
      child: child,
      imageTag: "TAG_CHILD_${child.id}",
      isEditing: editing,
      connectedUser: currentUser,
    ),
  )
      .then((value) {
    if (value != null) {
      context
          .read<ChildrenBloc>()
          .add(ChildrenEvent.loadChildren(currentUser.family!.id));
    }
  });
}

void gotoEditLocation(
  BuildContext context,
  Location location,
  User currentUser,
) {
  AutoRouter.of(context)
      .push(
    LocationPageRoute(locationToEdit: location, currentUser: currentUser),
  )
      .then((value) {
    if (value != null) {
      context
          .read<LocationsBloc>()
          .add(LocationsEvent.loadLocations(currentUser.family!.id));
    }
  });
}

void gotoEditTrustUserScreen({
  required BuildContext context,
  required TrustedUser trustedUser,
  required User currentUser,
  required String imageTag,
}) {
  AutoRouter.of(context)
      .push(TrustUserPageRoute(
    trustedUserToEdit: trustedUser,
    connectedUser: currentUser,
    imageTag: imageTag,
  ))
      .then((value) {
    if (value != null) {
      context.read<TrustedUserWatcherBloc>().add(
            TrustedUserWatcherEvent.loadTrustedUsers(
              currentUser.family!.id,
            ),
          );
    }
  });
}
