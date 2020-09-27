import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

//------------- my packages ---------------------------------------
import '../widgets/loadingWidget.dart';
import '../models/userIdStatus.dart';
import '../services/firestoreService.dart';
import '../shared/constants.dart';

class UserIdSetUpWidget extends StatefulWidget {
  @override
  _UserIdSetUpWidgetState createState() => _UserIdSetUpWidgetState();
}

class _UserIdSetUpWidgetState extends State<UserIdSetUpWidget> {
  //---------- state variables ------------------------
  final _formKey1 = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    EdgeInsets pdTop = MediaQuery.of(context).padding;
    final userIdStatus = Provider.of<UserIdStatus>(context);
    final FirestoreService _fsService = new FirestoreService();

    String _userId;
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
                        : Form(
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
                                          ? 'User Id should be atleast 3 characters long'
                                          : (val.length > 20
                                              ? 'User Id should be atmost 20 characters long'
                                              : null)),
                                  onChanged: (val) {
                                    _userId = val;
                                  },
                                ),
                                SizedBox(height: 25),
                                RaisedButton(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      "Check Availability",
                                      style: TextStyle(
                                          fontFamily: 'Nunito', fontSize: 20),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (_formKey1.currentState.validate()) {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      dynamic result = await _fsService
                                          .checkAvailability(_userId);
                                      if (result == true) {
                                        setState(() {
                                          _isLoading = false;
                                          userIdStatus.userIdAvailability(true);
                                        });
                                      } else {
                                        setState(() {
                                          _isLoading = false;
                                          showToast(
                                              'User id not available. Try with some different user id.',
                                              textStyle: TextStyle(
                                                  fontFamily: 'Nunito'),
                                              position: ToastPosition.bottom);
                                        });
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ))),
          ],
        ),
      ),
    ));
  }
}
