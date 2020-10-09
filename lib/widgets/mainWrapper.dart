import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//-------------- my packages ------------------------
import '../widgets/auth_widget.dart';
import '../widgets/homePageWidget.dart';
import '../widgets/userIdSetUpWidget.dart';
import '../widgets/verificationWidget.dart ';
import '../widgets/welcomeWidget.dart';
import '../widgets/courseSetUpWidget.dart';
import '../models/stateVariablesModel.dart';

class MainWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final stateVariablesModel = Provider.of<StateVariablesModel>(context);

    bool userDocFlag = stateVariablesModel.getUDocFlag();
    bool firstVisitFlag = stateVariablesModel.getFirstVisitFlag();
    bool courseFlag = stateVariablesModel.getCourseFlag();

    if (user == null) {
      return AuthScreenWidget();
    } else {
      if (user.emailVerified) {
        /* if (userDocFlag == true) {
          return !firstVisitFlag
              ? WelcomeWidget()
              : (courseFlag ? HomePageWidget() : CourseSetUpWidget());
        } else {
          return !firstVisitFlag ? WelcomeWidget() : UserIdSetUpWidget();
        }*/
        if (firstVisitFlag == true) {
          return WelcomeWidget();
        } else {
          if (userDocFlag == true) {
            return courseFlag ? HomePageWidget() : CourseSetUpWidget();
          } else {
            return UserIdSetUpWidget();
          }
        }
      } else {
        return VerificationWidget();
      }
    }
  }
}
