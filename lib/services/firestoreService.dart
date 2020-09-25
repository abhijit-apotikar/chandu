import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  //Firestore instance ********************
  FirebaseFirestore _fireStoreInstance = FirebaseFirestore.instance;

//create new user document******************
  Future createNewUserDocument(String userId, User user) async {
    QuerySnapshot users = await _fireStoreInstance.collection('users').get();
    if (users.docs
        .where((element) => element.data()['pubUserId'] == userId)
        .isEmpty) {
      _fireStoreInstance
          .collection('users')
          .add({'docId': user.uid, 'pubUserId': userId});
      return true;
    } else {
      return false;
    }
  }
}
