import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//PROPIO
import 'package:flutter_bandnames/router/app_router.dart';
import 'package:flutter_bandnames/services/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SocketService(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatService(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: AppRoute.loadingScreen,
        routes: AppRoute.routes,
      ),
    );
  }
}
