import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

//------------ my packages -----------------
import '../models/userIdStatus.dart';
import '../services/firestoreService.dart';

class WelcomeWidget extends StatelessWidget {
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
                      userIdStatus.setHaveUserId(userInfo['haveUserId']);
                      userIdStatus.setIsUserIdAvailable(userInfo['isUserIdAvailable']);
                      userIdStatus.setIsCourseSetUpDone(userInfo['isCourseSetUpDone']);
                      
                      userIdStatus.setCurUserId(userInfo['pubUserId']);
                    } else {
                      userIdStatus.setCurUserId('');
                    }
                  }
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
