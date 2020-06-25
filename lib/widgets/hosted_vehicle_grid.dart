import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './hosted_vehicle_item.dart';

import '../providers/vehicles.dart';

class HostedVehicleGrid extends StatelessWidget {
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
        child: HostedVehicleItem(
          //id: vehicles[index].vehicleId,
          //title: vehicles[index].vehicleTitle,
          //imageUrl: vehicles[index].imageUrl,
        ),
      ),
    );
  }
}
