import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/cart_item.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/order_list.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);
    final items = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Carrinho"),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(25),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 10),
                  Chip(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    label: Text(
                      'R\$ ${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6?.color,
                      ),
                    ),
                  ),
                  Spacer(),
                  CartButton(cart: cart)
                ],
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (ctx, i) => CartItemWidget(
              cartItem: items[i],
            ),
          ))
        ],
      ),
    );
  }
}

class CartButton extends StatefulWidget {
  const CartButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : TextButton(
            style: TextButton.styleFrom(
              textStyle:
                  TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            child: Text('Comprar'),
            onPressed: () async {
              setState(() => _isLoading = true);
              widget.cart.itemsCount == 0
                  ? null
                  : await Provider.of<OrderList>(context, listen: false)
                      .addOrder(widget.cart);
              widget.cart.clear();
              setState(() => _isLoading = false);
            },
          );
  }
}
