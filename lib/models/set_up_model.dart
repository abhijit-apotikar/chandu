import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class SetUpModel with ChangeNotifier {
  String curCourse = 'B.Sc.';
  String curSubComb = "PMCS";
  String curSem = "VI";
  String curSub = "PHY";
  int totalPapers;
  int totalElectives;
  int totalElectiveChoices;

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

  List<Map<String, dynamic>> subList = [
    /* "PHY",
    "MTH",
    "CPS",*/
  ];

  setData(Map<String, dynamic> setUpData) async {
    for (int i = 0; i < setUpData['subjects'].length; i++) {
      subList.add({
        'subName': setUpData['subjects'][i]['subName'],
        'isAvailable': setUpData['subjects'][i]['isAvailable'],
        'isElective': setUpData['subjects'][i]['isElective']
      });
    }
    curSub = setUpData['subjects'][0]['subName'];
    totalPapers = setUpData['totalPapers'];
    totalElectives = setUpData['totalElectives'];
    totalElectiveChoices = setUpData['totalElectiveChoices'];
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
