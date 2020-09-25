import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  //Firestore instance ********************
  FirebaseFirestore _fireStoreInstance = FirebaseFirestore.instance;

//check Availability******************
  Future checkAvailability(String userId) async {
    QuerySnapshot users = await _fireStoreInstance.collection('users').get();
    if (users.docs
        .where((element) => element.data()['pubUserId'] == userId)
        .isEmpty) {
      /* _fireStoreInstance
          .collection('users')
          .add({'docId': user.uid, 'pubUserId': userId});*/

      return true;
    } else {
      return false;
    }
  }

  //create new user*******************
  Future createNewUserDocument(String userId, User user1) async {
    QuerySnapshot users = await _fireStoreInstance.collection('users').get();
    if (users.docs
        .where((element) => element.data()['pubUserId'] == userId)
        .isEmpty) {
      _fireStoreInstance
          .collection('users')
          .add({'docId': user1.uid, 'pubUserId': userId});

      return true;
    } else {
      return false;
    }
  }

  //get user info **************************
 Future getUserInfo(User user1) async {
    QuerySnapshot reqUser = await _fireStoreInstance
        .collection('users')
        .where('docId', isEqualTo: user1.uid)
        .get();
    return reqUser.docs[0].data();
  }
}
