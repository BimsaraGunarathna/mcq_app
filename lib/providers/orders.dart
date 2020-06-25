import 'package:flutter/foundation.dart';

import '../providers/wishlist.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<WishlistItem> vehicles;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.vehicles,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<WishlistItem> wishlistVehicles, double total) {
    //can use "add" or "insert"
    //insert 0 add items begging of the list
    _orders.insert(
      0,
      (OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        dateTime: DateTime.now(),
        vehicles: wishlistVehicles,
      )),
    );
    print('ordered');
    notifyListeners();
  }
}
