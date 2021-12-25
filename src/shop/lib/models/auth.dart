import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthResponse {
  late String idToken;
  late String email;
  late String refreshToken;
  late String expiresIn;
  late String localId;
}

class Auth with ChangeNotifier {
  static const api_key = 'AIzaSyAqAsjpiYoC_4NRFmYMI_ZnYxTh3AkyNGE';

  Future<void> authenticate(
      String email, String password, String method) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:${method}?key=${api_key}';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(
        {
          "email": email,
          "password": password,
          "returnSecureToken": true,
        },
      ),
    );

    print(jsonDecode(response.body));
  }

  Future<void> signUp(String email, String password) async {
    final data = authenticate(email, password, 'signup');
  }

  Future<void> login(String email, String password) async {
    final data = authenticate(email, password, 'signInWithPassword');
  }
}
