import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ------------- my packages -----------------
import '../models/userIdStatus.dart';
import '../widgets/userIdSetUpWidget.dart';
import '../widgets/courseSetUpWidget.dart';
import '../widgets/acceptUserIdWidget.dart';
import '../widgets/mainProduct.dart';
import '../widgets/welcomeWidget.dart';
import '../widgets/verificationWidget.dart';

class HomePageWidget extends StatefulWidget {
  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  _getIniAssentFromSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool iniAssent = prefs.getBool('iniAssent') ?? false;
    return iniAssent;
  }

  _getHaveUserIdFromSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool haveUserId = prefs.getBool('haveUserId') ?? false;
    return haveUserId;
  }

  _getIsUserIdAvailableFromSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool isUserIdAvailable = prefs.getBool('isUserIdAvailable') ?? false;
    return isUserIdAvailable;
  }

  _getIsCourseSetUpDoneFromSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool isCourseSetUpDone = prefs.getBool('isCourseSetUpDone') ?? false;
    return isCourseSetUpDone;
  }

  _getCurUserIdFromSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    String curUserId = prefs.getString('curUserId') ?? '';
    return curUserId;
  }

  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final userIdStatus = context.watch<UserIdStatus>();
    userIdStatus.setIniAssent(_getIniAssentFromSF());
    userIdStatus.setHaveUserId(_getHaveUserIdFromSF());
    userIdStatus.setIsUserIdAvailable(_getIsUserIdAvailableFromSF());
    userIdStatus.setIsUserIdAvailable(_getIsCourseSetUpDoneFromSF());
    userIdStatus.setCurUserId(_getCurUserIdFromSF());

    final _iniAssent = userIdStatus.getIniAssent();
    final _haveUserIdStatus = userIdStatus.getUserIdStatus();
    final _isUserIdAvailable = userIdStatus.getUserIdAvailableStatus();
    final _isCourseSetUpDone = userIdStatus.getCourseSetUpStatus();
    return Scaffold(
      body: (user.emailVerified)
          ? (_iniAssent
              ? (_haveUserIdStatus
                  ? (_isUserIdAvailable
                      ? AcceptUserIdWidget()
                      : (_isCourseSetUpDone
                          ? MainProductWidget()
                          : CourseSetUpWidget()))
                  : UserIdSetUpWidget())
              : WelcomeWidget())
          : VerificationWidget(),
    );
  }
}
