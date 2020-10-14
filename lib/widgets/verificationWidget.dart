import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ---------------- my packages -----------------------
import '../widgets/loadingWidget.dart';
import '../services/authService.dart';

class VerificationWidget extends StatefulWidget {
  @override
  _VerificationWidgetState createState() => _VerificationWidgetState();
}

class _VerificationWidgetState extends State<VerificationWidget> {
  final _formKey1 = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isCodeSent = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    EdgeInsets pdTop = MediaQuery.of(context).padding;
    final user = Provider.of<User>(context);
    final AuthService _authService = new AuthService();

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
                    "Email Verification",
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
                        : ((_isCodeSent)
                            ? Form(
                                key: _formKey1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'We have sent an email containing the verification link to your email id. Check your email.',
                                      style: TextStyle(
                                          fontFamily: 'Nunito', fontSize: 16),
                                    ),
                                    Text(
                                      'Just open that link in any web browser and then click the below verify button.',
                                      style: TextStyle(
                                          fontFamily: 'Nunito',
                                          color: Colors.red,
                                          fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    /* TextFormField(
                                      style: myTextFormFieldTextStyle,
                                      decoration:
                                          textFormFieldDecoration.copyWith(
                                              hintText: 'Verification Code'),
                                      validator: (val) => val.isEmpty
                                          ? "User Id can't be empty."
                                          : (val.length == 0
                                              ? 'Verification code should not be empty'
                                              : (val.length > 6
                                                  ? 'User Id should be atmost 6 characters long'
                                                  : null)),
                                      onChanged: (val) {
                                        userId = val;
                                      },
                                    ),*/
                                    SizedBox(height: 10),
                                    RaisedButton(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          "Verify",
                                          style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 20),
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (_formKey1.currentState.validate()) {
                                          _authService.signOutFromGoogle();
                                          showToast(
                                              'You have to sign in again in order to complete the verification process.',
                                              textStyle: TextStyle(
                                                  fontFamily: 'Nunito'),
                                              position: ToastPosition.bottom);
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          /* dynamic result = await _fsService
                                              .checkAvailability(userId);
                                          if (result == true) {
                                            setState(() {
                                              _isLoading = false;
                                              userIdStatus
                                                  .userIdAvailability(result);
                                              userIdStatus.setCurUserId(userId);
                                            });
                                          } else {
                                            setState(() {
                                              _isLoading = false;
                                              showToast('Invalid Code',
                                                  textStyle: TextStyle(
                                                      fontFamily: 'Nunito'),
                                                  position:
                                                      ToastPosition.bottom);
                                            });
                                          }*/
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Your email id is not verified.',
                                    style: TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'We will send you an email containing the verification link to make sure that you have access to this email id.',
                                    style: TextStyle(fontFamily: 'Nunito'),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  RaisedButton(
                                    child: Text('Send Verification Mail'),
                                    onPressed: () async {
                                      await user.sendEmailVerification();
                                      showToast('Verification mail sent',
                                          textStyle:
                                              TextStyle(fontFamily: 'Nunito'),
                                          position: ToastPosition.bottom);
                                      setState(() {
                                        _isCodeSent = true;
                                      });
                                    },
                                  )
                                ],
                              )))),
          ],
        ),
      ),
    ));
  }
}
