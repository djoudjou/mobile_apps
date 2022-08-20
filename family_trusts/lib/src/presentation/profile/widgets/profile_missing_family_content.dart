import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/locale_keys.g.dart';
import 'package:familytrusts/src/application/family/setup/bloc.dart';
import 'package:familytrusts/src/application/home/user/bloc.dart';
import 'package:familytrusts/src/application/home/user/user_bloc.dart';
import 'package:familytrusts/src/domain/family/family.dart';
import 'package:familytrusts/src/domain/invitation/invitation.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/value_objects.dart';
import 'package:familytrusts/src/helper/alert_helper.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:familytrusts/src/presentation/core/my_text.dart';
import 'package:familytrusts/src/presentation/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileMissingFamilyContent extends StatelessWidget with LogMixin {
  final Invitation? spouseProposal;
  final User user;

  const ProfileMissingFamilyContent({
    Key? key,
    required this.spouseProposal,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      //color: Colors.red,
      margin: const EdgeInsets.all(10.0),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          buidCreateFamily(context),
          if (spouseProposal != null) ...[
            buildSpouseProposal(spouseProposal!, context),
          ] else ...[
            buidConnectToFamily(context),
          ]
        ],
      ),
    );
  }

  Widget buidCreateFamily(BuildContext context) {
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
            LocaleKeys.profile_createNewFamilyConfirm.tr(),
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
          context
              .pushRoute(
            SearchUserPageRoute(
              connectedUser: user,
              lookingForNewTrustUser: false,
            ),
          )
              .then((_selectedUser) async {
            if (_selectedUser != null) {
              final User selectedUser = _selectedUser as User;
              await AlertHelper().confirm(
                context,
                LocaleKeys.profile_sendSpouseProposal
                    .tr(args: [selectedUser.displayName]),
                onConfirmCallback: () {
                  context.read<SetupFamilyBloc>().add(
                        SetupFamilyEvent.askToJoinFamilyTriggered(
                          from: user,
                          to: selectedUser,
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

  Widget buildSpouseProposal(Invitation spouseProposal, BuildContext context) {
    final String subject = (user.id == spouseProposal.from.id)
        ? "Vous"
        : "${spouseProposal.from.surname}";
    return Card(
      elevation: 8,
      child: Container(
        //color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              MyText(
                "$subject avez demandé à ${spouseProposal.to.displayName} de confirmer votre relation ${spouseProposal.date.toPrintableDate}",
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
                      "Annuler l'invitation à ${spouseProposal.to.displayName} ?",
                      onConfirmCallback: () {
                        BlocProvider.of<SetupFamilyBloc>(context).add(
                          SetupFamilyEvent.joinFamilyCancelTriggered(
                            invitation: spouseProposal,
                          ),
                        );
                      },
                    );
                  },
                  child: const MyText(
                    "Annuler la demande",
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
