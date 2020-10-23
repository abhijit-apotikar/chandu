import 'package:flutter/material.dart';
import '../widgets/my_quiz_widget.dart';

showAlertDialogReappear(
  BuildContext context,
  String msg,
  String _testName,
  int _hours,
  int _minutes,
  int _seconds,
) {
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
      onPressed: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
          return MyQuizWidget(_testName, _hours, _minutes, _seconds);
        }), ModalRoute.withName('/HomeScreenWidget'));
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
