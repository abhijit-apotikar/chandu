import 'package:flutter/foundation.dart';

class StateVariablesModel with ChangeNotifier {
  bool _uDocFlag;
  bool _firstVisitFlag;
  getUDocFlag() => _uDocFlag ?? false;
  getFirstVisitFlag() => _firstVisitFlag ?? false;
  setUDocFlag(dynamic flag) async {
    if (flag == true) {
      _uDocFlag = true;
      notifyListeners();
    }
  }

  setFirstVisitFlag(dynamic flag) async {
    if (flag == true) {
      _firstVisitFlag = true;
      notifyListeners();
    }
  }
}
