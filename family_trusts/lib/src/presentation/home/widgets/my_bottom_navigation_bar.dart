import 'package:badges/badges.dart';
import 'package:familytrusts/src/domain/home/app_tab.dart';
import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final AppTab activeTab;
  final Function(AppTab) onTabSelected;
  final int nbNotificationsUnseen;

  const MyBottomNavigationBar({
    Key? key,
    required this.activeTab,
    required this.onTabSelected,
    required this.nbNotificationsUnseen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: AppTab.values.indexOf(activeTab),
      onTap: (index) => onTabSelected(AppTab.values[index]),
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black12,
      iconSize: 30,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
          icon: getIcon(AppTab.ask, context),
          label: getLabel(AppTab.ask),
        ),
        BottomNavigationBarItem(
          icon: getIcon(AppTab.myDemands, context),
          label: getLabel(AppTab.myDemands),
        ),
        BottomNavigationBarItem(
          icon: getIcon(AppTab.notification, context),
          label: getLabel(AppTab.myDemands),
        ),
        BottomNavigationBarItem(
          icon: getIcon(AppTab.me, context),
          label: getLabel(AppTab.me),
        ),
      ],
    );
  }

  Widget getIcon(AppTab tab, BuildContext context) {
    Widget icon;
    switch (tab) {
      case AppTab.ask:
        icon = const Icon(Icons.search);
        break;
      case AppTab.myDemands:
        icon = const Icon(Icons.assignment);
        break;
      //case AppTab.lookup:
      //  icon = const Icon(Icons.location_on);
      //  break;
      case AppTab.notification:
        icon = const Icon(Icons.notifications);
        if (nbNotificationsUnseen > 0) {
          icon = Badge(
            position: BadgePosition.topEnd(end: -20, top: -10),
            animationDuration: const Duration(milliseconds: 300),
            //animationType: BadgeAnimationType.slide,
            badgeColor: (activeTab == AppTab.notification)
                ? Theme.of(context).primaryColorDark
                : Theme.of(context).primaryColorLight,
            badgeContent: Text(
              nbNotificationsUnseen>99?"99+":nbNotificationsUnseen.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            child: icon,
          );
        }
        break;
      case AppTab.me:
        icon = const Icon(Icons.group);
        break;
    }
    return icon;
  }

  String getLabel(AppTab tab) {
    String label;
    switch (tab) {
      case AppTab.ask:
        label = 'Demander';
        break;
      case AppTab.myDemands:
        label = 'Mes demandes';
        break;
      //case AppTab.lookup:
      //  label = 'Autour de moi';
      //  break;
      case AppTab.me:
        label = 'Moi';
        break;
      case AppTab.notification:
        label = 'Notifications';
        break;
    }
    return label;
  }
}
