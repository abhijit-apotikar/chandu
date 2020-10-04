import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

//------------- my packages ---------------------------------------
import '../widgets/loadingWidget.dart';
import '../services/firestoreService.dart';
import '../shared/constants.dart';
import '../models/stateVariablesModel.dart';

class UserIdSetUpWidget extends StatefulWidget {
  @override
  _UserIdSetUpWidgetState createState() => _UserIdSetUpWidgetState();
}

class _UserIdSetUpWidgetState extends State<UserIdSetUpWidget> {
  //---------- state variables ------------------------
  final _formKey1 = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isUserIdAvailable = false;

  _addUDocFlagToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('uDocFlag', true);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    EdgeInsets pdTop = MediaQuery.of(context).padding;
    final cUser = Provider.of<User>(context);
    final FirestoreService _fsService = new FirestoreService();
    final stateVariablesModel = Provider.of<StateVariablesModel>(context);

    String userId;
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
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                    child: _isLoading
                        ? LoadingWidget()
                        : (_isUserIdAvailable
                            ? Container(
                                height: size.height * 0.85,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 0),
                                child: Center(
                                  child: _isLoading
                                      ? LoadingWidget()
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'User Id Available',
                                                  style: TextStyle(
                                                      fontFamily: 'Nunito',
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Do you want to proceed?',
                                                  style: TextStyle(
                                                      fontFamily: 'Nunito',
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                RaisedButton(
                                                  child: Text(
                                                    'No',
                                                    style: TextStyle(
                                                        fontFamily: 'Nunito'),
                                                  ),
                                                  onPressed: () async {
                                                    setState(() {
                                                      _isUserIdAvailable =
                                                          false;
                                                    });
                                                    showToast(
                                                        'You can choose a different User id.',
                                                        textStyle: TextStyle(
                                                            fontFamily:
                                                                'Nunito'),
                                                        position: ToastPosition
                                                            .bottom);
                                                  },
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                RaisedButton(
                                                  child: Text(
                                                    'Yes',
                                                    style: TextStyle(
                                                        fontFamily: 'Nunito'),
                                                  ),
                                                  onPressed: () async {
                                                    dynamic result =
                                                        await _fsService
                                                            .createNewUserDocument(
                                                                userId, cUser);
                                                    if (result == true) {
                                                      _addUDocFlagToSF();
                                                      stateVariablesModel
                                                          .setUDocFlag(true);
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                ))
                            : Form(
                                key: _formKey1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextFormField(
                                      style: myTextFormFieldTextStyle,
                                      decoration: textFormFieldDecoration
                                          .copyWith(hintText: 'User Id'),
                                      validator: (val) => val.isEmpty
                                          ? "User Id can't be empty."
                                          : (val.length < 2
                                              ? 'User Id should be atleast 3 characters long'
                                              : (val.length > 20
                                                  ? 'User Id should be atmost 20 characters long'
                                                  : null)),
                                      onChanged: (val) {
                                        userId = val;
                                      },
                                    ),
                                    SizedBox(height: 25),
                                    RaisedButton(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          "Check Availability",
                                          style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 20),
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (_formKey1.currentState.validate()) {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          dynamic result = await _fsService
                                              .checkAvailability(userId);
                                          if (result == true) {
                                            setState(() {
                                              _isLoading = false;
                                              _isUserIdAvailable = true;
                                            });
                                          } else {
                                            setState(() {
                                              _isLoading = false;
                                              showToast(
                                                  'User id not available. Try with some different user id.',
                                                  textStyle: TextStyle(
                                                      fontFamily: 'Nunito'),
                                                  position:
                                                      ToastPosition.bottom);
                                            });
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              )))),
          ],
        ),
      ),
    ));
  }
}
