import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/application/home/user/bloc.dart';
import 'package:familytrusts/src/application/join_proposal/bloc.dart';
import 'package:familytrusts/src/domain/family/family.dart';
import 'package:familytrusts/src/domain/join_proposal/join_proposal.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:familytrusts/src/helper/alert_helper.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:familytrusts/src/presentation/core/empty_content.dart';
import 'package:familytrusts/src/presentation/core/join_family_proposal_widget.dart';
import 'package:familytrusts/src/presentation/core/loading_content.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:familytrusts/src/presentation/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MissingFamilyContent extends StatelessWidget with LogMixin {
  final User user;

  const MissingFamilyContent({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IssuerJoinProposalBloc, IssuerJoinProposalState>(
      builder: (joinProposalBlocContext, state) {
        return Container(
          width: double.infinity,
          //color: Colors.red,
          margin: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildCreateFamily(joinProposalBlocContext),
              if (state is JoinProposalsLoaded &&
                  state.hasPendingProposals) ...[
                state.optionPendingJoinProposal.fold(
                  () => const EmptyContent(),
                  (pendingJoinProposal) => buildJoinProposals(
                    pendingJoinProposal,
                    joinProposalBlocContext,
                  ),
                )
              ],
              if (state is JoinProposalsLoaded &&
                  !state.hasPendingProposals) ...[
                buidConnectToFamily(joinProposalBlocContext),
                if (state.archives.isNotEmpty) ...[
                  //buildArchivedJoinFamilyProposals(
                  //  state.archives,
                  //  joinProposalBlocContext,
                  //),
                ]
              ],
              if (state is JoinProposalsLoadInProgress) ...[
                const LoadingContent(),
              ]
            ],
          ),
        );
      },
    );
  }

  Widget buildCreateFamily(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.blueAccent,
          backgroundColor: Colors.blueAccent,
          minimumSize: const Size(88, 36),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
        ),
        onPressed: () async {
          await AlertHelper().confirm(
            context,
            LocaleKeys.family_create_confirm.tr(),
            onConfirmCallback: () {
              AutoRouter.of(context)
                  .push(
                FamilyPageRoute(
                  key: const ValueKey("FamilyPage"),
                  familyToEdit: Family(name: FirstName('')),
                  currentUser: user,
                ),
              )
                  .then((value) {
                if (value != null) {
                  log("returned from 'create family Page' $value");
                  // reload user
                  BlocProvider.of<UserBloc>(context)
                      .add(UserEvent.init(user.id!));
                }
              });
            },
          );
        },
        child: MyText(
          LocaleKeys.profile_createNewFamily.tr(),
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buidConnectToFamily(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.blueAccent,
          backgroundColor: Colors.blueAccent,
          minimumSize: const Size(88, 36),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
        ),
        onPressed: () async {
          AutoRouter.of(context)
              .push(
            SearchFamilyPageRoute(
              key: const ValueKey("SearchFamilyPage"),
            ),
          )
              .then((selected) async {
            if (selected != null) {
              final Family selectedFamily = selected as Family;
              await AlertHelper().confirm(
                context,
                LocaleKeys.join_proposal_send_confirm
                    .tr(args: [selectedFamily.displayName]),
                onConfirmCallback: () {
                  context.read<IssuerJoinProposalBloc>().add(
                        IssuerJoinProposalEvent.send(
                          connectedUser: user,
                          family: selectedFamily,
                        ),
                      );
                },
              );
            }
          });
        },
        child: MyText(
          LocaleKeys.profile_rejoinFamily.tr(),
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildJoinProposals(
    JoinProposal joinProposal,
    BuildContext context,
  ) {
    return JoinFamilyProposalWidget(
      cardWidth: MediaQuery.of(context).size.width * .7,
      joinProposal: joinProposal,
      asIssuer: true,
      asFamily: false,
      connectedUser: user,
    );
  }
}
