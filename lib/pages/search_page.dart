import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Widgets
import '../widgets/vehicle_grid.dart';
import '../widgets//badge.dart.dart';
import '../widgets/app_drawer.dart';

//Providers
import '../providers/vehicles.dart';
import '../providers/auth.dart';
import '../providers/wishlist.dart';

//Pages
import './wishlist_page.dart';

//Exceptions
import '../exceptions/http_exception.dart';

//Services
import '../services/custom_search_delegate.dart';

enum FilterOptions {
  Favourites,
  All,
}

class SearchPage extends StatefulWidget {
  static const routeName = '/main-dashboard-page';

  const SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _isLoading = false;
  int n;

  @override
  void initState() {
    //initiate loading indicator.
    setState(() {
      _isLoading = true;
    });

    //Initiate accquiring Id Token and Identity id.
    _getIdToken();
    _getIdentityId();

    //Get the session.
    _initiateSession();
    _requestVehicleData();

    super.initState();
  }

  Future<void> _getIdentityId() async {
    try {
      String identityId = Provider.of<Auth>(context, listen: false).getIdentityId();
      print('Identity ID @ Search : $identityId');
      Provider.of<Vehicles>(context, listen: false).haveIdentityId(identityId);
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Identity Id ERRROR: $error');
    }
  }

  Future<void> _getIdToken() async {
    try {
      String idToken = Provider.of<Auth>(context, listen: false).getIdToken();
      print('Id Token @ Search : $idToken');
      Provider.of<Vehicles>(context, listen: false).haveIdToken(idToken);
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Id Token ERRROR: $error');
    }
    /*
    Provider.of<Auth>(context, listen: false)
        .getIdToken()
        .then((response) {
      print('idToken @ Search : $response');
      Provider.of<Vehicles>(context, listen: false)
          .haveCredentials(response.toString());
      setState(() {
        _isLoading = false;
      });
    }).catchError((error) => {
             
            });
            */
  }

  Future<void> _initiateSession() async {
    bool hasSession = await Provider.of<Auth>(context, listen: false).init();
    if (hasSession) {
      setState(() {
        _isLoading = false;
      });
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final productContainer = Provider.of<Vehicles>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicles Demo'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
          ),
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              if (selectedValue == FilterOptions.Favourites) {
                productContainer.showFavouriteOnly();
              } else {
                productContainer.showAll();
              }
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favourite'),
                value: FilterOptions.Favourites,
              ),
              PopupMenuItem(
                child: Text('Show all'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Wishlist>(
            builder: (_, wishlist, ch) => Badge(
              child: ch,
              value: wishlist.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white30,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(WishlistPage.routeName);
              },
            ),
          )
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
            : VehicleGrid(),
      ),
    );
  }
}
