import 'package:flutter/material.dart';

import '../my_arguments/test_arguments.dart';

showAlertDialog(
    BuildContext context,
    String msg,
    String testName,
    List<Map<String, String>> testAttempt,
    List<Map<String, bool>> reviewList,
    int totalQue,
    int _hours,
    int _minutes,
    int _seconds,
    int _queAttempted) {
  // set up the buttons
  Widget okButton = OutlineButton(
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
    highlightElevation: 0,
    borderSide: BorderSide(color: Colors.grey),
    child: Text(
      'OK',
      style: TextStyle(
          color: Colors.green,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'Nunito'),
    ),
    onPressed: () {
      TestArguments testArguments = new TestArguments(testName, testAttempt,
          reviewList, totalQue, _hours, _minutes, _seconds, _queAttempted);
      Navigator.of(context).pushReplacementNamed(
        '/ResultWidget',
        arguments: testArguments,
      );
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Time\'s up!',
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
      okButton,
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
