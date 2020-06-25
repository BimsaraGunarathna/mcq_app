import 'package:flutter/material.dart';
//import 'package:go_now_v6/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/vehicle.dart';

//mix in here is kind of like extending but more flexible.
class VehicleDetails with ChangeNotifier {
  List<Vehicle> _items = [];
  var _showFavouritesOnly = false;

  List<Vehicle> get items {
    if (_showFavouritesOnly) {
      return _items.where((vehicleItem) => vehicleItem.isFavourite).toList();
    }

    return [..._items];
  }

  Vehicle findById(String id) {
    return _items.firstWhere((vehi) => vehi.vehicleId == id);
  }

  void showFavouriteOnly() {
    _showFavouritesOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavouritesOnly = false;
    notifyListeners();
  }

  Future<void> fetchAVehicleDetail(String id) async {
    final url = 'https://gonow-v5.firebaseio.com/vehicles$id.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Vehicle> loadedVehicles = [];

      loadedVehicles.add(
        Vehicle(
          vehicleId: id,
          imageUrl: extractedData['imageUrl'],
          vehicleDescription: extractedData['description'],
          pricePerDay: extractedData['price'],
          vehicleTitle: extractedData['title'],
          isFavourite: extractedData['isFavouite'],
        ),
      );

      _items = loadedVehicles;
      //print(jsonDecode(response.body));
      print('Hello RefreshIndicator');
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
  
}
