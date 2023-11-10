import 'package:nobest_tag_app/app_theme.dart';
import 'package:nobest_tag_app/assign_screen.dart';
import 'package:nobest_tag_app/custom_drawer/drawer_user_controller.dart';
import 'package:nobest_tag_app/custom_drawer/home_drawer.dart';
import 'package:nobest_tag_app/inventory_screen.dart';
import 'package:nobest_tag_app/search_screen.dart';
import 'package:nobest_tag_app/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:nobest_tag_app/setting_screen.dart';

class NavigationHomeScreen extends StatefulWidget {
  final Widget? screenView;
  final DrawerIndex? drawerIndex;

  NavigationHomeScreen({
    Key? key,
    this.screenView,
    this.drawerIndex,
  }) : super(key: key);

  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  late Widget screenView;
  late DrawerIndex drawerIndex;

  @override
  void initState() {
    drawerIndex = widget.drawerIndex ?? DrawerIndex.HOME;
    screenView = widget.screenView ?? const MyHomePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.white,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
            },
            screenView: screenView,
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      switch (drawerIndex) {
        case DrawerIndex.HOME:
          setState(() {
            screenView = const MyHomePage();
          });
          break;
        case DrawerIndex.Search:
          setState(() {
            screenView = SearchScreen();
          });
          break;
        case DrawerIndex.Inventory:
          setState(() {
            screenView = InventoryScreen();
          });
          break;
        case DrawerIndex.Assign:
          setState(() {
            screenView = AssignScreen();
          });
          break;
        case DrawerIndex.Setting:
          setState(() {
            screenView = SettingScreen();
          });
          break;
        default:
          break;
      }
    }
  }
}
