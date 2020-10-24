import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  //Firestore instance ********************
  FirebaseFirestore fireStoreInstance = FirebaseFirestore.instance;

//check Availability******************
  Future checkAvailability(String userId) async {
    QuerySnapshot users = await fireStoreInstance.collection('users').get();
    if (users.docs
        .where((element) => element.data()['pubUserId'] == userId)
        .isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //create new user*******************
  Future createNewUserDocument(String userId, User user1) async {
    QuerySnapshot users = await fireStoreInstance.collection('users').get();
    if (users.docs
        .where((element) => element.data()['pubUserId'] == userId)
        .isEmpty) {
      fireStoreInstance.collection('users').add({
        'docId': user1.uid,
        'pubUserId': userId,
        'course': false,
        'curCourse': null,
        'curGroup': null,
        'curSem': null,
      });

      return true;
    } else {
      return false;
    }
  }

  //get user info **************************
  Future getUserInfo(User user1) async {
    QuerySnapshot reqUser = await fireStoreInstance
        .collection('users')
        .where('docId', isEqualTo: user1.uid)
        .get();
    return reqUser.docs[0].data();
  }

  //check if user and userId already exists************
  Future checkUserExistence(dynamic user1) async {
    QuerySnapshot curUser = await fireStoreInstance
        .collection('users')
        .where('docId', isEqualTo: user1.uid)
        .get();
    if (curUser.docs.isEmpty) {
      debugPrint('11111111111111111111111111111111111');
      return false;
    } else if (curUser.docs.isNotEmpty &&
        curUser.docs[0].data()['pubUserId'] == null) {
      debugPrint('222222222222222222222222222222222');
      return false;
    } else {
      debugPrint('33333333333333333333333333333333333333');
      return true;
    }
  }

  Future checkCourse(dynamic user1) async {
    //QuerySnapshot curUser = await fireStoreInstance.collection('users').where('course',isEqualTo:true).get();
    QuerySnapshot curUser = await fireStoreInstance
        .collection('users')
        .where('docId', isEqualTo: user1.uid)
        .get();
    if (curUser.docs.isNotEmpty) {
      if (curUser.docs[0].data()['course'] == false) {
        return false;
      } else if (curUser.docs[0].data()['course'] == true) {
        return true;
      }
    }
  }

  Future setCourse(
      dynamic user1, String course, String group, String sem) async {
    String docId;
    try {
      await fireStoreInstance
          .collection('users')
          .where('docId', isEqualTo: user1.uid)
          .get()
          .then((value) {
        docId = value.docs[0].id;
      });
      await fireStoreInstance.collection('users').doc(docId).update({
        'course': true,
        'curCourse': course,
        'curGroup': group,
        'curSem': sem
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future checkCourseAvailability(String cName) async {
    QuerySnapshot qs = await fireStoreInstance
        .collection('courses')
        .where('cName', isEqualTo: cName)
        .get();
    bool availability = qs.docs[0].data()['availability'];
    return availability;
  }

  Future checkBranchAvailability(String cName, String bName) async {
    bool availability;
    QuerySnapshot qs = await fireStoreInstance
        .collection('courses')
        .where('cName', isEqualTo: cName)
        .get();
    for (int i = 0; i < qs.docs[0].data()['cScheme']['branches'].length; i++) {
      if (qs.docs[0].data()['cScheme']['branches'][i]['bName'] == bName) {
        availability =
            qs.docs[0].data()['cScheme']['branches'][i]['availability'];
      }
    }
    return availability;
  }

  Future checkSemAvailability(String cName, String bName, String sem) async {
    QuerySnapshot qs = await fireStoreInstance
        .collection('courses')
        .where('cName', isEqualTo: cName)
        .get();
    for (int i = 0; i < qs.docs[0].data()['cScheme']['branches'].length; i++) {
      if (qs.docs[0].data()['cScheme']['branches'][i]['bName'] == bName) {
        for (int j = 0;
            j < qs.docs[0].data()['cScheme']['branches'][i]['aSems'].length;
            j++) {
          if (qs.docs[0].data()['cScheme']['branches'][i]['aSems'][j]
                  ['semName'] ==
              sem) {
            return true;
          } else {
            return false;
          }
        }
      }

      /* Future getCourses() async {
    //List<String> courseList = [];
    return Stream<QuerySnapshot> courses = await fireStoreInstance.collection('courses').snapshots();
   /* for (int i = 0; i < courses.docs.length; i++) {
      courseList.add(courses.docs[0].data()['cName']);
    }*/
  }*/
    }
  }

  Future getSetUpData(String cName, String bName, String sem) async {
    List<Map<String, dynamic>> subList = [];
    Map<String, dynamic> setUpData = {};
    int totalPapers;
    int totalElectives;
    int totalElectiveChoices = 0;
    QuerySnapshot qs = await fireStoreInstance
        .collection('courses')
        .where('cName', isEqualTo: cName)
        .get();
    for (int i = 0; i < qs.docs[0].data()['cScheme']['branches'].length; i++) {
      if (qs.docs[0].data()['cScheme']['branches'][i]['bName'] == bName) {
        for (int j = 0;
            j < qs.docs[0].data()['cScheme']['branches'][i]['aSems'].length;
            j++) {
          if (qs.docs[0].data()['cScheme']['branches'][i]['aSems'][j]
                  ['semName'] ==
              sem) {
            totalPapers = qs.docs[0].data()['cScheme']['branches'][i]['aSems']
                [j]['totalPapers'];
            totalElectives = qs.docs[0].data()['cScheme']['branches'][i]
                ['aSems'][j]['totalElectives'];
            totalElectiveChoices = qs.docs[0].data()['cScheme']['branches'][i]
                ['aSems'][j]['totalElectiveChoices'];
            for (int k = 0;
                k <
                    qs.docs[0]
                        .data()['cScheme']['branches'][i]['aSems'][j]
                            ['subjects']
                        .length;
                k++) {
              subList.add({
                'subName': qs.docs[0].data()['cScheme']['branches'][i]['aSems']
                    [j]['subjects'][k]['subName'],
                'isAvailable': qs.docs[0].data()['cScheme']['branches'][i]
                    ['aSems'][j]['subjects'][k]['availability'],
                'isElective': qs.docs[0].data()['cScheme']['branches'][i]
                    ['aSems'][j]['subjects'][k]['isElective']
              });
              /* if (qs.docs[0].data()['cScheme']['branches'][i]['aSems'][j]
                      ['subjects'][k]['isElective'] ==
                  true) {
                totalElectiveChoices++;
              }*/
            }
          }
        }
      } else {}
    }
    setUpData['totalPapers'] = totalPapers;
    setUpData['totalElectives'] = totalElectives;
    setUpData['totalElectiveChoices'] = totalElectiveChoices;
    setUpData['subjects'] = subList;
    return setUpData;
  }

  Future getChapters(
      String cName, String bName, String semName, String subName) async {
    List<Map<String, dynamic>> chapterList = [];
    QuerySnapshot qs = await fireStoreInstance
        .collection('courses')
        .where('cName', isEqualTo: cName)
        .get();

    for (int i = 0; i < qs.docs[0].data()['cScheme']['branches'].length; i++) {
      if (qs.docs[0].data()['cScheme']['branches'][i]['bName'] == bName) {
        for (int j = 0;
            j < qs.docs[0].data()['cScheme']['branches'][i]['aSems'].length;
            j++) {
          if (qs.docs[0].data()['cScheme']['branches'][i]['aSems'][j]
                  ['semName'] ==
              semName) {
            for (int k = 0;
                k <
                    qs.docs[0]
                        .data()['cScheme']['branches'][i]['aSems'][j]
                            ['subjects']
                        .length;
                k++) {
              if (qs.docs[0].data()['cScheme']['branches'][i]['aSems'][j]
                      ['subjects'][k]['subName'] ==
                  subName) {
                for (int l = 0;
                    l <
                        qs.docs[0]
                            .data()['cScheme']['branches'][i]['aSems'][j]
                                ['subjects'][k]['chapters']
                            .length;
                    l++) {
                  chapterList.add({
                    'chapterName': qs.docs[0].data()['cScheme']['branches'][i]
                            ['aSems'][j]['subjects'][k]['chapters'][l]
                        ['chapterName'],
                    'isAvailable': qs.docs[0].data()['cScheme']['branches'][i]
                            ['aSems'][j]['subjects'][k]['chapters'][l]
                        ['isAvailable']
                  });
                }
              }
            }
          }
        }
      } else {}
    }
    return chapterList;
  }

  Future getPreviousExams() async {
    List<Map<String, dynamic>> prevExamList = [];
    QuerySnapshot qs = await fireStoreInstance
        .collection('previousExams')
        .where('category', isEqualTo: 'university')
        .get();
    for (int i = 0; i < qs.docs[0].data()['exams'].length; i++) {
      prevExamList.add({'examName': qs.docs[0].data()['exams'][i]});
    }
    return prevExamList;
  }

  Future getTestSchemes() async {
    List<Map<String, dynamic>> testSchemeList = [];
    QuerySnapshot qs = await fireStoreInstance.collection('testSchemes').get();
    for (int i = 0; i < qs.docs[0].data()['schemes'].length; i++) {
      testSchemeList.add({
        'title': qs.docs[0].data()['schemes'][i]['title'],
        'hours': qs.docs[0].data()['schemes'][i]['hours'],
        'minutes': qs.docs[0].data()['schemes'][i]['minutes'],
        'seconds': qs.docs[0].data()['schemes'][i]['seconds'],
      });
    }
    return testSchemeList;
  }

  Future getChapterQuestions(String _chapName) async {
    List<Map<String, dynamic>> questionList = [];
    try {
      QuerySnapshot qs = await fireStoreInstance
          .collection('questions')
          .where('chapterName', isEqualTo: _chapName)
          .get();
      for (int i = 0; i < qs.docs[0].data()['questions'].length; i++) {
        questionList.add({
          'que': qs.docs[0].data()['questions'][i]['que'],
          'options': [
            qs.docs[0].data()['questions'][i]['options'][0],
            qs.docs[0].data()['questions'][i]['options'][1],
            qs.docs[0].data()['questions'][i]['options'][2],
            qs.docs[0].data()['questions'][i]['options'][3],
          ],
          'ans': qs.docs[0].data()['questions'][i]['ans'],
          'queId': qs.docs[0].data()['questions'][i]['queId'],
          'isVeteran': qs.docs[0].data()['questions'][i]['isVeteran'],
        });
      }
      return questionList;
    } catch (e) {
      return false;
    }
  }

  Future getPreviousExamQuestions(String _examName, String _paperName) async {
    List<Map<String, dynamic>> questionList = [];
    QuerySnapshot qs = await fireStoreInstance
        .collection('questions')
        .where('paperName', isEqualTo: _paperName)
        .get();
    for (int i = 0; i < qs.docs[0].data()['questions'].length; i++) {
      if (qs.docs[0].data()['questions'][i]['isVeteran'] == true &&
          qs.docs[0]
              .data()['questions'][i]['veteranExams']
              .contains(_examName)) {
        questionList.add({
          'que': qs.docs[0].data()['questions'][i]['que'],
          'options': [
            qs.docs[0].data()['questions'][i]['options'][0],
            qs.docs[0].data()['questions'][i]['options'][1],
            qs.docs[0].data()['questions'][i]['options'][2],
            qs.docs[0].data()['questions'][i]['options'][3],
          ],
          'ans': qs.docs[0].data()['questions'][i]['ans'],
          'queId': qs.docs[0].data()['questions'][i]['queId'],
          'isVeteran': qs.docs[0].data()['questions'][i]['isVeteran'],
        });
      }
    }
    if (questionList.length == 0) {
      return false;
    } else {
      return questionList;
    }
  }

  Future getTests(
      String _paperName, int _hours, int _minutes, int _seconds) async {
    List<Map<String, dynamic>> testList = [];
    try {
      QuerySnapshot qs = await fireStoreInstance
          .collection('tests')
          .where('paperName', isEqualTo: _paperName)
          .get();
      for (int i = 0; i < qs.docs.length; i++) {
        if (qs.docs[i].data()['duration']['hours'] == _hours &&
            qs.docs[i].data()['duration']['minutes'] == _minutes &&
            qs.docs[i].data()['duration']['seconds'] == _seconds) {
          testList.add({
            'testName': qs.docs[i].data()['testName'],
            'testSetter': qs.docs[i].data()['testSetter'],
            'attempts': qs.docs[i].data()['attempts']
          });
        }
      }
      return testList.isEmpty ? false : testList;
    } catch (e) {
      return false;
    }
  }

  Future getTestDocumentId(String _testName) async {
    QuerySnapshot qs = await fireStoreInstance
        .collection('tests')
        .where('testName', isEqualTo: _testName)
        .get();
    String docId = qs.docs[0].id;
    return docId;
  }

  Future increaseTestAttempCount(String _docId, String _testName) async {
    int attempts;
    QuerySnapshot qs = await fireStoreInstance
        .collection('tests')
        .where('testName', isEqualTo: _testName)
        .get();
    attempts = qs.docs[0].data()['attempts'] + 1;
    await fireStoreInstance
        .collection('tests')
        .doc(_docId)
        .update({'attempts': attempts});
    return true;
  }

  Future getTestQuestions(
    String _paperName,
    String _testName,
  ) async {
    List<String> questionIdList = [];
    List<Map<String, dynamic>> questionList = [];
    try {
      QuerySnapshot qs = await fireStoreInstance
          .collection('tests')
          .where('testName', isEqualTo: _testName)
          .get();
      for (int i = 0; i < qs.docs[0].data()['questions'].length; i++) {
        questionIdList.add(qs.docs[0].data()['questions'][i]);
      }

      QuerySnapshot qs2 = await fireStoreInstance
          .collection('questions')
          .where('paperName', isEqualTo: _paperName)
          .get();

      for (int k = 0; k < qs2.docs.length; k++) {
        for (int i = 0; i < qs2.docs[k].data()['questions'].length; i++) {
          if (questionIdList
              .contains(qs2.docs[k].data()['questions'][i]['queId'])) {
            questionList.add({
              'queId': qs2.docs[k].data()['questions'][i]['queId'],
              'que': qs2.docs[k].data()['questions'][i]['que'],
              'options': [
                qs2.docs[k].data()['questions'][i]['options'][0],
                qs2.docs[k].data()['questions'][i]['options'][1],
                qs2.docs[k].data()['questions'][i]['options'][2],
                qs2.docs[k].data()['questions'][i]['options'][3],
              ],
              'ans': qs2.docs[k].data()['questions'][i]['ans'],
            });
          }
        }
      }

      return questionList;
    } catch (e) {
      return false;
    }
  }

  Future getUserDocumentId(String _userId) async {
    QuerySnapshot qs = await fireStoreInstance
        .collection('users')
        .where('docId', isEqualTo: _userId)
        .get();
    String docId = qs.docs[0].id;
    return docId;
  }

  Future writeAttempt(String _userId, String _paperName, String _testName,
      List<Map<String, dynamic>> _testAttempt, int _score) async {
    String _docId = await getUserDocumentId(_userId);
    DocumentSnapshot qs =
        await fireStoreInstance.collection('users').doc(_docId).get();
    for (int i = 0; i <= qs.data()['totalTestAttempts']; i++) {
      if (!qs.data().containsKey('testAttempt${i + 1}')) {
        await fireStoreInstance.collection('users').doc(_docId).update({
          'testAttempt${i + 1}': {
            'paper': _paperName,
            'testName': _testName,
            'testAttempt': _testAttempt,
            'score': _score
          },
          '$_paperName': true,
          'totalTestAttempts': qs.data()['totalTestAttempts'] + 1,
        });
        break;
      }
    }
  }

  Future getTopperList(String _paperName, String _testName) async {
    int _sumTotalMarks = 0;
    int _averageMarks = 0;
    List<Map<String, dynamic>> testTakerList = [];
    List<Map<String, dynamic>> localTestTakerList = [];
    List<Map<String, dynamic>> topperList = [];
    Map<String, dynamic> avgMarksPlusTopperList = {};
    QuerySnapshot qs = await fireStoreInstance
        .collection('users')
        .where('$_paperName', isEqualTo: true)
        .get();
    for (int i = 0; i < qs.docs.length; i++) {
      for (int j = 0; j < qs.docs[i].data()['totalTestAttempts']; j++) {
        if (qs.docs[i].data().containsKey('testAttempt${j + 1}')) {
          if (qs.docs[i].data()['testAttempt${j + 1}']['testName'] ==
              _testName) {
            localTestTakerList.add({
              'userId': qs.docs[i].data()['pubUserId'],
              'score': qs.docs[i].data()['testAttempt${j + 1}']['score'],
            });
          }
        }
      }
      var temp1;
      for (int i = 0; i < localTestTakerList.length; i++) {
        for (int j = i + 1; j < localTestTakerList.length; j++) {
          if (localTestTakerList[j]['score'] > localTestTakerList[i]['score']) {
            temp1 = localTestTakerList[j];
            localTestTakerList[j] = localTestTakerList[i];
            localTestTakerList[i] = temp1;
          }
        }
      }
      testTakerList.add(localTestTakerList[0]);
    }

    for (int i = 0; i < testTakerList.length; i++) {
      _sumTotalMarks = _sumTotalMarks + testTakerList[i]['score'];
    }

    var temp;
    for (int i = 0; i < testTakerList.length; i++) {
      for (int j = i + 1; j < testTakerList.length; j++) {
        if (testTakerList[j]['score'] > testTakerList[i]['score']) {
          temp = testTakerList[j];
          testTakerList[j] = testTakerList[i];
          testTakerList[i] = temp;
        }
      }
    }

    if (testTakerList.length <= 10) {
      for (int i = 0; i < testTakerList.length; i++) {
        topperList.add(testTakerList[i]);
      }
    } else {
      for (int i = 0; i < 10; i++) {
        topperList.add(testTakerList[i]);
      }
    }

    _averageMarks = (_sumTotalMarks / testTakerList.length).ceil();
    avgMarksPlusTopperList['averageMarks'] = _averageMarks;
    avgMarksPlusTopperList['topperList'] = topperList;
    return avgMarksPlusTopperList;
  }

  Future calcResult(String _userId, String _paperName, String _testName,
      List<Map<String, dynamic>> _testAttempt) async {
    int correct = 0;
    int wrong = 0;
    int nonAttempted = 0;
    Map<String, dynamic> resultInfo = {};
    Map<String, dynamic> _avgMarksPlusTopperList = {};

    QuerySnapshot qs = await fireStoreInstance
        .collection('questions')
        .where('paperName', isEqualTo: _paperName)
        .get();
    for (int i = 0; i < qs.docs.length; i++) {
      for (int j = 0; j < qs.docs[i].data()['questions'].length; j++) {
        for (int k = 0; k < _testAttempt.length; k++) {
          if (_testAttempt[k]
              .containsKey(qs.docs[i].data()['questions'][j]['queId'])) {
            if (_testAttempt[k]
                    ['${qs.docs[i].data()['questions'][j]['queId']}'] ==
                qs.docs[i].data()['questions'][j]['options']
                    [qs.docs[i].data()['questions'][j]['ans']]) {
              correct = correct + 1;
            } else {
              wrong = wrong + 1;
            }
          }
        }
      }
    }

    QuerySnapshot qs2 = await fireStoreInstance
        .collection('tests')
        .where('testName', isEqualTo: _testName)
        .get();
    int _testLength = qs2.docs[0].data()['questions'].length;
    nonAttempted = _testLength - _testAttempt.length;
    await writeAttempt(_userId, _paperName, _testName, _testAttempt, correct);
    _avgMarksPlusTopperList = await getTopperList(_paperName, _testName);
    resultInfo['correct'] = correct;
    resultInfo['wrong'] = wrong;
    resultInfo['nonAttempted'] = nonAttempted;
    resultInfo['topperScore'] =
        _avgMarksPlusTopperList['topperList'][0]['score'];
    resultInfo['averageScore'] = _avgMarksPlusTopperList['averageMarks'];
    resultInfo['topperList'] = _avgMarksPlusTopperList['topperList'];
    return resultInfo;
  }
}
