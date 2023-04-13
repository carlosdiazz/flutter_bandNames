import 'package:flutter/material.dart';
import 'package:flutter_bandnames/screen/screen.dart';

class AppRoute {
  static const homeScreen = "home_screen";
  static const statusScreen = "statusScreen";

  static Map<String, Widget Function(BuildContext)> routes = {
    homeScreen: (context) => const HomeScreen(),
    statusScreen: (p0) => const StatusScreen()
  };
}
