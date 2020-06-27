import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Providers
import '../providers/auth.dart';

//Pages
//import './login_page.dart';
import '../navigation/bottom-nav-bar-controller.dart';

//websocket
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class RootPage extends StatefulWidget {
  static const routeName = '/root-page';
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  bool _sessionRetrieved = false;

  @override
  void initState() {
    //_getCognitoCredential();
    testWebsocket();
    setState(() {
      _sessionRetrieved = false;
    });

    testWebsocket();

    _initiateSession();

    super.initState();
  }
  /*
  Future<void> _getCognitoCredential() async {
    await Provider.of<Auth>(context, listen: false)
        .getCredentials()
        .then((response) {
      print('Credential Response is : $response');
      Provider.of<Vehicles>(context, listen: false).haveCredentials(response);

    });
  }
  */

  Future<void> testWebsocket() async {
    print('WebScoket is called');
    var channel = IOWebSocketChannel.connect(
        "wss://3bpxptbbj1.execute-api.ap-south-1.amazonaws.com/dev");

    channel.stream.listen((message) {
      print('WebScoket: ' + message);
      channel.sink.add("received!");
      channel.sink.close(status.goingAway);
    });
  }

  Future<void> _initiateSession() async {
    Auth auth = Provider.of<Auth>(context, listen: false);
    bool hasSession = await auth.init();
    bool isAuthenticad = auth.isAuthenticated;
    print('isAuthenticated : ');
    print(isAuthenticad);
    //bool hasSession = await Provider.of<Auth>(context, listen: false).init();
    //print('HAS SESSION IS $hasSession');
    if (hasSession) {
      setState(() {
        _sessionRetrieved = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //return _sessionRetrieved ?  BottomNavigationBarController() : LoginPage();
    return BottomNavigationBarController();
  }
}
