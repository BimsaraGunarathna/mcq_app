import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/wishlist.dart' show Wishlist;
import '../providers/orders.dart';

import '../widgets/wishlist_item.dart';

class WishlistPage extends StatelessWidget {
  static const routeName = '/wishlist';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist'),
      ),
      body: Consumer<Wishlist>(
        builder: (_, wishlist, ch) => Column(
          children: <Widget>[
            Card(
              margin: EdgeInsets.all(10),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Total',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Chip(
                      label: Text('\$${wishlist.totalAmount.toStringAsFixed(2)}'),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    FlatButton(
                      child: Text(
                        'Order Now',
                        style: TextStyle(fontSize: 15),
                      ),
                      onPressed: () {
                        Provider.of<Orders>(context, listen: false).addOrder(
                          wishlist.items.values.toList(),
                          wishlist.totalAmount,
                        );
                        wishlist.clearWishlist();
                      },
                      textColor: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: wishlist.itemCount,
                itemBuilder: (ctx, index) => WishlistItem(
                  id: wishlist.items.values.toList()[index].id,
                  price: wishlist.items.values.toList()[index].pricePerDay,
                  quantity: wishlist.items.values.toList()[index].quantity,
                  title: wishlist.items.values.toList()[index].title,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
