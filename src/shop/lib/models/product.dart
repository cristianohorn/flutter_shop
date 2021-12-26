import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/utils/constants.dart';
import 'package:http/http.dart' as http;

class Product extends ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _toogleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toogleFavorite(String token, String userId) async {
    _toogleFavorite();
    final response = await http.put(
      Uri.parse('${Constants.USER_FAVORITE_URL}/$userId/$id.json?auth=$token'),
      body: jsonEncode(isFavorite),
    );

    if (response.statusCode >= 400) {
      _toogleFavorite();
      throw HttpException(
          msg: "Não foi possível alterar o produto",
          statusCode: response.statusCode);
    }
  }
}
