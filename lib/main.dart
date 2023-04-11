import 'package:flutter/material.dart';
import 'package:flutter_bandnames/router/app_router.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: AppRoute.homeScreen,
      routes: AppRoute.routes,
    );
  }
}
