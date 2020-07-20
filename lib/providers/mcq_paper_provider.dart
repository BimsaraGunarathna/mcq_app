//import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:flutter/material.dart';

//import 'package:http/http.dart' as http;

//Models
import '../models/mcq.dart';
import '../models/mcq_paper.dart';

class MCQPaperProvider with ChangeNotifier {
  //CognitoCredentials _cognitoCredentials;
  List<MCQ> _mCQItems = [];
  List<MCQPaper> _mCQPaper = [];

  void addDemoPaper() {
    _mCQPaper.add(MCQPaper(
        paperId: null,
        paperHostId: null,
        subjectId: null,
        paperName: null,
        paperGrade: null,
        paperFocussedExamination: null,
        paperDescription: null));
  }

  void addDemoItems() {
    _mCQItems.add(
      MCQ(
          mCQId: 'Hello World',
          mCQNum: 1,
          mCQNumAnswer: 1,
          mCQQueBlock1: 'Hello World',
          mCQChoice1Block1:
              '(i)	ix>gl uQ,øjHhl TlaislrK wxlh Y+kH jk m%fNao^h &',
          mCQChoice2Block1: 'Hello World'),
    );
  }

  List<MCQ> get getMCQItems {
    addDemoItems();
    return [..._mCQItems];
  }

  List<MCQPaper> get getMCQPaper {
    addDemoPaper();
    return [..._mCQPaper];
  }

  //Authentication Credentials
  String idToken;
  String identityId;

  /*
  //getter for list of vehicles
  List<MCQ> get items {
    if (_showFavouritesOnly) {
      return _items.where((vehicleItem) => vehicleItem.isFavourite).toList();
    }
    //return copy of an items
    return [..._items];
  }
  */
  /*
  List<MCQ> get hostItems {
    return [..._hostItems];
  }
  */
  /*
    List<Vehicle> get findHostItems() {
      
      var accessKeyId = _cognitoCredentials.accessKeyId;
      _items.forEach(
          (vehicle) => {
            return vehicle.contains((vehi) => vehi.vehicleId == id);
          }
        );
      //return _items.firstWhere((vehi) => vehi.hostId == accessKeyId);

    }
    */
  /*
  MCQ findSingleItem(String id) {
    return _items.firstWhere((vehi) => vehi.vehicleId == id);
  }

  //getter for the single vehicle that matches vehicleId
  MCQ findById(String id) {
    return _items.firstWhere((vehi) => vehi.vehicleId == id);
  }
  */
  /*
  void showFavouriteOnly() {
    _showFavouritesOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavouritesOnly = false;
    notifyListeners();
  }
  */

}
