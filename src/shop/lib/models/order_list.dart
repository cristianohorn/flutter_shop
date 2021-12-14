import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/cart.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/order.dart';
import 'package:shop/utils/constants.dart';

class OrderList with ChangeNotifier {
  List<Order> _items = [];

  List<Order> get items => [..._items];

  int get itemsCount => _items.length;

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    final response =
        await http.post(Uri.parse('${Constants.ORDER_BASE_URL}.json'),
            body: jsonEncode({
              "total": cart.totalAmount,
              "date": date.toIso8601String(),
              "products": cart.items.values
                  .map((cartItem) => {
                        "id": cartItem.id,
                        "productId": cartItem.productId,
                        "name": cartItem.name,
                        "quantity": cartItem.quantity,
                        "price": cartItem.price,
                      })
                  .toList(),
            }));

    final orderId = jsonDecode(response.body)['name'];
    if (response.statusCode >= 400) {}

    _items.insert(
      0,
      Order(
        id: orderId,
        total: cart.totalAmount,
        date: date,
        products: cart.items.values.toList(),
      ),
    );

    notifyListeners();
  }

  Future<void> loadOrders() async {
    _items.clear();
    final response =
        await http.get(Uri.parse('${Constants.ORDER_BASE_URL}.json'));
    if (response.body == 'null') return;

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((orderId, orderData) {
      _items.add(
        Order(
          id: orderId,
          total: orderData['total'],
          date: DateTime.parse(orderData['date']),
          products: (orderData['products'] as List<dynamic>).map(
            (cartItem) {
              return CartItem(
                id: cartItem['id'],
                productId: cartItem['productId'],
                name: cartItem['name'],
                quantity: cartItem['quantity'],
                price: cartItem['price'],
              );
            },
          ).toList(),
        ),
      );
    });
    notifyListeners();
    //
  }
}
