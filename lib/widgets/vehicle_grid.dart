import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './vehicle_item.dart';

import '../providers/vehicles.dart';

class VehicleGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final vehicleData = Provider.of<Vehicles>(context);
    final vehicles = vehicleData.items;

    return ListView.builder(
      padding: const EdgeInsets.all(0.5),
      itemCount: vehicles.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        //See 15 of State Management
        //value is better than builder for lists which rebuild after the intial build.
        value: vehicles[index],
        //builder: (ctx) => vehicles[index],
        child: VehicleItem(
          //id: vehicles[index].vehicleId,
          //title: vehicles[index].vehicleTitle,
          //imageUrl: vehicles[index].imageUrl,
        ),
      ),
    );

    /*
    final vehicleData = Provider.of<Vehicles>(context);
    final vehicles = vehicleData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: vehicles.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        //See 15 of State Management
        //value is better than builder for lists which rebuild after the intial build.
        value: vehicles[index],
        //builder: (ctx) => vehicles[index],
        child: VehicleItem(
          //id: vehicles[index].vehicleId,
          //title: vehicles[index].vehicleTitle,
          //imageUrl: vehicles[index].imageUrl,
        ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
    );
    */
  }
}
