import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      fireStoreInstance
          .collection('users')
          .add({'docId': user1.uid, 'pubUserId': userId,'iniAssent': false,'haveUserId':true,'isUserIdAvailable':false,'isCourseSetUpDone':false});

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

   // ------------- update iniAssent ------------
  Future updateIniAssent(User user1)async{
    QuerySnapshot reqUser = await fireStoreInstance.collection('users').where('docId',isEqualTo:user1.uid).get();
    reqUser.docs[0].data().update('iniAssent', (value) => true);
    return true;
  }

   // ------------- update haveUserId ------------
  Future updateIsHaveUserId(User user1)async{
    QuerySnapshot reqUser = await fireStoreInstance.collection('users').where('docId',isEqualTo:user1.uid).get();
    reqUser.docs[0].data().update('haveUserId', (value) => true);
    return true;
  }
   // ------------- update isUserIdAvailable ------------
  Future updateIsUserIdAvailable(User user1)async{
    QuerySnapshot reqUser = await fireStoreInstance.collection('users').where('docId',isEqualTo:user1.uid).get();
    reqUser.docs[0].data().update('isUserIdAvailable', (value) => true);
    return true;
  }

  // ------------- update isCourseSetUpDone ------------
  Future updateIsCourseSetUpDone(User user1)async{
    QuerySnapshot reqUser = await fireStoreInstance.collection('users').where('docId',isEqualTo:user1.uid).get();
    reqUser.docs[0].data().update('isCourseSetUpDone', (value) => true);
    return true;
  }

  

  //check if user and userId already exists************
  Future checkUserExistence(dynamic user1) async {
    QuerySnapshot curUser = await fireStoreInstance
        .collection('users')
        .where('docId', isEqualTo: user1.uid)
        .get();
    if (curUser.docs.isEmpty) {
      return false;
    } else if (curUser.docs.isNotEmpty &&
        curUser.docs[0].data()['pubUserId'] == null) {
      return false;
    } else {
      return true;
    }
  }
}
