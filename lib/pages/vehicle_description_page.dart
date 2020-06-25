import 'package:flutter/material.dart';

class VehicleDescriptionPage extends StatelessWidget {
  
  final String vehicleId;

  VehicleDescriptionPage({Key key, @required this.vehicleId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(vehicleId),
    );
  }
}