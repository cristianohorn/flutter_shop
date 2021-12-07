import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';

class ProductItem extends StatelessWidget {
  const ProductItem(this.product, {Key? key}) : super(key: key);

  final Product product;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.price.toString()),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
                onPressed: () {},
                icon: Icon(Icons.edit),
                color: Theme.of(context).colorScheme.primary),
            IconButton(
                onPressed: () {},
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor),
          ],
        ),
      ),
    );
  }
}
