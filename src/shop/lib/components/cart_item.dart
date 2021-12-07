import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({Key? key, required this.cartItem}) : super(key: key);
  final CartItem cartItem;
  @override
  Widget build(BuildContext context) {
    double totalPrice = cartItem.price * cartItem.quantity;
    return Consumer<Cart>(
      builder: (ctx, cart, _) => Dismissible(
        key: ValueKey(cartItem.id),
        background: Container(
          color: Theme.of(context).errorColor,
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 10),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => {cart.removeItem(cartItem.productId)},
        confirmDismiss: (_) {
          return showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text("Tem certeza?"),
              content: Text("Tem certeza que desej excluir o item?"),
              actions: [
                TextButton(
                  child: Text("Não"),
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                ),
                TextButton(
                  child: Text("Sim"),
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                ),
              ],
            ),
          );
        },
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: FittedBox(
                    child: Text(
                      cartItem.price.toStringAsFixed(2),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              title: Text(cartItem.name),
              subtitle: Text('Total R\$  ${totalPrice.toStringAsFixed(2)}'),
              trailing: Text('${cartItem.quantity}x'),
            ),
          ),
        ),
      ),
    );
  }
}
