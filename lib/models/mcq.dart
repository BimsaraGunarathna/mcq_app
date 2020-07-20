import 'package:flutter/foundation.dart';

//Model for single MCQ.
class MCQ with ChangeNotifier {
  final String mCQId;
  final int mCQNum;
  final int mCQNumAnswer;

  //Ouestion
  final String mCQQueBlock1;
  final String mCQQueBlock2;
  final String mCQQueBlock3;
  final String mCQQueBlock4;
  final String mCQQueBlock5;
  final String mCQQueBlock6;

  //Choice 01
  final String mCQChoice1Block1;
  final String mCQChoice1Block2;
  final String mCQChoice1Block3;
  final double mCQChoice1Block4;
  final double mCQChoice1Block5;
  final String mCQChoice1Block6;

  //Choice 02
  final String mCQChoice2Block1;
  final String mCQChoice2Block2;
  final String mCQChoice2Block3;
  final double mCQChoice2Block4;
  final double mCQChoice2Block5;
  final String mCQChoice2Block6;

  //Choice 03
  final String mCQChoice3Block1;
  final String mCQChoice3Block2;
  final String mCQChoice3Block3;
  final double mCQChoice3Block4;
  final double mCQChoice3Block5;
  final String mCQChoice3Block6;

  //Choice 04
  final String mCQChoice4Block1;
  final String mCQChoice4Block2;
  final String mCQChoice4Block3;
  final double mCQChoice4Block4;
  final double mCQChoice4Block5;
  final String mCQChoice4Block6;

  //Choice 05
  final String mCQChoice5Block1;
  final String mCQChoice5Block2;
  final String mCQChoice5Block3;
  final double mCQChoice5Block4;
  final double mCQChoice5Block5;
  final String mCQChoice5Block6;

  //Choice 06
  final String mCQChoice6Block1;
  final String mCQChoice6Block2;
  final String mCQChoice6Block3;
  final double mCQChoice6Block4;
  final double mCQChoice6Block5;
  final String mCQChoice6Block6;

  MCQ({
    @required this.mCQId,
    @required this.mCQNum,
    @required this.mCQNumAnswer,

    //Question
    @required this.mCQQueBlock1,
    this.mCQQueBlock2,
    this.mCQQueBlock3,
    this.mCQQueBlock4,
    this.mCQQueBlock5,
    this.mCQQueBlock6,

    //Choice 01
    @required this.mCQChoice1Block1,
    this.mCQChoice1Block2,
    this.mCQChoice1Block3,
    this.mCQChoice1Block4,
    this.mCQChoice1Block5,
    this.mCQChoice1Block6,

    //Choice 02
    @required this.mCQChoice2Block1,
    this.mCQChoice2Block2,
    this.mCQChoice2Block3,
    this.mCQChoice2Block4,
    this.mCQChoice2Block5,
    this.mCQChoice2Block6,

    //Choice 03
    this.mCQChoice3Block1,
    this.mCQChoice3Block2,
    this.mCQChoice3Block3,
    this.mCQChoice3Block4,
    this.mCQChoice3Block5,
    this.mCQChoice3Block6,

    //Choice 04
    this.mCQChoice4Block1,
    this.mCQChoice4Block2,
    this.mCQChoice4Block3,
    this.mCQChoice4Block4,
    this.mCQChoice4Block5,
    this.mCQChoice4Block6,

    //Choice 05
    this.mCQChoice5Block1,
    this.mCQChoice5Block2,
    this.mCQChoice5Block3,
    this.mCQChoice5Block4,
    this.mCQChoice5Block5,
    this.mCQChoice5Block6,

    //Choice 06
    this.mCQChoice6Block1,
    this.mCQChoice6Block2,
    this.mCQChoice6Block3,
    this.mCQChoice6Block4,
    this.mCQChoice6Block5,
    this.mCQChoice6Block6,
  });
  /*
  void toggleFavouriteStatus() {
    isFavourite = !isFavourite;
    notifyListeners();
  }
  */
}
