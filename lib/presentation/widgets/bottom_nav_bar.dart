import 'package:flutter/material.dart';
import 'package:notification_app/constants/colors.dart';
import 'package:notification_app/constants/icons.dart';
import 'package:notification_app/localization.dart';
import 'package:notification_app/presentation/screens/home_screen.dart';

class BottomNavBar extends StatefulWidget {
  final Function(HomeNavbarIndex)? onTabChanged;

  BottomNavBar({this.onTabChanged});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: ColorPalette.thunder,
            blurRadius: 30,
            spreadRadius: -15,
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          if (widget.onTabChanged != null) {
            widget.onTabChanged!(enumFromIndex(index, context));
          }
          setState(() {
            currentIndex = index;
          });
        },
        currentIndex: currentIndex,
        unselectedItemColor: ColorPalette.thunder,
        unselectedIconTheme: IconThemeData(color: ColorPalette.thunder),
        selectedItemColor: ColorPalette.liquorice,
        selectedIconTheme: IconThemeData(color: ColorPalette.aurora),
        items: _getBottomNavBarItems(context)
            .map((BottomNavItem e) => e.item)
            .toList(),
        backgroundColor: ColorPalette.coconut,
        elevation: 0,
      ),
    );
  }

  HomeNavbarIndex enumFromIndex(int index, BuildContext context) {
    try {
      return _getBottomNavBarItems(context).elementAt(index).navbarIndex;
    } catch (e) {
      return index > 0 ? HomeNavbarIndex.Settings : HomeNavbarIndex.TopRewards;
    }
  }

  List<BottomNavItem> _getBottomNavBarItems(BuildContext context) {
    AppLocalizations _translate = AppLocalizations.of(context)!;

    return <BottomNavItem>[
      BottomNavItem(
        item: BottomNavigationBarItem(
          icon: Icon(ThreeIcons.home),
          label: _translate.nav_bar_top_rewards,
        ),
        navbarIndex: HomeNavbarIndex.TopRewards,
      ),
      BottomNavItem(
        item: BottomNavigationBarItem(
          icon: Icon(ThreeIcons.rewards),
          label: _translate.nav_bar_all_rewards,
        ),
        navbarIndex: HomeNavbarIndex.AllRewards,
      ),
      BottomNavItem(
        item: BottomNavigationBarItem(
          icon: Icon(ThreeIcons.discount),
          label: _translate.nav_bar_my_codes,
        ),
        navbarIndex: HomeNavbarIndex.MyCodes,
      ),
      BottomNavItem(
        item: BottomNavigationBarItem(
          icon: Icon(ThreeIcons.settings),
          label: _translate.nav_bar_settings,
        ),
        navbarIndex: HomeNavbarIndex.Settings,
      ),
    ];
  }
}

class BottomNavItem {
  final BottomNavigationBarItem item;
  final HomeNavbarIndex navbarIndex;

  BottomNavItem({
    required this.item,
    required this.navbarIndex,
  });
}
