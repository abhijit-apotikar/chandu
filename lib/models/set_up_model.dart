import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class SetUpModel with ChangeNotifier {
  String curCourse = "B.E.";
  String curSubComb = "Civil";
  String curSem = "I";
  String curSub = "PHY";

  /* List<String> courseList = <String>[
    "B.Sc.",
    "B.A.",
    "B.Sc.(Home Science)",
    "M.Sc.",
  ];
  List<String> subCombList = <String>[
    "SMCS",
    "PMCS",
    "PECS",
    "SECS",
    "PCCS",
    "PME",
    "PCM"
  ];
  List<String> semList = <String>[
    "I",
    "II",
    "III",
    "IV",
    "V",
    "VI",
  ];*/

  List<String> subList = <String>[
    /*  "PHY",
    "MTH",
    "CPS",*/
  ];

  List<String> electivesList = <String>[];

  setSubjects(List<String> listFrDb) async {
    for (int i = 0; i < listFrDb.length; i++) {
      subList.add(listFrDb[i]);
    }
    notifyListeners();
  }

  setElectives(List<String> listFrDb) async {
    for (int i = 0; i < listFrDb.length; i++) {
      electivesList.add(listFrDb[i]);
    }
    notifyListeners();
  }

  void chngCurCourse(String newCourse) {
    curCourse = newCourse;
    notifyListeners();
  }

  void chngCurSubComb(String newSubComb) {
    curSubComb = newSubComb;
    notifyListeners();
  }

  void chngCurSem(String newSem) {
    curSem = newSem;
    notifyListeners();
  }

  void chngCurSub(String newSub) {
    curSub = newSub;
    notifyListeners();
  }
}
