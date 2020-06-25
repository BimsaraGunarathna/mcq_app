import 'package:flutter/material.dart';

//Widgets
import '../widgets/app_drawer.dart';

class OffersPage extends StatelessWidget {
  static const routeName = '/offers-page';
  const OffersPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar:AppBar(
        title: const Text('Offers'),
        actions: <Widget>[
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Offers Page'),
        ],
      ),
    );
  }
}
