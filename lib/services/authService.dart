import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/firestoreService.dart';
import '../models/stateVariablesModel.dart';

class AuthService {
  //FirebaseAuth instance-------------------
  FirebaseAuth _auth = FirebaseAuth.instance;

  _addUDocFlagToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('uDocFlag', true);
  }

  _addCourseFlagToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('courseFlag', true);
  }

  _getUDocFlagFromSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool uDocFlag = prefs.getBool('uDocFlag') ?? false;
    return uDocFlag;
  }

  _getFirstVisitFlagFromSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool firstVisitFlag = prefs.getBool('firstVisitFlag') ?? false;
    return firstVisitFlag;
  }

  _getCourseFlagFromSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool firstVisitFlag = prefs.getBool('courseFlag') ?? false;
    return firstVisitFlag;
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

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: gSA.idToken,
      accessToken: gSA.accessToken,
    );
    try {
      dynamic authResult = await _auth.signInWithCredential(credential);
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
  Future signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    FirestoreService fsService = FirestoreService();
    StateVariablesModel svm = Provider.of<StateVariablesModel>(
      context,
      listen: false,
    );
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      dynamic userExistence = await fsService.checkUserExistence(result.user);

      if (userExistence == true) {
        await _addUDocFlagToSF();
        dynamic courseFlag = await fsService.checkCourse(result.user);
        if (courseFlag == true) {
          await _addCourseFlagToSF();
        }
      }

      svm.setUDocFlag(await _getUDocFlagFromSF());
      svm.setFirstVisitFlag(await _getFirstVisitFlagFromSF());
      svm.setCourseFlag(await _getCourseFlagFromSF());
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
    try {
      UserCredential result = await _auth.signInAnonymously();
      print(result.user);
      return result.user;
    } on FirebaseAuth catch (e) {
      print(e.toString());
      return null;
    } on PlatformException catch (e) {
      print(e.toString());
      return null;
    }
  }
}
