import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = dummyProducts;
  bool _showFavoriteOnly = false;

  List<Product> get items {
    if (_showFavoriteOnly) {
      return _items.where((x) => x.isFavorite).toList();
    }
    return [..._items];
  }

  int get itemsCount => _items.length;

  void showFavoriteOnly() {
    _showFavoriteOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoriteOnly = false;
    notifyListeners();
  }

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void saveProduct(Map<String, Object> data) {
    bool hasId = data["id"] != null;

    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data["name"].toString(),
      description: data["description"].toString(),
      price: data["price"] as double,
      imageUrl: data["imageUrl"].toString(),
    );

    if (hasId) {
      updateProduct(product);
    } else {
      addProduct(product);
    }
  }

  void updateProduct(Product product) {
    int index = _items.indexWhere((element) => element.id == product.id);
    if (index > 0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  void removeProduct(Product product) {
    int index = _items.indexWhere((element) => element.id == product.id);
    if (index > 0) {
      _items.removeWhere((element) => element.id == product.id);
      notifyListeners();
    }
  }
}
