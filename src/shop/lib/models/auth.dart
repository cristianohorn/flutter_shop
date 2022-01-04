import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/data/store.dart';
import 'package:shop/exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  static const api_key = 'AIzaSyAqAsjpiYoC_4NRFmYMI_ZnYxTh3AkyNGE';
  String? _token;
  String? _email;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _logoutTimer;

  bool get isAuth {
    final _isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _isValid && _token != null;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get email {
    return isAuth ? _email : null;
  }

  String? get userId {
    return isAuth ? _userId : null;
  }

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

    final body = jsonDecode(response.body);
    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _userId = body['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(body['expiresIn']),
        ),
      );

      Store.saveMap('userData', {
        'token': _token,
        'email': _email,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      final dd = await Store.getMap('userData');

      print(dd);

      _autoLogout();
      notifyListeners();
    }
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) return;
    final userData = await Store.getMap('userData');
    print(userData);
    if (userData.isEmpty) return;
    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) return;
    _token = userData['token'];
    _email = userData['email'];
    _userId = userData['_userId'];
    _expiryDate = expiryDate;

    _autoLogout();
    notifyListeners();
  }

  Future<void> signUp(String email, String password) async {
    return authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return authenticate(email, password, 'signInWithPassword');
  }

  void logout() {
    this._userId = null;
    this._token = null;
    this._email = null;
    this._expiryDate = null;
    _clearLogoutTimer();
    Store.remove('userData').then((value) {
      notifyListeners();
    });
  }

  void _clearLogoutTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = null;
  }

  void _autoLogout() {
    _clearLogoutTimer();
    final _timeToLogout = _expiryDate?.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(
      Duration(seconds: _timeToLogout ?? 0),
      logout,
    );
  }
}
