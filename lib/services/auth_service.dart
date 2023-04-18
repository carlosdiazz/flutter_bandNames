import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bandnames/config/variables.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  //final usuario;

  Future login(String email, String password) async {
    final data = {"email": email, "password": password};

    final uri = Uri.parse("${Variables.apiUrl}/login");

    final resp = await http.post(uri,
        body: jsonEncode(data), headers: {"Content-Type": "application/json"});

    print(resp.body);
  }
}
