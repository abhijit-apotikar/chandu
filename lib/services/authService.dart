import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/firestoreService.dart';

class AuthService {
  //FirebaseAuth instance-------------------
  FirebaseAuth _auth = FirebaseAuth.instance;

  _addUDocFlagToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('uDocFlag', true);
  }

  //---------FirebaseUser Stream----------
  Stream<User> get user {
    return _auth.authStateChanges();
  }

  //---------GoogleSignIn instance-------------
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  //-------sign in with googleSignIn-----------
  Future signInWithGoogle() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;
    FirestoreService fsService = FirestoreService();

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: gSA.idToken,
      accessToken: gSA.accessToken,
    );
    try {
      dynamic authResult = await _auth.signInWithCredential(credential);
      dynamic userExistence =
          await fsService.checkUserExistence(authResult.user);
      if (userExistence == true) {
        await _addUDocFlagToSF();
      }
      User user = authResult.user;
      return user;
    } catch (e) {
      print(e.toString());
    }
  }

  //----google Sign out---------
  Future signOutFromGoogle() async {
    try {
      googleSignIn.signOut();
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //----Register With e-mail-------------
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      dynamic result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return user;
    } on FirebaseAuthException catch (e) {
      print(
          '${e.code}    &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
      return null;
    } on PlatformException catch (e) {
      print('${e.code}  -----------------------------------------------');
    }
  }

  // ----Sign in with email & password-------
  Future signInWithEmailAndPassword(String email, String password) async {
    FirestoreService fsService = FirestoreService();

    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      dynamic userExistence = await fsService.checkUserExistence(result.user);
      if (userExistence == true) {
        await _addUDocFlagToSF();

        /* dynamic courseFlag = await fsService.checkCourse(result.user);
        if (courseFlag == true) {
          await _addCourseFlagToSF();
        }*/
      }
      //await svm.setUDocFlag(await _getUDocFlagFromSF());
      // await svm.setCourseFlag(await _getCourseFlagFromSF());
      // await svm.setFirstVisitFlag(await _getFirstVisitFlagFromSF());

      User user = result.user;
      return user;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      return null;
    } on PlatformException catch (e) {
      print(e.toString());
      return null;
    }
  }

  //--------------sign in Annonymously-----------------
  Future signInAnnonymouslyToMyApp() async {
    FirestoreService fsService = FirestoreService();
    try {
      UserCredential result = await _auth.signInAnonymously();
      dynamic userExistence = await fsService.checkUserExistence(result.user);
      if (userExistence == true) {
        await _addUDocFlagToSF();
      }
      return result.user;
    } on FirebaseAuth catch (e) {
      print(e.toString());
      return null;
    } on PlatformException catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future requestPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
