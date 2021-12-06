import 'dart:js';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/product_grid.dart';
import 'package:shop/models/product_list.dart';

enum FilterOption {
  Favorite,
  All,
}

class ProductsOverviewPage extends StatelessWidget {
  ProductsOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("HS - Horn Store"),
        actions: [
          PopupMenuButton(
              icon: Icon(Icons.more_vert),
              onSelected: (FilterOption selectedValue) => {
                    selectedValue == FilterOption.Favorite
                        ? provider.showFavoriteOnly()
                        : provider.showAll()
                  },
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text("Somente favoritos"),
                      value: FilterOption.Favorite,
                    ),
                    PopupMenuItem(
                      child: Text("Todos"),
                      value: FilterOption.All,
                    ),
                  ])
        ],
      ),
      body: ProductGrid(),
    );
  }
}
