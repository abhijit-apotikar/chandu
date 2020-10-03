import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

//------------ my packages -----------------
import '../models/userIdStatus.dart';
import '../services/firestoreService.dart';

class WelcomeWidget extends StatelessWidget {
  _addIniAssentToSF(bool assent) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('iniAssent', assent);
  }

  _addHaveUserIdToSF(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('haveUserId', status);
  }

  _addIsUserIdAvailableToSF(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isUserIdAvailable', status);
  }

  _addIsCourseSetUpDoneToSF(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isCourseSetUpDone', status);
  }

  _addCurUserIdToSF(String userId1) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('curUserId', userId1);
  }

  @override
  Widget build(BuildContext context) {
    final userIdStatus = Provider.of<UserIdStatus>(context);
    final user = Provider.of<User>(context);
    final FirestoreService _fsService = new FirestoreService();

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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Welcome, User"),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                child: Text("Continue"),
                onPressed: () async {
                  dynamic userExistenceResult =
                      await _fsService.checkUserExistence(user);
                  userIdStatus.chngUIdStatus(userExistenceResult);
                  if (userExistenceResult == true) {
                    dynamic userInfo = await _fsService.getUserInfo(user);
                    if (userInfo['pubUserId'] != null) {
                      _addIniAssentToSF(true);
                      /*userIdStatus.setHaveUserId(userInfo['haveUserId']);*/
                      _addHaveUserIdToSF(userInfo['haveUserId']);
                      /*debugPrint((userIdStatus.getUserIdStatus()).toString());*/
                      /*userIdStatus
                          .setIsUserIdAvailable(userInfo['isUserIdAvailable']);*/
                      _addIsUserIdAvailableToSF(userInfo['isUserIdAvailable']);
                      /* debugPrint(
                          (userIdStatus.getUserIdAvailableStatus()).toString());
                      userIdStatus
                          .setIsCourseSetUpDone(userInfo['isCourseSetUpDone']);*/
                      _addIsCourseSetUpDoneToSF(userInfo['isCourseSetUpDone']);
                      /* debugPrint(
                          (userIdStatus.getCourseSetUpStatus()).toString());*/
                      /*userIdStatus.setCurUserId(userInfo['pubUserId']);*/
                      _addCurUserIdToSF(userInfo['pubUserId']);
                      /* debugPrint((userIdStatus.getCurUserId()).toString());*/
                    } else {
                      //userIdStatus.setCurUserId('');
                    }
                  }
                  _fsService.updateIniAssent(user);
                  userIdStatus.processIniAssent(true);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
