import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/application/join_proposal/bloc.dart';
import 'package:familytrusts/src/domain/join_proposal/i_join_proposal_repository.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/snackbar_helper.dart';
import 'package:familytrusts/src/presentation/core/my_apps_bars.dart';
import 'package:familytrusts/src/presentation/core/page/my_base_page.dart';
import 'package:familytrusts/src/presentation/family/widgets/missing_family_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageWithoutFamily extends MyBasePage {
  final User connectedUser;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  HomePageWithoutFamily({
    Key? key,
    required this.connectedUser,
  }) : super(key: key);

  @override
  Widget myBuild(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => JoinProposalBloc(
            getIt<IJoinProposalRepository>(),
          )..add(JoinProposalEvent.loadProposals(connectedUser: connectedUser)),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<JoinProposalBloc, JoinProposalState>(
            listener: (joinProposalBlocContext, state) {
              if (state is JoinProposalsLoadFailure) {
                showErrorMessage(
                  LocaleKeys.join_proposal_loadingFailed.tr(),
                  joinProposalBlocContext,
                  onDismissed: () => refresh(joinProposalBlocContext),
                );
              }
              if (state is JoinProposalSendInProgress) {
                showProgressMessage(
                  LocaleKeys.join_proposal_send_inProgress.tr(),
                  joinProposalBlocContext,
                  onDismissed: () => refresh(joinProposalBlocContext),
                );
              }
              if (state is JoinProposalSendSuccess) {
                showSuccessMessage(
                  LocaleKeys.join_proposal_send_success.tr(),
                  joinProposalBlocContext,
                  onDismissed: () => refresh(joinProposalBlocContext),
                );
              }
              if (state is JoinProposalSendFailure) {
                showErrorMessage(
                  LocaleKeys.join_proposal_send_failed.tr(),
                  joinProposalBlocContext,
                  onDismissed: () => refresh(joinProposalBlocContext),
                );
              }

              if (state is JoinProposalCancelInProgress) {
                showProgressMessage(
                  LocaleKeys.join_proposal_cancel_inProgress.tr(),
                  joinProposalBlocContext,
                  onDismissed: () => refresh(joinProposalBlocContext),
                );
              }
              if (state is JoinProposalCancelSuccess) {
                showSuccessMessage(
                  LocaleKeys.join_proposal_cancel_success.tr(),
                  joinProposalBlocContext,
                  onDismissed: () => refresh(joinProposalBlocContext),
                );
              }
              if (state is JoinProposalCancelFailure) {
                showErrorMessage(
                  LocaleKeys.join_proposal_cancel_failed.tr(),
                  joinProposalBlocContext,
                  onDismissed: () => refresh(joinProposalBlocContext),
                );
              }
            },
          ),
        ],
        child: Scaffold(
          key: _scaffoldKey,
          appBar: MyAppBar(
            context: context,
            pageTitle: LocaleKeys.family_title.tr(),
          ),
          body: MissingFamilyContent(
            user: connectedUser,
          ),
        ),
      ),
    );
  }

  void refresh(BuildContext context) {
    return BlocProvider.of<JoinProposalBloc>(
                  context,
                ).add(
                  JoinProposalEvent.loadProposals(
                      connectedUser: connectedUser),
                );
  }
}
