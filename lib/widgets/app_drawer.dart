import 'package:flutter/material.dart';

//Pages
import '../pages/order_page.dart';
import '../pages/user_vehicle_host_page.dart';

class AppDrawer extends StatelessWidget {
  //static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello Friend!'),
            //removes back btn
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Vehicle Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderPage.routeName);
            },
            
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Vehicles'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(UserVehicleHostPage.routeName);
            },
          )
        ],
      ),
    );
  }
}
