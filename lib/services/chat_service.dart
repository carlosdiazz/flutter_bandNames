import 'package:flutter/material.dart';
import 'package:flutter_bandnames/models/mensaje_response.dart';
import 'package:http/http.dart' as http;

//PROPIO
import 'package:flutter_bandnames/config/variables.dart';
import 'package:flutter_bandnames/models/usuarios_response.dart';
import 'package:flutter_bandnames/services/services.dart';

class ChatService with ChangeNotifier {
  late UsuarioModel usuarioPara;

  Future<List<Mensaje>> getChat(String usuarioId) async {
    try {
      final uri = Uri.parse("${Variables.apiUrl}/mensajes/$usuarioId");

      final token = await AuthService.getToken();

      final resp = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      });

      if (resp.statusCode != 200) throw ErrorDescription(resp.body);

      final mensajeResp = mensajesResponseFromJson(resp.body);
      return mensajeResp.data;
    } catch (error) {
      print("Error => $error");
      return [];
    }
  }
}
