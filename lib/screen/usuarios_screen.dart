import 'package:flutter/material.dart';
import 'package:flutter_bandnames/models/usuario.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  final usuario = [
    UsuarioModel(
        email: "carlos@mail.com", nombre: "Carlos", online: true, uid: "1"),
    UsuarioModel(
        email: "jose@mail.com", nombre: "Jose", online: true, uid: "2"),
    UsuarioModel(
        email: "maria@mail.com", nombre: "Maria", online: false, uid: "3")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "My name",
            style: TextStyle(color: Colors.black87),
          ),
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.exit_to_app_outlined,
                color: Colors.black87,
              )),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: Icon(
                Icons.check_circle_outline,
                color: Colors.blue[400],
              ),
            )
          ],
        ),
        body: ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => ListTile(
                  title: Text(usuario[index].nombre),
                  leading: CircleAvatar(
                    child: Text(usuario[index].nombre.substring(0, 2)),
                  ),
                  trailing: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        color: usuario[index].online
                            ? Colors.green[300]
                            : Colors.red,
                        borderRadius: BorderRadius.circular(100)),
                  ),
                ),
            separatorBuilder: (context, index) => Divider(),
            itemCount: usuario.length));
  }
}
