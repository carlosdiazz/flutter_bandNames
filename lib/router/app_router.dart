import 'package:flutter/material.dart';
import 'package:flutter_bandnames/screen/screen.dart';

class AppRoute {
  static const homeBanScreen = "homeBanScreen";
  static const statusScreen = "statusScreen";

  static const chatScreen = "chatScreen";
  static const loadingScreen = "loadingScreen";
  static const loginScreen = "loginScreen";
  static const registerScreen = "registerScreen";
  static const usuariosScreen = "usuariosScreen";

  static Map<String, Widget Function(BuildContext)> routes = {
    //VIEJOS
    homeBanScreen: (context) => const HomeBanScreen(),
    statusScreen: (context) => const StatusScreen(),

    //NUEVOS
    chatScreen: (context) => const ChatScreen(),
    loadingScreen: (context) => const LoadingScreen(),
    loginScreen: (context) => const LoginScreen(),
    registerScreen: (context) => const RegisterScreen(),
    usuariosScreen: (context) => const UsuariosScreen(),
  };
}
