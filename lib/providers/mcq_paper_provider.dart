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
    _mCQPaper.add(
      MCQPaper(
          paperId: 'paperId_uiQe76hU123',
          paperHostId: 'Ricky Gervais',
          subjectId: 'Combine Mathamatics',
          paperName: 'Combine Mathamatics 2 : Second Term',
          paperThumbnailImgURL:
              'https://homepages.cae.wisc.edu/~ece533/images/baboon.png',
          paperGrade: 13,
          paperFocussedExamination: 'A/L',
          paperMCQList: _mCQItems,
          paperDescription:
              'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using , making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for will uncover many web sites still in their infancy.'),
    );
    _mCQPaper.add(
      MCQPaper(
          paperId: 'paperId_u1234FU123',
          paperHostId: 'JOHNNY DEPP',
          subjectId: 'Environment',
          paperName: 'Environment 2 : First Term',
          paperThumbnailImgURL:
              'https://homepages.cae.wisc.edu/~ece533/images/monarch.png',
          paperGrade: 5,
          paperFocussedExamination: 'Schoolarship',
          paperDescription:
              'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using , making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for will uncover many web sites still in their infancy.'),
    );
  }

  void addDemoItems() {
    _mCQItems.add(
      MCQ(
          mCQId: 'mCQId_hUus87681',
          mCQNum: 1,
          mCQNumAnswer: 3,
          mCQQueBlock1:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus aliquam bibendum dignissim. Nunc rhoncus metus ac enim hendrerit, sit amet pretium mi pharetra. In hac habitasse platea dictumst. Suspendisse finibus, lectus in condimentum suscipit, felis felis convallis libero, sit amet volutpat nulla dui in sapien.',
          mCQChoice1Block1:
              '(i)	ix>gl uQ,øjHhl TlaislrK wxlh Y+kH jk m%fNao^h &',
          mCQChoice2Block1: 'Hello World'),
    );
    _mCQItems.add(
      MCQ(
          mCQId: 'mCQId_hDFQ681',
          mCQNum: 2,
          mCQNumAnswer: 2,
          mCQQueBlock1:
              'Donec congue dapibus tempus. Nulla egestas risus orci, ac laoreet turpis hendrerit a. In sem leo, faucibus ultrices mauris eu, aliquet fermentum eros.',
          mCQChoice1Block1:
              'Donec iaculis dolor sit amet erat ultricies, faucibus accumsan eros tristique. Proin et augue urna.',
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

  //getter for the single vehicle that matches vehicleId
  MCQPaper findById(String id) {
    return _mCQPaper.firstWhere((paper) => paper.paperId == id);
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
