import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/application/join_proposal/family_join_proposal_bloc.dart';
import 'package:familytrusts/src/application/join_proposal/family_join_proposal_event.dart';
import 'package:familytrusts/src/application/join_proposal/family_join_proposal_state.dart';
import 'package:familytrusts/src/domain/join_proposal/i_join_proposal_repository.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/helper/snackbar_helper.dart';
import 'package:familytrusts/src/presentation/core/empty_content.dart';
import 'package:familytrusts/src/presentation/core/join_family_proposal_widget.dart';
import 'package:familytrusts/src/presentation/core/loading_content.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvitationsTab extends StatelessWidget {
  final User connectedUser;
  static const _key = PageStorageKey<String>('invitations');

  const InvitationsTab({super.key, required this.connectedUser});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FamilyJoinProposalBloc>(
      create: (context) =>
          FamilyJoinProposalBloc(getIt<IJoinProposalRepository>())
            ..add(
              FamilyJoinProposalEvent.loadProposals(
                family: connectedUser.family,
              ),
            ),
      child: BlocConsumer<FamilyJoinProposalBloc, FamilyJoinProposalState>(
        listener: (contextFamilyJoinProposalBloc, state) {
          state.map(
            initial: (initial) {},
            joinProposalAcceptInProgress: (joinProposalAcceptInProgress) {
              showProgressMessage(
                LocaleKeys.join_proposal_acceptInProgress.tr(),
                contextFamilyJoinProposalBloc,
              );
            },
            joinProposalAcceptSuccess: (joinProposalAcceptSuccess) {
              showSuccessMessage(
                LocaleKeys.join_proposal_acceptSuccess.tr(),
                contextFamilyJoinProposalBloc,
                onDismissed: () => refresh(contextFamilyJoinProposalBloc),
              );
            },
            joinProposalAcceptFailure: (joinProposalAcceptFailure) {
              showErrorMessage(
                LocaleKeys.join_proposal_acceptFailed.tr(),
                contextFamilyJoinProposalBloc,
                onDismissed: () => refresh(contextFamilyJoinProposalBloc),
              );
            },
            joinProposalDeclineInProgress: (joinProposalDeclineInProgress) {
              showProgressMessage(
                LocaleKeys.join_proposal_declineInProgress.tr(),
                contextFamilyJoinProposalBloc,
              );
            },
            joinProposalDeclineSuccess: (joinProposalDeclineSuccess) {
              showSuccessMessage(
                LocaleKeys.join_proposal_declineSuccess.tr(),
                contextFamilyJoinProposalBloc,
                onDismissed: () => refresh(contextFamilyJoinProposalBloc),
              );
            },
            joinProposalDeclineFailure: (joinProposalDeclineFailure) {
              showErrorMessage(
                LocaleKeys.join_proposal_declineFailed.tr(),
                contextFamilyJoinProposalBloc,
                onDismissed: () => refresh(contextFamilyJoinProposalBloc),
              );
            },
            joinProposalsLoadInProgress: (joinProposalsLoadInProgress) {

            },
            joinProposalsLoaded: (joinProposalsLoaded) {

            },
            joinProposalsLoadFailure: (joinProposalsLoadFailure) {
              showErrorMessage(
                LocaleKeys.join_proposal_loadingFailed.tr(),
                contextFamilyJoinProposalBloc,
                onDismissed: () => refresh(contextFamilyJoinProposalBloc),
              );
            },
          );
        },
        builder: (contextFamilyJoinProposalBloc, state) {
          if (state is FamilyJoinProposalsLoaded) {
            if (!state.hasPendingProposals) {
              return Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: MyText(
                    LocaleKeys.invitations_empty.tr(),
                    style: FontStyle.italic,
                  ),
                ),
              );
            } else {
              if(state.pendingProposals.isEmpty) {
                return const EmptyContent();
              }
              return ListView.separated(
                key: _key,
                padding: const EdgeInsets.all(8),
                itemCount: state.pendingProposals.length,
                itemBuilder: (BuildContext context, int index) {
                  final joinProposal = state.pendingProposals[index];
                  return JoinFamilyProposalWidget(
                    cardWidth: 10.0,
                    connectedUser: connectedUser,
                    asFamily: true,
                    asIssuer: false,
                    joinProposal: joinProposal,
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              );
            }
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  LoadingContent(),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void refresh(BuildContext context) {
    BlocProvider.of<FamilyJoinProposalBloc>(
      context,
    ).add(
      FamilyJoinProposalEvent.loadProposals(
        family: connectedUser.family,
      ),
    );
  }
}
