import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/application/family/setup/bloc.dart';
import 'package:familytrusts/src/application/profil/tab/bloc.dart';
import 'package:familytrusts/src/domain/family/child.dart';
import 'package:familytrusts/src/domain/family/locations/location.dart';
import 'package:familytrusts/src/domain/family/value_objects.dart';
import 'package:familytrusts/src/domain/invitation/invitation.dart';
import 'package:familytrusts/src/domain/profil/profil_tab.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:familytrusts/src/helper/snackbar_helper.dart';
import 'package:familytrusts/src/presentation/core/my_apps_bars.dart';
import 'package:familytrusts/src/presentation/core/my_drawer.dart';
import 'package:familytrusts/src/presentation/profile/children/profile_children.dart';
import 'package:familytrusts/src/presentation/profile/locations/profile_locations.dart';
import 'package:familytrusts/src/presentation/profile/trusted_users/trusted_users_overview/trusted_user_overview_page.dart';
import 'package:familytrusts/src/presentation/profile/widgets/profile_missing_family_content.dart';
import 'package:familytrusts/src/presentation/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiver/strings.dart' as quiver;

class ProfileContent extends StatefulWidget with LogMixin {
  final User user;
  final User? spouse;
  final Invitation? spouseProposal;

  ProfileContent({
    Key? key,
    required this.user,
    this.spouse,
    this.spouseProposal,
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
    final bool displayFamilyContent = quiver.isNotBlank(widget.user.familyId);
    return MultiBlocListener(
      listeners: [
        BlocListener<SetupFamilyBloc, SetupFamilyState>(
          listener: (setupFamilyBlocContext, state) {
            state.map(
              acceptInvitationFailed: (_) => showErrorMessage(
                LocaleKeys.profile_acceptInvitationFailed.tr(),
                setupFamilyBlocContext,
              ),
              acceptInvitationInProgress: (_) => showSuccessMessage(
                LocaleKeys.profile_acceptInvitationInProgress.tr(),
                setupFamilyBlocContext,
              ),
              acceptInvitationSuccess: (_) => showSuccessMessage(
                LocaleKeys.profile_acceptInvitationSuccess.tr(),
                setupFamilyBlocContext,
              ),
              declineInvitationFailed: (_) => showErrorMessage(
                LocaleKeys.profile_declineInvitationFailed.tr(),
                setupFamilyBlocContext,
              ),
              declineInvitationInProgress: (_) => showProgressMessage(
                LocaleKeys.profile_declineInvitationInProgress.tr(),
                setupFamilyBlocContext,
              ),
              declineInvitationSuccess: (_) => showSuccessMessage(
                LocaleKeys.profile_declineInvitationSuccess.tr(),
                setupFamilyBlocContext,
              ),
              setupFamilyInitial: (s) => null,
              setupFamilyNewFamilyInProgress: (s) {
                showProgressMessage(
                  LocaleKeys.profile_setupFamilyNewFamilyInProgress.tr(),
                  setupFamilyBlocContext,
                );
              },
              setupFamilyNewFamilySuccess: (s) {
                showSuccessMessage(
                  LocaleKeys.profile_setupFamilyNewFamilySuccess.tr(),
                  setupFamilyBlocContext,
                );
              },
              setupFamilyNewFamilyFailed: (s) {
                showErrorMessage(
                  LocaleKeys.profile_setupFamilyNewFamilyFailed.tr(),
                  setupFamilyBlocContext,
                );
              },
              setupFamilyAskForJoinFamilyInProgress: (s) {
                showProgressMessage(
                  LocaleKeys.profile_setupFamilyAskForJoinFamilyInProgress.tr(),
                  setupFamilyBlocContext,
                );
              },
              setupFamilyAskForJoinFamilySuccess: (s) {
                showSuccessMessage(
                  LocaleKeys.profile_setupFamilyAskForJoinFamilySuccess.tr(),
                  setupFamilyBlocContext,
                );
              },
              setupFamilyAskForJoinFamilyFailed: (s) {
                showErrorMessage(
                  LocaleKeys.profile_setupFamilyAskForJoinFamilyFailed.tr(),
                  setupFamilyBlocContext,
                );
              },
              setupFamilyJoinFamilyCancelInProgress: (s) {
                showProgressMessage(
                  LocaleKeys.profile_setupFamilyJoinFamilyCancelInProgress.tr(),
                  setupFamilyBlocContext,
                );
              },
              setupFamilyJoinFamilyCancelSuccess: (s) {
                showSuccessMessage(
                  LocaleKeys.profile_setupFamilyJoinFamilyCancelSuccess.tr(),
                  setupFamilyBlocContext,
                );
              },
              setupFamilyJoinFamilyCancelFailed: (s) {
                showErrorMessage(
                  LocaleKeys.profile_setupFamilyJoinFamilyCancelFailed.tr(),
                  setupFamilyBlocContext,
                );
              },
              endedSpouseRelationFailed: (s) {
                showErrorMessage(
                  LocaleKeys.profile_endedSpouseRelationFailed.tr(),
                  setupFamilyBlocContext,
                );
              },
              endedSpouseRelationInProgress: (s) {
                showProgressMessage(
                  LocaleKeys.profile_endedSpouseRelationInProgress.tr(),
                  setupFamilyBlocContext,
                );
              },
              endedSpouseRelationSuccess: (s) {
                showSuccessMessage(
                  LocaleKeys.profile_endedSpouseRelationSuccess.tr(),
                  setupFamilyBlocContext,
                );
              },
            );
          },
        ),
        BlocListener<ProfilTabBloc, ProfilTabState>(
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
      child: BlocBuilder<ProfilTabBloc, ProfilTabState>(
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

          return (!displayFamilyContent)
              ? Scaffold(
                  drawer: MyDrawer(user: widget.user, spouse: widget.spouse),
                  appBar: MyAppBar(
                    context: profileContext,
                    pageTitle: LocaleKeys.family_title.tr(),
                  ),
                  body: ProfileMissingFamilyContent(
                    user: widget.user,
                    spouseProposal: widget.spouseProposal,
                  ),
                )
              : DefaultTabController(
                  length: 3,
                  child: Scaffold(
                    drawer: MyDrawer(user: widget.user, spouse: widget.spouse),
                    appBar: MyAppBar(
                      context: profileContext,
                      pageTitle: LocaleKeys.family_title.tr(),
                      bottom: TabBar(
                        onTap: (index) {
                          final profileTabBloc =
                              profileContext.read<ProfilTabBloc>();
                          if (index == 0) {
                            profileTabBloc
                                .add(const ProfilTabEvent.gotoChildren());
                          } else if (index == 1) {
                            profileTabBloc
                                .add(const ProfilTabEvent.gotoTrustedUsers());
                          } else if (index == 2) {
                            profileTabBloc
                                .add(const ProfilTabEvent.gotoLocations());
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
                        ProfileTrusted(
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
                          : (_tabController?.index == 1
                              ? Colors.green
                              : Colors.blue),
                      onPressed: () {
                        if (_tabController?.index == 0) {
                          gotoEditChild(
                            currentUser: widget.user,
                            context: profileContext,
                            child: Child(
                              name: Name(' '),
                              surname: Surname(' '),
                              birthday: Birthday.defaultValue(),
                            ),
                            editing: true,
                          );
                        } else if (_tabController?.index == 1) {
                          gotoAddTrustedUser(profileContext, widget.user);
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
  AutoRouter.of(context).navigate(
    ChildPageRoute(
      child: child,
      imageTag: "TAG_CHILD_${child.id}",
      isEditing: editing,
      connectedUser: currentUser,
    ),
  );
}

void gotoAddTrustedUser(BuildContext context, User currentUser) {
  AutoRouter.of(context).navigate(
    TrustedUserFormPageRoute(
      connectedUser: currentUser,
    ),
  );
}
