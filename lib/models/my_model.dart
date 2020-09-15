import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyModel with ChangeNotifier {
  String curPg = "Home";
  Color clr1 = Colors.pink;
  Color clr2;
  Color clr3;
  String titleText = "Home";

  void chngPg(int pgId) {
    if (pgId == 1) {
      curPg = "Home";
      titleText = "Home";
      clr1 = Colors.pink;
      clr2 = null;
      clr3 = null;
    } else if (pgId == 2) {
      curPg = "Profile";
      titleText = "Profile";
      clr1 = null;
      clr2 = Colors.pink;
      clr3 = null;
    } else {
      curPg = "Settings";
      titleText = "Settings";
      clr1 = null;
      clr2 = null;
      clr3 = Colors.pink;
    }
    notifyListeners();
  }
}
