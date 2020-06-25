import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

//Widgets
import '../widgets/app_drawer.dart';

//Providers
import '../providers/auth.dart';

//Pages
import '../pages/login_page.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/profile-page';

  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _signOut() async {
    try {
      await Provider.of<Auth>(context, listen: true).signOut();
      Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
    } on Exception catch (error) {
      print(error);
      _showError(error);
    } catch (error) {
      print(error);
      _showError(error);
    }
  }

  void _showError(error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text('Something went wrong : $error'),
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
    final deviceSizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
        title: const Text('Your Profile'),
      ),
      drawer: AppDrawer(),
        body: Container(
          padding: EdgeInsets.fromLTRB(3, 1, 3, 25),
          child: Column(
            children: <Widget>[
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(100)),
                child: Image(
                    width: deviceSizeWidth,
                    image: AssetImage('assets/img/img_avatar.png')),
              ),
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                leading: Icon(
                  Icons.account_circle,
                  size: 35,
                ),
                title: Text('Sign out'),
                onTap: _signOut,
              ),
            ],
          ),
        ));
  }
}
