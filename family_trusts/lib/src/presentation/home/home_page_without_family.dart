import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/application/auth/bloc.dart';
import 'package:familytrusts/src/application/family/setup/bloc.dart';
import 'package:familytrusts/src/application/home/user/user_bloc.dart';
import 'package:familytrusts/src/application/home/user/user_state.dart';
import 'package:familytrusts/src/domain/family/i_family_repository.dart';
import 'package:familytrusts/src/domain/home/app_tab.dart';
import 'package:familytrusts/src/domain/invitation/i_spouse_proposal_repository.dart';
import 'package:familytrusts/src/domain/invitation/invitation.dart';
import 'package:familytrusts/src/domain/notification/i_notification_repository.dart';
import 'package:familytrusts/src/domain/user/i_user_repository.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/analytics_svc.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:familytrusts/src/helper/snackbar_helper.dart';
import 'package:familytrusts/src/presentation/core/my_apps_bars.dart';
import 'package:familytrusts/src/presentation/profile/widgets/profile_missing_family_content.dart';
import 'package:familytrusts/src/presentation/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageWithoutFamily extends StatelessWidget with LogMixin {
  final User connectedUser;
  final Invitation? spouseProposal;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  HomePageWithoutFamily({
    Key? key,
    required this.connectedUser,
    this.spouseProposal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SetupFamilyBloc(
            getIt<IUserRepository>(),
            getIt<IFamilyRepository>(),
            getIt<ISpouseProposalRepository>(),
            getIt<INotificationRepository>(),
            getIt<AnalyticsSvc>(),
          ),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<UserBloc, UserState>(
            listener: (userBlocContext, state) {
              if (state is UserLoadFailure) {
                //showErrorMessage(LocaleKeys.global_serverError.tr(),context,);
                AutoRouter.of(userBlocContext).replace(const SignInPageRoute());
              } else if (state is UserLoadSuccess) {
                final User user = state.user;

                if (user.notInFamily()) {
                  // navigation ver
                  AutoRouter.of(userBlocContext).replace(
                    HomePageWithoutFamilyRoute(
                      connectedUser: user,
                    ),
                  );
                } else {
                  AutoRouter.of(userBlocContext).replace(
                    HomePageRoute(
                      currentTab: AppTab.ask,
                      connectedUserId: user.id!,
                    ),
                  );
                }
              }
            },
          ),
          BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (authenticationBlocContext, state) {
              if (state is Unauthenticated) {
                log("=== logouted ===");
                AutoRouter.of(authenticationBlocContext)
                    .replace(const SignInPageRoute());
              }
            },
          ),
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
                    LocaleKeys.profile_setupFamilyAskForJoinFamilyInProgress
                        .tr(),
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
                    LocaleKeys.profile_setupFamilyJoinFamilyCancelInProgress
                        .tr(),
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
        ],
        child: BlocBuilder<SetupFamilyBloc, SetupFamilyState>(
          builder: (profileContext, state) {
            return Scaffold(
              key: _scaffoldKey,
              //drawer: MyDrawer(user: widget.user, spouse: widget.spouse),
              appBar: MyAppBar(
                context: profileContext,
                pageTitle: LocaleKeys.family_title.tr(),
              ),
              body: ProfileMissingFamilyContent(
                user: connectedUser,
                spouseProposal: spouseProposal,
              ),
            );
          },
        ),
      ),
    );
  }
}
