import 'package:familytrusts/src/domain/invitation/invitation.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/presentation/profile/widgets/profile_content.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final User connectedUser;
  final User? spouse;
  final Invitation? spouseProposal;

  const ProfilePage({
    Key? key,
    required this.connectedUser,
    this.spouse,
    this.spouseProposal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProfileContent(
      key: const PageStorageKey<String>('ProfileContent'),
      user: connectedUser,
      spouse: spouse,
      spouseProposal: spouseProposal,
    );
  }
}
