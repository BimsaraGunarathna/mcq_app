import 'package:flutter/material.dart';
import '../navigation/bottom-nav-bar-controller.dart';
import 'package:provider/provider.dart';

//Pages
import './signup_page.dart';
import './forgot_password_page.dart';

//providers
import '../providers/auth.dart';

//Exception
import '../exceptions/http_exception.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login-page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  final GlobalKey<FormState> _formKey = GlobalKey();

  var _isLoading = false;
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      // Log user in
      await Provider.of<Auth>(context, listen: false).login(
        email: _authData['email'],
        password: _authData['password'],
      );

      //Redirect to Home Interface.
      Navigator.of(context).pushReplacementNamed(BottomNavigationBarController.routeName);

    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage =
            'The email address is already in use by another account.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      } else if (error.toString().contains('OPERATION_NOT_ALLOWED')) {
        errorMessage = 'Password sign-in is disabled for this project.';
      } else if (error.toString().contains('TOO_MANY_ATTEMPTS_TRY_LATER')) {
        errorMessage =
            'We have blocked all requests from this device due to unusual activity. Try again later.';
      }

      _showErrorDialog(errorMessage);
    } catch (error) {
      print('Error is$error');
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                10,
                deviceHeight * 0.2,
                10,
                deviceHeight * 0.1,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Go',
                    style: TextStyle(
                      fontSize: 80,
                      color: Colors.orange[900],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Now',
                    style: TextStyle(
                      fontSize: 65,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  //Email TextInput
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      15,
                      deviceHeight * 0.02,
                      15,
                      deviceHeight * 0.02,
                    ),
                    child: TextFormField(
                      decoration: new InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.orange, width: 2.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2.0),
                        ),
                        labelText: 'Email',
                      ),
                      style: TextStyle(fontSize: 20),
                      keyboardType: TextInputType.emailAddress,
                      /*
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Invalid email!';
                        }
                      },
                      */
                      onSaved: (value) {
                        //_authData['email'] = value;
                        _authData['email'] = 'bimsara.gunarathna@gmail.com';
                      },
                    ),
                  ),
                  //Password TextInput
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      15,
                      deviceHeight * 0.05,
                      15,
                      deviceHeight * 0.05,
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: new InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.orange, width: 2.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2.0),
                        ),
                        labelText: 'Password',
                      ),
                      validator: (value) {
                        if (value.isEmpty || value.length < 5) {
                          return 'Password is too short!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        //_authData['password'] = value;
                        _authData['password'] = 'test1234';
                      },
                      style: TextStyle(fontSize: 20),
                      controller: _passwordController,
                      obscureText: true,
                    ),
                  ),
                  //Login Button
                  Padding(
                    padding:
                        EdgeInsets.fromLTRB(20, deviceHeight * 0.02, 20, 0),
                    child: Column(
                      children: <Widget>[
                        if (_isLoading)
                          CircularProgressIndicator()
                        else
                          RaisedButton(
                            child: Text(
                              'login',
                              style: TextStyle(fontSize: 23),
                            ),
                            onPressed: _login,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 8.0),
                            color: Theme.of(context).primaryColor,
                            textColor:
                                Theme.of(context).primaryTextTheme.button.color,
                          ),
                      ],
                    ),
                  ),
                  //Forgot your password?
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 15, 10, 5),
                    child: Center(
                      child: InkWell(
                          child: Text(
                            'Forgot your passwords?',
                            style: TextStyle(fontSize: 18, color: Colors.blue),
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(ForgotPasswordPage.routeName);
                          }),
                    ),
                  ),
                  //Create new account Button
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 15),
                    child: Center(
                      child: InkWell(
                          child: Text(
                            'Create new Account',
                            style: TextStyle(fontSize: 18, color: Colors.blue),
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(SignupPage.routeName);
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
