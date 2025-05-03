import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import '../views/HomePage.dart';
import '../views/InfoPage.dart';
import '../views/SettingPage.dart';

class PersistentTabScreen extends StatefulWidget {
  const PersistentTabScreen({super.key});

  @override
  State<PersistentTabScreen> createState() => _PersistentTabScreenState();
}

class _PersistentTabScreenState extends State<PersistentTabScreen> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<PersistentTabConfig> _tabs() => [
        PersistentTabConfig(
          screen: HomePage(),
          item: ItemConfig(
            activeForegroundColor: Colors.black,
            icon: const Icon(Icons.home),
            title: "Home",
          ),
        ),
        PersistentTabConfig(
          screen: const SettingPage(),
          item: ItemConfig(
            activeForegroundColor: Colors.black,
            icon: const Icon(Icons.settings),
            title: "Setting",
          ),
        ),
        PersistentTabConfig(
          screen: const InfoPage(),
          item: ItemConfig(
            activeForegroundColor: Colors.black,
            icon: const Icon(Icons.settings),
            title: "Info",
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) => PersistentTabView(
        controller: _controller,
        tabs: _tabs(),
        backgroundColor: Theme.of(context).colorScheme.surface,
        // Default is Colors.white.
        handleAndroidBackButtonPress: true,
        // Default is true.
        resizeToAvoidBottomInset: true,
        // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true,
        // Default is true.
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        screenTransitionAnimation: const ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarBuilder: (navBarConfig) => Style6BottomNavBar(
          navBarDecoration: NavBarDecoration(),
          navBarConfig: navBarConfig,
        ),
      );
}
