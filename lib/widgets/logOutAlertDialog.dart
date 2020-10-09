import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ---------- my packages -------------------
import '../services/authService.dart';
import '../models/stateVariablesModel.dart';

showLogOutDialog(
  BuildContext context,
  String msg,
  AuthService _authService,
  StateVariablesModel _svm,
) {
  _removeUDocFlagFromSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('uDocFlag', false);
  }

  _removeFirstVisitFlagFromSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('firstVisitFlag', false);
  }

  _removeCourseFlagFromSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('courseFlag', false);
  }

  // set up the buttons
  Widget yesButton = OutlineButton(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Text(
        'Yes',
        style: TextStyle(
            color: Colors.green,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Nunito'),
      ),
      onPressed: () async {
        Navigator.of(context).pop();
        await _authService.signOutFromGoogle();
        await _removeUDocFlagFromSF();
        await _removeFirstVisitFlagFromSF();
        await _removeCourseFlagFromSF();
        await _svm.setUDocFlag(false);
        await _svm.setFirstVisitFlag(false);
        await _svm.setCourseFlag(false);
      });
  Widget noButton = OutlineButton(
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
    highlightElevation: 0,
    borderSide: BorderSide(color: Colors.grey),
    child: Text(
      'No',
      style: TextStyle(
          color: Colors.green,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'Nunito'),
    ),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Alert',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: Text(
            msg,
            style: TextStyle(
              color: Colors.red,
              fontSize: 18,
              fontFamily: 'Nunito',
            ),
          ),
        ),
      ],
    ),
    actions: [
      yesButton,
      noButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
