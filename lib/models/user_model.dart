import 'package:amazon_cognito_identity_dart/cognito.dart';

class User {
  String email;
  String firstName;
  String lastName;
  String password;
  bool confirmed = false;
  bool hasAccess = false;

  User({this.email, this.firstName, this.lastName});

  /// Decode user from Cognito User Attributes
  factory User.fromUserAttributes(List<CognitoUserAttribute> attributes) {
    final user = User();
    attributes.forEach((attribute) {
      if (attribute.getName() == 'email') {
        user.email = attribute.getValue();
      } else if (attribute.getName() == 'first_name') {
        user.firstName = attribute.getValue();
      } else if (attribute.getName() == 'last_name') {
        user.lastName = attribute.getValue();
      }
    });
    return user;
  }
}
