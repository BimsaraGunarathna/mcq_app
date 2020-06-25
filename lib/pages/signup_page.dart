import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Pages
import './signup_confirmation_page.dart';

//Providers
import '../providers/auth.dart';

//Exceptions
import '../exceptions/http_exception.dart';

class SignupPage extends StatefulWidget {
  static const routeName = '/signup-page';

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'firstName' : '',
    'lastName' : ''
  };

  final _passwordController = TextEditingController();
  var _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey();

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      // Signup user in
      await Provider.of<Auth>(context, listen: false).signUp(
        email: _authData['email'],
        password: _authData['password'],
        firstName: _authData['firstName'],
        lastName: _authData['lastName'],
      );

    Navigator.of(context).pushNamed(SignupConfirmationPage.routeName, arguments: _authData['email'].toString());

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

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 215, 57, 1),
        title: Text(
          'Signup',
          style: TextStyle(fontSize: 23),
        ),
      ),
      body: Container(
        decoration: new BoxDecoration(
            //borderRadius: new BorderRadius.circular(16.0),
            //color: Color.fromRGBO(255, 215, 57, 1),
            ),
        child: ListView(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  //First Name
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      15,
                      deviceHeight * 0.01,
                      15,
                      deviceHeight * 0.01,
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'First name can\'t be empty';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['firstName'] = value;
                      },
                      decoration: new InputDecoration(
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
                        labelText: 'First name',
                      ),
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  //Last Name
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      15,
                      deviceHeight * 0.01,
                      15,
                      deviceHeight * 0.01,
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Last name can\'t be empty';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['lastName'] = value;
                      },
                      decoration: new InputDecoration(
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
                        labelText: 'Last name',
                      ),
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  //Email
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      15,
                      deviceHeight * 0.01,
                      15,
                      deviceHeight * 0.01,
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Invalid email!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['email'] = value;
                      },
                      decoration: new InputDecoration(
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
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      15,
                      deviceHeight * 0.01,
                      15,
                      deviceHeight * 0.01,
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      textCapitalization: TextCapitalization.none,
                      obscureText: true,
                      controller: _passwordController,
                      validator: (value) {
                        if (value.isEmpty || value.length < 5) {
                          return 'Password is too short!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['password'] = value;
                      },
                      decoration: new InputDecoration(
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
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      15,
                      deviceHeight * 0.01,
                      15,
                      deviceHeight * 0.02,
                    ),
                    child: TextFormField(
                      decoration: new InputDecoration(
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
                        labelText: 'Confirm Password',
                      ),
                      style: TextStyle(fontSize: 20),
                      obscureText: true,
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Passwords do not match!';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, deviceHeight * 0.035, 20, 0),
              child: SizedBox(
                height: 40,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Read Terms of Service',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  textColor: Colors.white,
                  color: Colors.blue,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(120, deviceHeight * 0.035, 120, 0),
                child: Column(
                  children: <Widget>[
                    if (_isLoading)
                      CircularProgressIndicator()
                    else
                      RaisedButton(
                        onPressed: _submit,
                        child: Text(
                          'Agree',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        textColor: Colors.white,
                        color: Colors.orange,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                      ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
