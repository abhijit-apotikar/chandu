import 'package:flutter/foundation.dart';

class StateVariablesModel with ChangeNotifier {
  bool _uDocFlag;
  bool _firstVisitFlag;
  bool _courseFlag;
  getUDocFlag() => _uDocFlag ?? false;
  getFirstVisitFlag() => _firstVisitFlag ?? true;
  getCourseFlag() => _courseFlag ?? false;
  setUDocFlag(dynamic flag) async {
    if (flag == true) {
      _uDocFlag = true;
    } else if (flag == false) {
      _uDocFlag = false;
    }
    notifyListeners();
  }

  setFirstVisitFlag(dynamic flag) async {
    if (flag == true) {
      _firstVisitFlag = true;
    } else if (flag == false) {
      _firstVisitFlag = false;
    }
    notifyListeners();
  }

  setCourseFlag(dynamic flag) async {
    if (flag == true) {
      _courseFlag = true;
    } else if (flag == false) {
      _courseFlag = false;
    }
    notifyListeners();
  }
}
