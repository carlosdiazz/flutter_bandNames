import 'package:flutter/material.dart';

class LabelsLogin extends StatelessWidget {
  const LabelsLogin(
      {super.key,
      required this.ruta,
      required this.text1,
      required this.text2});

  final String ruta;
  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Text(
          text1,
          style: const TextStyle(
              color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w300),
        ),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, ruta);
          },
          child: Text(
            text2,
            style: TextStyle(
                color: Colors.blue[600],
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        )
      ]),
    );
  }
}
