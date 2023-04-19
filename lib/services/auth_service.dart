import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bandnames/config/variables.dart';
import 'package:flutter_bandnames/models/login_response.dart';
//import 'package:flutter_bandnames/models/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService with ChangeNotifier {
  //UsuarioModel usuario;
  bool _autenticando = false;

  bool get autenticando => _autenticando;
  final _storage = FlutterSecureStorage();

  set autenticando(bool valor) {
    _autenticando = valor;
    notifyListeners();
  }

  static Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: "token");
    return token;
  }

  static Future<void> deleteToken() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: "token");
  }

  Future<bool> login(String email, String password) async {
    try {
      autenticando = true;
      final data = {"email": email, "password": password};

      final uri = Uri.parse("${Variables.apiUrl}/auth/login");

      final resp = await http.post(uri,
          body: jsonEncode(data),
          headers: {"Content-Type": "application/json"});
      autenticando = false;
      if (resp.statusCode == 200) {
        final loginResponse = loginResponseFromJson(resp.body);
        await _guardarToken(loginResponse.token);
        return true;
      } else {
        return false;
      }
    } catch (error) {
      autenticando = false;
      return false;
    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: "token", value: token);
  }

  Future logout() async {
    return await _storage.delete(key: "token");
  }
}
