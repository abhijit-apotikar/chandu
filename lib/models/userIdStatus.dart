import 'package:flutter/foundation.dart';

class UserIdStatus with ChangeNotifier {
  bool haveUserId;
  bool isUserIdAvailable;
  bool acceptUserId;
  String curUserId;
  bool isCourseSetUpDone;
  UserIdStatus(this.haveUserId);

  bool getUserIdStatus() {
    return haveUserId;
  }

  bool getCourseSetUpStatus() {
    return isCourseSetUpDone;
  }

  //-------- To check if user already has an user id-------------------
  void chngUIdStatus(bool status) {
    if (status) {
      haveUserId = true;
    } else {
      haveUserId = false;
    }
    notifyListeners();
  }

  //-------- To see if user accepts the selected user id----------------
  void processUserId(bool ascent) {
    if (ascent) {
      acceptUserId = true;
    } else {
      acceptUserId = false;
    }
    notifyListeners();
  }

  //---------- To see if the currently selected user id is available------------
  void userIdAvailability(bool availibility) {
    if (availibility) {
      isUserIdAvailable = true;
    } else {
      isUserIdAvailable = false;
    }
    notifyListeners();
  }

  //---------- To see if the course set is done or not ------------
  void courseSetUpStatus(bool status) {
    if (status) {
      isCourseSetUpDone = true;
    } else {
      isCourseSetUpDone = false;
    }
    notifyListeners();
  }

  //----------- Set current user id----------------
  void setCurUserId(String curUserId) {
    curUserId = curUserId;
    notifyListeners();
  }
}
