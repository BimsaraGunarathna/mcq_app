import 'package:flutter/material.dart';

//Widgets
import '../widgets/app_drawer.dart';

class TripPage extends StatelessWidget {
  static const routeName = '/trip-page';
  const TripPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar:AppBar(
        title: const Text('Trip'),
        actions: <Widget>[
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Trip Page'),
          ],
        ),
      ),
    );
  }
}