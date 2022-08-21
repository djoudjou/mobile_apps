
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/presentation/profile/widgets/profile_content.dart';
import 'package:flutter/material.dart';

class ProfilePageTab extends StatelessWidget {
  final User connectedUser;
  final User? spouse;

  const ProfilePageTab({
    Key? key,
    required this.connectedUser,
    this.spouse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProfileContent(
      key: const PageStorageKey<String>('ProfileContent'),
      user: connectedUser,
      spouse: spouse,
    );
  }
}
