import 'package:flutter/material.dart';
import 'package:flutter_bandnames/router/app_router.dart';
import 'package:flutter_bandnames/services/services.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_bandnames/router/app_router.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final autenticado = await authService.isLoggedIn();
    if (autenticado) {
      //Todo conectar al socket serve
      Navigator.pushReplacementNamed(context, AppRoute.usuariosScreen);
    } else {
      Navigator.pushReplacementNamed(context, AppRoute.loginScreen);
    }
  }
}
