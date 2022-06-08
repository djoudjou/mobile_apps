import 'package:familytrusts/src/domain/invitation/invitation.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/presentation/profile/widgets/profile_appbar.dart';
import 'package:flutter/material.dart';

class ProfilCustomScrollView extends StatelessWidget {
  final User user;
  final Invitation spouseProposal;
  final User spouse;
  final TabBar tabBar;
  final ScrollController _scrollViewController;
  final Widget body;
  final double radius;

  const ProfilCustomScrollView(
    this._scrollViewController, {
    Key? key,
    required this.user,
    required this.spouseProposal,
    required this.spouse,
    required this.body,
    required this.tabBar,
    required this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: _scrollViewController,
      headerSliverBuilder: (BuildContext bc, bool innerBoxIsScrolled) {
        // These are the slivers that show up in the "outer" scroll view.
        return <Widget>[
          ProfileAppBar(
            tabBar,
            context: bc,
            currentUser: user,
            spouse: spouse,
            radius: radius,
            innerBoxIsScrolled: innerBoxIsScrolled,
          ),
        ];
      },
      body: body,
    );
  }
}

/*

slivers: [
        ProfileAppBar(
          _tabController,
          context: context,
          currentUser: user,
          spouse: spouse,
          radius: radius,
        ),
        if (displayFamilyContent) ...[
          SliverFillRemaining(
            child: TabBarView(
              children: <Widget>[
                const ProfileChildren(radius: radius),
                ProfileTrusted(
                  radius: radius,
                  currentUser: user,
                ),
              ],
            ),
          ),
        ],
        if (!displayFamilyContent) ...[
          ProfileMissingFamilyContent(
            user: user,
            spouseProposal: spouseProposal,
          ),
        ],
      ],
 */
