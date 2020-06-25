import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amazon_cognito_identity_dart/cognito.dart';
//import 'package:path/path.dart' as path;
//import 'dart:io';
//import 'dart:convert';
//import 'package:amazon_cognito_identity_dart/sig_v4.dart';
//import 'package:http/http.dart' as http;
//import 'package:async/async.dart';

//Models
//import '../models/http_exception.dart';
import '../models/user_model.dart';
//import '../models/s3_image_upload_policy.dart';

//Storage
import '../storage/auth_storage.dart';

//Credentials
import '../credentials/aws_user_pool_credential.dart';

//Services
//import '../services/user_service.dart';

class Auth with ChangeNotifier {
  final userPool = new CognitoUserPool(awsUserPoolId, awsClientId);

  //id(s).
  String idToken;
  String identityId;

  //initial attributes
  CognitoUser cognitoUser;
  CognitoUserSession _session;
  CognitoCredentials credentials;

  //Getters
  ///(01) return true if session is present.
  bool get isAuthenticated {
    if (_session != null) {
      return true;
    }
    return false;
  }

  ///(02) return the id token.
  String getIdToken() {
    idToken = _session.getIdToken().getJwtToken().toString();
    print('idToken @ auth' + idToken);
    return idToken;
  }

  ///(03) return the identity id
  String getIdentityId() {
    return identityId;
  }

  /// (1) Initiate user session from local storage if present
  Future<bool> init() async {
    //print('INIT is calleds');
    final prefs = await SharedPreferences.getInstance();
    final storage = new Storage(prefs);
    userPool.storage = storage;

    cognitoUser = await userPool.getCurrentUser();
    if (cognitoUser == null) {
      return false;
    }
    _session = await cognitoUser.getSession();

    //initialize getting identity id from identity pool.
    identityId = await CognitoIdentityId(identityPoolId, userPool)
        .getIdentityId(_session.getIdToken().getJwtToken());

    return _session.isValid();
  }

  /// (2) Retrieve user credentials -- for use with other AWS services
  Future<CognitoCredentials> getCredentials() async {
    if (cognitoUser == null || _session == null) {
      return null;
    }
    credentials = new CognitoCredentials(identityPoolId, userPool);
    await credentials.getAwsCredentials(_session.getIdToken().getJwtToken());
    print('getCredentials() is called');

    return credentials;
  }

  /// (3) Get existing user from session with his/her attributes
  Future<User> getCurrentUser() async {
    if (cognitoUser == null || _session == null) {
      return null;
    }
    if (!_session.isValid()) {
      return null;
    }
    final attributes = await cognitoUser.getUserAttributes();
    if (attributes == null) {
      return null;
    }
    final user = new User.fromUserAttributes(attributes);
    user.hasAccess = true;
    return user;
    //return _session.idToken.toString();
  }

  /// (4) login to user account.
  Future<User> login({
    String email,
    String password,
  }) async {
    print(email);
    print(password);
    cognitoUser = new CognitoUser(email, userPool, storage: userPool.storage);

    final authDetails = new AuthenticationDetails(
      username: email,
      password: password,
    );

    bool isConfirmed;
    try {
      _session = await cognitoUser.authenticateUser(authDetails);
      isConfirmed = true;
      print('login sessions (1)');
      print(_session.getAccessToken().getJwtToken());
    } on CognitoUserNewPasswordRequiredException catch (e) {
      // handle New Password challenge
      print(e);
    } on CognitoUserMfaRequiredException catch (e) {
      // handle SMS_MFA challenge
      print(e);
    } on CognitoUserSelectMfaTypeException catch (e) {
      // handle SELECT_MFA_TYPE challenge
      print(e);
    } on CognitoUserMfaSetupException catch (e) {
      // handle MFA_SETUP challenge
      print(e);
    } on CognitoUserTotpRequiredException catch (e) {
      // handle SOFTWARE_TOKEN_MFA challenge
      print(e);
    } on CognitoUserCustomChallengeException catch (e) {
      // handle CUSTOM_CHALLENGE challenge
      print(e);
    } on CognitoUserConfirmationNecessaryException catch (e) {
      // handle User Confirmation Necessary
      print(e);
    } on CognitoClientException catch (e) {
      if (e.code == 'UserNotConfirmedException') {
        isConfirmed = false;
      } else {
        throw e;
      }
    }

    if (!_session.isValid()) {
      return null;
    }

    final attributes = await cognitoUser.getUserAttributes();
    final user = new User.fromUserAttributes(attributes);
    user.confirmed = isConfirmed;
    user.hasAccess = true;

    return user;
  }

  /// (5) Confirm user's account with confirmation code sent to email
  Future<bool> confirmAccountWithConfirmationPIN(
      {String email, String confirmationCode}) async {
    cognitoUser = new CognitoUser(email, userPool, storage: userPool.storage);

    return await cognitoUser.confirmRegistration(confirmationCode);
  }

  /// (6) Resend confirmation code to user's email
  Future<void> reAskConfirmattionPIN({String email}) async {
    cognitoUser = new CognitoUser(email, userPool, storage: userPool.storage);
    await cognitoUser.resendConfirmationCode();
  }

  /// Check if user's current session is valid
  Future<bool> checkAuthenticated() async {
    if (cognitoUser == null || _session == null) {
      return false;
    }
    return _session.isValid();
  }

  /// (7) Sign up new user
  Future<User> signUp(
      {String email,
      String password,
      String firstName,
      String lastName}) async {
    CognitoUserPoolData data;
    final userAttributes = [
      new AttributeArg(name: 'email', value: email),
      new AttributeArg(name: 'name', value: firstName),
      new AttributeArg(name: 'family_name', value: lastName),
    ];
    data =
        await userPool.signUp(email, password, userAttributes: userAttributes);

    final user = new User();
    user.email = email;
    //user.name = name;
    user.confirmed = data.userConfirmed;

    return user;
  }

  /// (8) Sign up new user
  Future<void> signOut() async {
    if (credentials != null) {
      await credentials.resetAwsCredentials();
    }
    if (cognitoUser != null) {
      return cognitoUser.signOut();
    }
  }

  /// (9) Initialize Password Change
  Future<void> initiateForgotPassword({String email}) async {
    final cognitoUser = new CognitoUser(email, userPool);
    //print('initiateForgotPassword : $email');
    try {
      //var data = await cognitoUser.forgotPassword();
      await cognitoUser.forgotPassword();
    } catch (e) {
      print(e);
    }
  }

  /// (10) Create new Password.
  Future<void> createNewForgotPassword(
      {String email, String confirmationCode, String newPassword}) async {
    final cognitoUser = new CognitoUser(email, userPool);
    //print('Email : $email   confirmationCode : $confirmationCode   newPassword: $newPassword');
    bool passwordConfirmed = false;
    try {
      passwordConfirmed =
          await cognitoUser.confirmPassword(confirmationCode, newPassword);
    } catch (e) {
      print(e);
    }
    print('PASSWORD: $passwordConfirmed');
  }
}
