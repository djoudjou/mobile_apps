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
import 'package:familytrusts/src/presentation/core/loading_content.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:familytrusts/src/presentation/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MissingFamilyContent extends StatelessWidget with LogMixin {
  final User user;

  const MissingFamilyContent({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JoinProposalBloc, JoinProposalState>(
        builder: (joinProposalBlocContext, state) {
      return Container(
        width: double.infinity,
        //color: Colors.red,
        margin: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildCreateFamily(joinProposalBlocContext),
            if (state is JoinProposalsLoaded && state.hasProposals) ...[
              buildJoinProposals(state.joinProposals, joinProposalBlocContext),
            ],
            if (state is JoinProposalsLoaded && !state.hasProposals) ...[
              buidConnectToFamily(joinProposalBlocContext),
            ],
            if (state is JoinProposalsLoadInProgress) ...[
              const LoadingContent(),
            ]
          ],
        ),
      );
    });
  }

  Widget buildCreateFamily(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.blueAccent,
          primary: Colors.blueAccent,
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
                  familyToEdit: Family(name: Name('')),
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
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.blueAccent,
          primary: Colors.blueAccent,
          minimumSize: const Size(88, 36),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
        ),
        onPressed: () async {
          AutoRouter.of(context)
              .replace(SearchFamilyPageRoute())
              .then((selected) async {
            if (selected != null) {
              final Family selectedFamily = selected as Family;
              await AlertHelper().confirm(
                context,
                LocaleKeys.join_proposal_send_confirm
                    .tr(args: [selectedFamily.displayName]),
                onConfirmCallback: () {
                  context.read<JoinProposalBloc>().add(
                        JoinProposalEvent.send(
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
      List<JoinProposal> proposals, BuildContext context) {
    final JoinProposal joinProposal = proposals.first;
    return Card(
      elevation: 8,
      child: Container(
        //color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              MyText(
                LocaleKeys.join_proposal_summary.tr(args: [
                  joinProposal.family!.displayName,
                  joinProposal.creationDate.toPrintableDate,
                ]),
                maxLines: 5,
                style: FontStyle.italic,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              Container(
                //width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.black87,
                    primary: Colors.red,
                    minimumSize: const Size(88, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                  ),
                  onPressed: () async {
                    await AlertHelper().confirm(
                      context,
                      LocaleKeys.join_proposal_cancel_confirm
                          .tr(args: [joinProposal.family!.displayName]),
                      onConfirmCallback: () {
                        BlocProvider.of<JoinProposalBloc>(context).add(
                          JoinProposalEvent.cancel(
                            connectedUser: user,
                            joinProposal: joinProposal,
                          ),
                        );
                      },
                    );
                  },
                  child: MyText(
                    LocaleKeys.join_proposal_cancel_button.tr(),
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
