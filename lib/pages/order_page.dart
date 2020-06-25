import 'package:flutter/material.dart';
import '../navigation/bottom_nav_bar.dart';
import 'package:provider/provider.dart';

//Providers
import '../providers/orders.dart' show Orders;

//Widgets
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrderPage extends StatelessWidget {
  static const routeName = '/orders';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        bottomNavigationBar: BottomNavBar(),
        drawer: AppDrawer(),
        body: Consumer<Orders>(
          builder: (_, orderData, ch) => ListView.builder(
            itemCount: orderData.orders.length,
            itemBuilder: (ctx, index) => OrderItem(orderData.orders[index]),
          ),
        ));
  }
}
