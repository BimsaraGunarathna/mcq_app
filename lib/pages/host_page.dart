import 'package:flutter/material.dart';

//Widgets
import '../widgets/app_drawer.dart';

class HostPage extends StatefulWidget {
  static const routeName = '/host-page';
  const HostPage({Key key}) : super(key: key);
  @override
  _HostPageState createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
  Future<void> _refreshVehicles() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      //bottomNavigationBar: const BottomNavBar(foo: 1,),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: RefreshIndicator(
              onRefresh: _refreshVehicles,
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
