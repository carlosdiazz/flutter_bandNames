import 'dart:convert';

import 'package:flutter_bandnames/services/services.dart';
import 'package:http/http.dart' as http;

//PROPIO
import 'package:flutter_bandnames/models/usuarios_response.dart';
import 'package:flutter_bandnames/config/variables.dart';

class UsuariosService {
  Future<List<UsuarioModel>> getUsuarios() async {
    try {
      final uri = Uri.parse("${Variables.apiUrl}/user");

      final token = await AuthService.getToken();

      final resp = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      });

      final List<dynamic> jsonList = jsonDecode(resp.body);

      final List<UsuarioModel> userList =
          jsonList.map((json) => UsuarioModel.fromJson(json)).toList();

      return userList;
    } catch (e) {
      return [];
    }
  }
}
