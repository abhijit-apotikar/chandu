import 'package:flutter/foundation.dart';

class UserIdStatus with ChangeNotifier {
  bool _iniAssent;
  bool _haveUserId;
  bool _isUserIdAvailable;
  bool _acceptUserId;
  String _curUserId;
  bool _isCourseSetUpDone;

  UserIdStatus(this._iniAssent);

  getIniAssent() => _iniAssent;
  getUserIdStatus() => _haveUserId;
  getUserIdAvailableStatus() => _isUserIdAvailable;
  getCourseSetUpStatus() => _isCourseSetUpDone;
  getAssent() => _acceptUserId;
  getCurUserId() => _curUserId;

  //----------- set initial assent------------
  setIniAssent(dynamic assent) async {
    if (assent == true) _iniAssent = assent;
    notifyListeners();
  }

  //---------- set _haveUserId -------------
  setHaveUserId(dynamic status) async {
    if (status == true) _haveUserId = status;
    notifyListeners();
  }

  // -------------- set _isUserIdAvailable -----------
  setIsUserIdAvailable(dynamic status) async {
    if (status == true) _isUserIdAvailable = status;
    notifyListeners();
  }

  // ------------ set _isCourseSetUpDone ---------
  setIsCourseSetUpDone(dynamic status) async {
    if (status == true) _isCourseSetUpDone = status;
    notifyListeners();
  }

  processIniAssent(bool assent) async {
    _iniAssent = assent;
    notifyListeners();
  }

  //----------- Set current user id----------------
  setCurUserId(dynamic curUserId1) async {
    _curUserId = curUserId1;
    notifyListeners();
  }

  //-------- To check if user already has an user id-------------------
  chngUIdStatus(bool status) async {
    if (status) {
      _haveUserId = true;
    } else {
      _haveUserId = false;
    }
    notifyListeners();
  }

  //-------- To see if user accepts the selected user id----------------
  processUserId(bool ascent) async {
    if (ascent) {
      _acceptUserId = true;
      _isUserIdAvailable = false;
    } else {
      _acceptUserId = false;
    }
    notifyListeners();
  }

  //---------- To see if the currently selected user id is available------------
  userIdAvailability(bool availibility) async {
    if (availibility) {
      _isUserIdAvailable = true;
      _haveUserId = true;
    } else {
      _isUserIdAvailable = false;
      _haveUserId = false;
    }
    notifyListeners();
  }

  //---------- To see if the course set is done or not ------------
  courseSetUpStatus(bool status) async {
    if (status) {
      _isCourseSetUpDone = true;
    } else {
      _isCourseSetUpDone = false;
    }
    notifyListeners();
  }
}
