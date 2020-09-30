import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  //FirebaseAuth instance-------------------
  FirebaseAuth _auth = FirebaseAuth.instance;

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
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // ----Sign in with email & password-------
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      if (user.emailVerified) return user.uid;
      return null;
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
