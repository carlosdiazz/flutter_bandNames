// To parse this JSON data, do
//
//     final usuarioModel = usuarioModelFromJson(jsonString);

import 'dart:convert';

UsuarioModel usuarioModelFromJson(String str) =>
    UsuarioModel.fromJson(json.decode(str));

String usuarioModelToJson(UsuarioModel data) => json.encode(data.toJson());

class UsuarioModel {
  UsuarioModel({
    required this.id,
    required this.name,
    required this.email,
    //required this.password,
    required this.online,
  });

  String id;
  String name;
  String email;
  //String password;
  bool online;

  factory UsuarioModel.fromJson(Map<String, dynamic> json) => UsuarioModel(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        //password: json["password"],
        online: json["online"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        //"password": password,
        "online": online,
      };
}
