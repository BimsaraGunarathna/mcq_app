import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Providers
import '../providers/auth.dart';

//Pages
import './root_page.dart';
//import '../navigation/bottom-nav-bar-controller.dart';

//Exception
import '../exceptions/http_exception.dart';

class SignupConfirmationPage extends StatefulWidget {
  static const routeName = '/signup-confirmation-page';

  @override
  _SignupConfirmationPageState createState() => _SignupConfirmationPageState();
}

class _SignupConfirmationPageState extends State<SignupConfirmationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'confirmationCode': '',
  };
  var _isLoading = false;

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

  //Send Confirmation PIN for the first time.
  Future<void> _sendConfimationPIN() async {
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
      await Provider.of<Auth>(context, listen: false).confirmAccountWithConfirmationPIN(
        email: ModalRoute.of(context).settings.arguments as String,
        confirmationCode: _authData['confirmationCode'],
      );

      Navigator.of(context).pushReplacementNamed(RootPage.routeName);
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

  //ReSend Confirmation PIN
  Future<void> _reSendConfirmationPIN() async {
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
      await Provider.of<Auth>(context, listen: false).reAskConfirmattionPIN(
        email: ModalRoute.of(context).settings.arguments as String,
      );
    } on HttpException catch (_) {
      String errorMessage = 'Resending PIN failed. Please try again';
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

    print('Model is clicked');
    return Scaffold(
      body: Container(
        decoration: new BoxDecoration(
            //borderRadius: new BorderRadius.circular(16.0),
            //color: Color.fromRGBO(255, 215, 57, 1),
            ),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                  15, deviceHeight * 0.05, 15, deviceHeight * 0.05),
              child: Text('Enter the verification PIN sent to your email.',
                  style: TextStyle(fontSize: 23)),
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        15,
                        deviceHeight * 0.03,
                        15,
                        deviceHeight * 0.02,
                      ),
                      child: TextFormField(
                        onSaved: (value) {
                          _authData['confirmationCode'] = value;
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
                            borderSide:
                                BorderSide(color: Colors.red, width: 2.0),
                          ),
                          labelText: 'Enter PIN ',
                        ),
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: InkWell(
                          child: Text(
                            'Resend the verification PIN',
                            style: TextStyle(fontSize: 17, color: Colors.blue),
                          ),
                          onTap: _reSendConfirmationPIN,
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            120, deviceHeight * 0.035, 120, 0),
                        child: Column(
                          children: <Widget>[
                            if (_isLoading)
                              CircularProgressIndicator()
                            else
                              RaisedButton(
                                onPressed: _sendConfimationPIN,
                                child: Text(
                                  'Done',
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
                ))
          ],
        ),
      ),
    );
  }
}
