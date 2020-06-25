import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Providers
import '../providers/vehicles.dart';

//Widget
import '../widgets/app_drawer.dart';
import '../widgets/hosted_vehicle_grid.dart';

//Pages
import '../pages/edit_vehicle_page.dart';

//Exceptions
import '../exceptions/http_exception.dart';

class UserVehicleHostPage extends StatefulWidget {
  //route name
  static const routeName = './user-vehicle';

  //key
  const UserVehicleHostPage({Key key}) : super(key: key);

  @override
  _UserVehicleHostPageState createState() => _UserVehicleHostPageState();
}

class _UserVehicleHostPageState extends State<UserVehicleHostPage> {
  //initials
  bool _isLoading = false;

  @override
  void initState() {
    //initialize loading indicator.
    setState(
      () {
        _isLoading = true;
      },
    );

    //Get the hosted vehicles.
    _requestVehicleData();

    super.initState();
  }

  //initiate getting the hosted vehicles from server.
  void _requestVehicleData() {
    //Provider.of<Auth>(context, listen: false).uploadImageToS3();
    Provider.of<Vehicles>(context, listen: false)
        .fetchAndSetVehicles()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    }).catchError((error) => {
              setState(() {
                _isLoading = false;
              }),
              print('Hello ERRROR: $error'),
              _showError(error),
            });
  }

  //initiate getting the hosted vehicles from server again.
  Future<void> _refreshVehicles() async {
    try {
      await Provider.of<Vehicles>(context, listen: false).fetchAndSetVehicles();
    } on HttpException catch (error) {
      print(error);
      _showError(error);
    } catch (error) {
      print(error);
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Something went wrong: $error'),
          //content: Text('Something went wrong'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    }
  }

  //show error model.
  void _showError(error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text('Something went wrong $error'),
        //content: Text('Something went wrong'),
        actions: <Widget>[
          FlatButton(
            child: Text('ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Vehicles'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditVehiclePage.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        displacement: 5.0,
        onRefresh: _refreshVehicles,
        child: _isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : HostedVehicleGrid(),
      ),
      );
  }
}
