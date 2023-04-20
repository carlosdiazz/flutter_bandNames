import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//PROPIO

import 'package:flutter_bandnames/config/variables.dart';
import 'package:flutter_bandnames/models/login_response.dart';
import 'package:flutter_bandnames/models/usuarios_response.dart';

class AuthService with ChangeNotifier {
  UsuarioModel? usuario;
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

  Future<String?> login(String email, String password) async {
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
        usuario = loginResponse.user;
        await _guardarToken(loginResponse.token);
        return null;
      } else {
        final error = jsonDecode(resp.body);
        final messageError = error?['message'].toString() ?? "PASO UN ERROR";
        return messageError;
      }
    } catch (error) {
      autenticando = false;
      return error.toString();
    }
  }

  Future<String?> register(String name, String email, String password) async {
    try {
      autenticando = true;
      final data = {"email": email, "password": password, "name": name};
      final uri = Uri.parse("${Variables.apiUrl}/auth/register");
      final resp = await http.post(uri,
          body: jsonEncode(data),
          headers: {"Content-Type": "application/json"});

      autenticando = false;
      if (resp.statusCode == 201) {
        final registerResponse = loginResponseFromJson(resp.body);
        usuario = registerResponse.user;
        await _guardarToken(registerResponse.token);
        return null;
      } else {
        final error = jsonDecode(resp.body);
        final messageError = error?['message'].toString() ?? "PASO UN ERROR";
        return messageError;
      }
    } catch (error) {
      autenticando = false;
      return error.toString();
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final token = await _storage.read(key: "token");
      if (token == null) {
        return false;
      }
      final uri = Uri.parse("${Variables.apiUrl}/auth/renew");
      final resp = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      }).timeout(const Duration(milliseconds: 5000));

      if (resp.statusCode == 200) {
        final registerResponse = loginResponseFromJson(resp.body);
        usuario = registerResponse.user;
        await _guardarToken(registerResponse.token);
        return true;
      } else {
        logout();
        return false;
      }
    } catch (error) {
      print("Error => $error");
      logout();
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
