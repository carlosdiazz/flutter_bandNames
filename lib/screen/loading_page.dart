import 'package:flutter/material.dart';
import 'package:flutter_bandnames/router/app_router.dart';
import 'package:flutter_bandnames/widgets/widgets.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Loading"),
      ),
    );
  }
}
