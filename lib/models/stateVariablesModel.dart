import 'package:flutter/foundation.dart';

class StateVariablesModel with ChangeNotifier {
  bool _uDocFlag;
  getUDocFlag() => _uDocFlag;
  setUDocFlag(dynamic flag) async {
    if (flag == true) {
      _uDocFlag = true;
      notifyListeners();
    }
  }
}
