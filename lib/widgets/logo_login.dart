import 'package:flutter/material.dart';

class LogoLogin extends StatelessWidget {
  const LogoLogin({super.key, required this.titulo});
  final String titulo;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      width: 170,
      child: Column(
        children: [
          const Image(image: AssetImage('assets/img/tag-logo.png')),
          Text(
            titulo,
            style: const TextStyle(fontSize: 30),
          )
        ],
      ),
    ));
  }
}
