import 'package:flutter/material.dart';

import '../shared/constants.dart';
import '../widgets/userIdAvailableDialog.dart';

class UserIdSetUpWidget extends StatefulWidget {
  @override
  _UserIdSetUpWidgetState createState() => _UserIdSetUpWidgetState();
}

class _UserIdSetUpWidgetState extends State<UserIdSetUpWidget> {
  final _formKey1 = GlobalKey<FormState>();
  String _userId;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    EdgeInsets pdTop = MediaQuery.of(context).padding;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: new LinearGradient(
              colors: [
                Color(0xffb2ff59),
                Color(0xff69f0ae),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: pdTop.top,
              ),
              SizedBox(height: 10),
              Container(
                height: size.height * 0.085,
                margin: const EdgeInsets.all(0),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  elevation: 10,
                  child: Center(
                    child: Text(
                      "Set Up User ID",
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: size.height * 0.85,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Center(
                  child: Form(
                    key: _formKey1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          style: myTextFormFieldTextStyle,
                          decoration: textFormFieldDecoration.copyWith(
                              hintText: 'User Id'),
                          validator: (val) => val.isEmpty
                              ? "User Id can't be empty."
                              : (val.length < 2
                                  ? 'Uset Id should be atleast 3 characters long'
                                  : (val.length > 20
                                      ? 'User Id should be atmost 20 characters long'
                                      : null)),
                          onChanged: (val) {
                            setState(() {
                              _userId = val;
                            });
                          },
                        ),
                        SizedBox(height: 25),
                        RaisedButton(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "Check Availability",
                              style:
                                  TextStyle(fontFamily: 'Nunito', fontSize: 20),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey1.currentState.validate()) {
                              String msg = "Do you want to proceed?";
                              showUserIdAvailableDialog(context, msg);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
