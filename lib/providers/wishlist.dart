import 'package:flutter/foundation.dart';

class WishlistItem {
  final String id;
  final String title;
  final int quantity;
  final double pricePerDay;

  WishlistItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.pricePerDay,
  });
}

class Wishlist with ChangeNotifier {
  Map<String, WishlistItem> _items = {};

  Map<String, WishlistItem> get items {
    return {..._items};
  }

  int get itemCount {
    print(_items.length);
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, wishlistItem) {
      total += wishlistItem.pricePerDay * wishlistItem.quantity;
    });
    return total;
  }

  void addItem(String vehicleId, double pricePerDay, String title) {
    if (_items.containsKey(vehicleId)) {
      _items.update(
          vehicleId,
          (existingWishlistItem) => WishlistItem(
                id: existingWishlistItem.id,
                title: existingWishlistItem.title,
                pricePerDay: existingWishlistItem.pricePerDay,
                quantity: existingWishlistItem.quantity + 1,
              ));
    } else {
      _items.putIfAbsent(
          vehicleId,
          () => WishlistItem(
                id: DateTime.now().toString(),
                title: title,
                pricePerDay: pricePerDay,
                quantity: 1,
              ));
    }
    notifyListeners();
  }

  void removeLatestItem(String vehicleId) {
    if (!_items.containsKey(vehicleId)) {
      return;
    }
    if (_items[vehicleId].quantity > 1) {
      _items.update(
          vehicleId,
          (exisitingWishlistItem) => WishlistItem(
                id: exisitingWishlistItem.id,
                title: exisitingWishlistItem.title,
                pricePerDay: exisitingWishlistItem.pricePerDay,
                quantity: exisitingWishlistItem.quantity-1,
              ));
    } else {
      _items.remove(vehicleId);
    }
    notifyListeners();
  }

  void clearWishlist() {
    _items.clear();
    print('Wishlist Cleared');
    notifyListeners();
  }
}
