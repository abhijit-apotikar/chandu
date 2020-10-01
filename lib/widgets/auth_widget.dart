import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_proc/models/userIdStatus.dart';

import '../services/authService.dart';
import '../widgets/loadingWidget.dart';

import '../widgets/alertDialog.dart';
import '../widgets/annonymousSignInWarning.dart';

import '../services/firestoreService.dart';
import 'package:provider/provider.dart';

class AuthScreenWidget extends StatefulWidget {
  @override
  _AuthScreenWidgetState createState() => _AuthScreenWidgetState();
}

class _AuthScreenWidgetState extends State<AuthScreenWidget> {
  final AuthService _authService = new AuthService();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  ///------------textField e-mail,password local variables--------
  String email = '';
  String password = '';
  String error = '';

  final String assetName = 'assets/svgs/app_title1.svg';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double pt = MediaQuery.of(context).padding.top;
    final FirestoreService _fsService = new FirestoreService();
    // final cUser = Provider.of<User>(context);
    final userIdStatus = Provider.of<UserIdStatus>(context);

    return Scaffold(
      body: _isLoading
          ? LoadingWidget()
          : Container(
              decoration: BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                      Color(0xffb2ff59),
                      Color(0xff69f0ae),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: pt,
                    ),
                    Container(
                      // margin: EdgeInsets.all(0),
                      height: size.height * 0.4,
                      child: Center(
                        child: SvgPicture.asset(
                          assetName,
                          semanticsLabel: 'Acme Logo',
                          fit: BoxFit.contain,
                          // height: size.height * 0.3,
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.95,
                      height: size.height * 0.6,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Email',
                                    hintStyle: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 20,
                                    ),
                                  ),
                                  validator: (val) =>
                                      val.isEmpty ? 'Enter an e-mail' : null,
                                  onChanged: (val) {
                                    setState(() {
                                      email = val;
                                    });
                                  },
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    hintStyle: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 20,
                                    ),
                                    suffixIcon: GestureDetector(
                                        child: _obscureText
                                            ? Icon(Feather.eye)
                                            : Icon(Feather.eye_off),
                                        onTap: () {
                                          setState(() {
                                            _obscureText = !_obscureText;
                                          });
                                        }),
                                  ),
                                  validator: (val) => val.length < 6
                                      ? 'Password should be atleast 6 characters long'
                                      : null,
                                  obscureText: _obscureText,
                                  onChanged: (val) {
                                    password = val;
                                  },
                                ),
                                SizedBox(height: 20),
                                Container(
                                  width: size.width * 0.6,
                                  child: OutlineButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    highlightElevation: 0,
                                    borderSide: BorderSide(color: Colors.grey),
                                    child: Center(
                                      child: Text(
                                        'Log In',
                                        style: TextStyle(
                                            fontSize: 32,
                                            fontFamily: 'Nunito',
                                            color: Colors.grey[800],
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        setState(() {
                                          _isLoading = true;
                                        });

                                        dynamic result = await _authService
                                            .signInWithEmailAndPassword(
                                                email, password);

                                        if (result == null) {
                                          setState(() {
                                            _isLoading = false;
                                            error =
                                                'Wrong credentials, try again';
                                            showAlertDialog(context, error);
                                          });
                                        } else {
                                          //  userIdStatus.setIniAssent(false);
                                          /* dynamic userExistenceResult =
                                              await _fsService
                                                  .checkUserExistence(result);
                                          userIdStatus.chngUIdStatus(
                                              userExistenceResult);
                                          if (userExistenceResult == true) {
                                            dynamic userInfo = await _fsService
                                                .getUserInfo(result);
                                            if (userInfo['pubUserId'] != null) {
                                              userIdStatus.setCurUserId(
                                                  userInfo['pubUserId']);
                                            } else {
                                              userIdStatus.setCurUserId('');
                                            }
                                          }*/
                                          dynamic userInfo = await _fsService
                                              .getUserInfo(result);
                                          if (userInfo['pubUserId'] != null) {
                                            userIdStatus.setHaveUserId(
                                                userInfo['haveUserId']);
                                            debugPrint(
                                                (userIdStatus.getUserIdStatus())
                                                    .toString());
                                            userIdStatus.setIsUserIdAvailable(
                                                userInfo['isUserIdAvailable']);
                                            debugPrint((userIdStatus
                                                    .getUserIdAvailableStatus())
                                                .toString());
                                            userIdStatus.setIsCourseSetUpDone(
                                                userInfo['isCourseSetUpDone']);
                                            debugPrint((userIdStatus
                                                    .getCourseSetUpStatus())
                                                .toString());
                                            userIdStatus.setCurUserId(
                                                userInfo['pubUserId']);
                                            debugPrint(
                                                (userIdStatus.getCurUserId())
                                                    .toString());
                                          }
                                        }
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(height: 10),
                                Divider(
                                  thickness: 2,
                                  indent: 10,
                                  endIndent: 10,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      child: Image(
                                          image: AssetImage(
                                              "assets/images/google_logo.png"),
                                          height: 30.0),
                                      onTap: () async {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        dynamic result = await _authService
                                            .signInWithGoogle();

                                        if (result == null) {
                                          _isLoading = false;
                                          debugPrint(
                                              'trouble signing in -------------------------');
                                        } else {
                                          _isLoading = false;
                                          dynamic userExistenceResult =
                                              await _fsService
                                                  .checkUserExistence(result);
                                          userIdStatus.chngUIdStatus(
                                              userExistenceResult);
                                          if (userExistenceResult == true) {
                                            dynamic userInfo = await _fsService
                                                .getUserInfo(result);
                                            if (userInfo['pubUserId'] != null) {
                                              userIdStatus.setCurUserId(
                                                  userInfo['pubUserId']);
                                            } else {
                                              userIdStatus.setCurUserId('');
                                            }
                                          }

                                          debugPrint(
                                              'signed in +++++++++++++++++++++++');
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      width: 2,
                                      height: 35,
                                      color: Colors.black12,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      child: Image(
                                          image: AssetImage(
                                              "assets/images/incognito.png"),
                                          height: 37.5),
                                      onTap: () {
                                        error =
                                            "You are trying to sign in annonymously. In this case your data won't persist across app installs. Do you still want to continue?";
                                        showAnnonymousSignInWarning(
                                            context, error, _authService);
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Don\'t have an account?',
                                          style:
                                              TextStyle(fontFamily: 'Nunito'),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    InkWell(
                                      child: Text(
                                        'Register',
                                        style: TextStyle(
                                            fontFamily: 'Nunito',
                                            //fontSize: 14,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushNamed('/RegisterWidget');
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Forgot Password?',
                                          style:
                                              TextStyle(fontFamily: 'Nunito'),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      'Reset Password',
                                      style: TextStyle(
                                          fontFamily: 'Nunito',
                                          //fontSize: 14,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
