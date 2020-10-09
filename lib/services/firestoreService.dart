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
  }
}
