
import 'package:flutter/material.dart';
//import 'package:gn_v4/widgets/bottom-nav-bar-controller.dart';
import 'package:provider/provider.dart';

//Providers
import '../providers/vehicles.dart';

//Widgets
//import '../widgets/bottom-nav-bar-controller.dart';

class VehicleDetailPage extends StatelessWidget {
  //VehicleDetailPage({this.title});

  static const routeName = './vehicle-detail-page';
  const VehicleDetailPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vehicleId = ModalRoute.of(context).settings.arguments as String;
    print(vehicleId);
    //final vehicleItem = Provider.of<Vehicles>(context)

    final loadedVehicle = Provider.of<Vehicles>(
      context,
      listen: false,
    ).findSingleItem(vehicleId);

    var price = loadedVehicle.pricePerDay;
    var description = loadedVehicle.vehicleDescription;
    //bool isFavourite = loadedVehicle.isFavourite;
    //String hostId = loadedVehicle.hostId;
    String hostName = loadedVehicle.hostName;
    String hostPhoneNumber = loadedVehicle.hostPhoneNumber;
    String vehicleType = loadedVehicle.vehicleType;
    double vehicleNumOfSeats = loadedVehicle.vehicleNumOfSeats;
    double vehicleKmPerL = loadedVehicle.vehicleKmPerL;
    String vehiclePickupLocation = loadedVehicle.vehiclePickupLocation;
    String vehicleAvaliableStartDate = loadedVehicle.vehicleAvaliableStartDate;
    String vehicleAvaliableEndDate = loadedVehicle.vehicleAvaliableEndDate;

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedVehicle.vehicleTitle),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.train),
            title: Text('Trip'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Profile'),
          ),
        ],
      ),
      //bottomNavigationBar: BottomNavigationBarController(),
      body: Consumer<Vehicles>(
        builder: (_, vehicle, _ch) => ListView(
          children: <Widget>[
            Container(
              height: 400,
              child: Image.network(loadedVehicle.imageUrl),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Price per Day'),
                subtitle: Text(
                  '$price',
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.description),
                title: Text('Description'),
                subtitle: Text(
                  '$description',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Host Name'),
                subtitle: Text(
                  '$hostName',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.phone),
                title: Text('Host Phone Number'),
                subtitle: Text(
                  '$hostPhoneNumber',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.description),
                title: Text('Vehicle Type'),
                subtitle: Text(
                  '$vehicleType',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.local_gas_station),
                title: Text('Gas Consumption'),
                subtitle: Text(
                  '$vehicleKmPerL',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.confirmation_number),
                title: Text('Number of seats'),
                subtitle: Text(
                  '$vehicleNumOfSeats',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.date_range),
                title: Text('Available in'),
                subtitle: Text(
                  '$vehicleAvaliableStartDate to $vehicleAvaliableEndDate',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.location_city),
                title: Text('Pickup Location'),
                subtitle: Text(
                  '$vehiclePickupLocation',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
