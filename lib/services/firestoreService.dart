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
                'isElective': qs.docs[0].data()['cScheme']['branches'][i]
                    ['aSems'][j]['subjects'][k]['isElective']
              });
              if (qs.docs[0].data()['cScheme']['branches'][i]['aSems'][j]
                      ['subjects'][k]['isElective'] ==
                  true) {
                totalElectiveChoices++;
              }
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
}
