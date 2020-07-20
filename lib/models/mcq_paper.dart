import 'package:flutter/foundation.dart';
import './mcq.dart';

//Model for single MCQ.
class MCQPaper with ChangeNotifier {
  final String paperId;
  final String paperHostId;
  final String paperCollectionId;
  final String subjectId;
  final String createdAt;
  final String paperName;
  final String paperThumbnailImgURL;
  final String paperAvgRating;
  final int paperGrade;
  final String paperFocussedExamination;
  final String paperDescription;
  final double paperTimeLimit;
  final int paperNumOfQue;
  final String paperSearchTag1;
  final String paperSearchTag2;
  final String paperSearchTag3;
  final String paperSearchTag4;
  final String paperSearchTag5;
  final String paperSearchTag6;
  final List<MCQ> paperMCQList;

  MCQPaper({
    @required this.paperId,
    @required this.paperHostId,
    @required this.subjectId,
    @required this.paperName,
    @required this.paperThumbnailImgURL,
    @required this.paperGrade,
    @required this.paperFocussedExamination,
    @required this.paperDescription,
    this.paperCollectionId,
    this.createdAt,
    this.paperAvgRating,
    this.paperTimeLimit,
    this.paperNumOfQue,
    this.paperSearchTag1,
    this.paperSearchTag2,
    this.paperSearchTag3,
    this.paperSearchTag4,
    this.paperSearchTag5,
    this.paperSearchTag6,
    this.paperMCQList,
  });
  /*
  void toggleFavouriteStatus() {
    isFavourite = !isFavourite;
    notifyListeners();
  }
  */
}
