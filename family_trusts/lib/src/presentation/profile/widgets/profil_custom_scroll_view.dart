import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/presentation/profile/widgets/profile_appbar.dart';
import 'package:flutter/material.dart';

class ProfileCustomScrollView extends StatelessWidget {
  final User user;
  final User spouse;
  final TabBar tabBar;
  final ScrollController _scrollViewController;
  final Widget body;
  final double radius;

  const ProfileCustomScrollView(
    this._scrollViewController, {
    super.key,
    required this.user,
    required this.spouse,
    required this.body,
    required this.tabBar,
    required this.radius,
  });

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
