import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Pages
import './pages/root_page.dart';
import './navigation/bottom-nav-bar-controller.dart';
import './pages/search_page.dart';
import './pages/vehicle_detail_page.dart';
import './pages/wishlist_page.dart';
import './pages/order_page.dart';
import './pages/user_vehicle_host_page.dart';
import './pages/edit_vehicle_page.dart';
import './pages/signup_page.dart';
import './pages/auth_page.dart';
import './pages/login_page.dart';
import './pages/signup_confirmation_page.dart';
import './pages/forgot_password_page.dart';
import './pages/create_new_password.dart';
import './pages/host_page.dart';
import './pages/profile_page.dart';
import './pages/favourite_page.dart';
import './pages/offers_page.dart';
import './pages/trip_page.dart';

//Providers
import './providers/vehicles.dart';
import './providers/wishlist.dart';
import './providers/orders.dart';
import './providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /*
  bool _sessionRetrieved = false;

  @override
  void initState() {
    
    super.initState();
  }

  didChangeDependencies() {
    //_getCognitoCredential();
    setState(() {
      _sessionRetrieved = false;
    });

    _initiateSession();
    super.didChangeDependencies();
  }

  Future<void> _initiateSession() async {
    bool hasSession = await Provider.of<Auth>(context, listen: false).init();
    //print('HAS SESSION IS $hasSession');
    if (hasSession) {
      setState(() {
        _sessionRetrieved = true;
      });
    }
  }
  */
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: Vehicles(),
        ),
        /*
        ChangeNotifierProxyProvider<Auth, Vehicles>(
          create: (context) => Vehicles('Fuck Me', []),
          update: (context, auth, vehi) =>
              Vehicles((vehi.idToken = auth.idToken), []),
        ),
        ChangeNotifierProxyProvider<Auth, Vehicles>(
          //update: (_, foo, myNotifier) => Vehicles('foo', []),
          builder: (context, auth, previousVehicle) => Vehicles('FUCK YOU', previousVehicle == null ? [] : previousVehicle.items),
          //builder: (context, auth, previcousVehicle) Vehicles(auth.idToken),
          //value: Vehicles(),
        ),
        */
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
        ChangeNotifierProvider.value(
          value: Wishlist(),
        ),
      ],
      //ChangeNotifierProvider.value(
      //value: Vehicles(),
      //builder: (ctx) => Vehicles(),
      child: Consumer<Auth>(
        builder: (context, authData, _) => MaterialApp(
          title: 'Go Now',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.orange,
          ),
          //home: CreateNewPasswordPage(),
          //home: VehicleItemPage(),
          //home: LoginPage(),
          //home: VINScannerPage(),
          //home: SearchPage(),
          //home: HomePage(),
          home: RootPage(),
          //home: BottomNavigationBarController(),
          //home: TestPage(),
          //home: EditVehiclePage(),
          //navigatorKey: locator<NavigationService>().navigatorKey,

          routes: {
            //Pages
            RootPage.routeName: (ctx) => RootPage(),
            AuthPage.routeName: (ctx) => AuthPage(),
            SearchPage.routeName: (ctx) => SearchPage(),
            VehicleDetailPage.routeName: (ctx) => VehicleDetailPage(),
            WishlistPage.routeName: (ctx) => WishlistPage(),
            OrderPage.routeName: (ctx) => OrderPage(),
            UserVehicleHostPage.routeName: (ctx) => UserVehicleHostPage(),
            EditVehiclePage.routeName: (ctx) => EditVehiclePage(),
            LoginPage.routeName: (ctx) => LoginPage(),
            SignupPage.routeName: (ctx) => SignupPage(),
            SignupConfirmationPage.routeName: (ctx) => SignupConfirmationPage(),
            ForgotPasswordPage.routeName: (ctx) => ForgotPasswordPage(),
            CreateNewPasswordPage.routeName: (ctx) => CreateNewPasswordPage(),
            HostPage.routeName: (ctx) => HostPage(),
            ProfilePage.routeName: (ctx) => ProfilePage(),
            FavouritePage.routeName: (ctx) => FavouritePage(),
            TripPage.routeName: (ctx) => TripPage(),
            OffersPage.routeName: (ctx) => OffersPage(),
            //Bottom Navigator
            BottomNavigationBarController.routeName: (ctx) => BottomNavigationBarController(),
          },
        ),
      ),
      //),
    );
  }
}
