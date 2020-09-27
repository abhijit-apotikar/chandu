import 'package:flutter/material.dart';
import '../widgets/home_screen_widget.dart';

/*bool showAlertDialogSubmit(BuildContext context, String msg) {
  bool response = false;
  // set up the buttons
  Widget yesButton = OutlineButton(
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
    highlightElevation: 0,
    borderSide: BorderSide(color: Colors.grey),
    child: Text(
      'YES',
      style: TextStyle(
          color: Colors.green,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'Nunito'),
    ),
    onPressed: () async {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreenWidget()));
      //return response;
    },
  );

  Widget cancelButton = OutlineButton(
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
    highlightElevation: 0,
    borderSide: BorderSide(color: Colors.grey),
    child: Text(
      'Cancel',
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
          'Alert!',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 28,
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
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Nunito',
            ),
          ),
        ),
      ],
    ),
    actions: [
      yesButton,
      cancelButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
  return response;
}*/

class SubmitAlertBox extends StatefulWidget {
  @override
  _SubmitAlertBoxState createState() => _SubmitAlertBoxState();
}

class _SubmitAlertBoxState extends State<SubmitAlertBox> {
  bool response = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: (Container(
                width: size.width * 0.8,
                height: size.height * 0.3,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text('Alert!'),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Do you really want to submit the test?'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            RaisedButton(
                              child: Text('Yes'),
                              onPressed: () {
                                setState(() {
                                  response = true;
                                });
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => HomePageWidget()));
                              },
                            ),
                            SizedBox(width: 10),
                            RaisedButton(
                              child: Text('No'),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}

bool showAlertBox() {
  SubmitAlertBox submitAlertBox = new SubmitAlertBox();
  return submitAlertBox.createState().response;
}
