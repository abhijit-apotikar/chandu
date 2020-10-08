import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:my_proc/widgets/courseSetUpWidget.dart';
import 'package:provider/provider.dart';
import '../widgets/auth_widget.dart';
import '../widgets/homePageWidget.dart';
import '../widgets/userIdSetUpWidget.dart';
import '../widgets/verificationWidget.dart ';
import '../models/stateVariablesModel.dart';
import '../widgets/welcomeWidget.dart';
import '../widgets/courseSetUpWidget.dart';

class MainWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final stateVariablesModel = Provider.of<StateVariablesModel>(context);

    bool userDocFlag = stateVariablesModel.getUDocFlag();
    bool courseFlag = stateVariablesModel.getCourseFlag();
    bool firstVisitFlag = stateVariablesModel.getFirstVisitFlag();

    if (user == null) {
      return AuthScreenWidget();
    } else {
      if (user.emailVerified) {
        if (userDocFlag == true) {
          return !firstVisitFlag
              ? WelcomeWidget()
              : (courseFlag ? HomePageWidget() : CourseSetUpWidget());
        } else {
          return !firstVisitFlag ? WelcomeWidget() : UserIdSetUpWidget();
        }
      } else {
        return VerificationWidget();
      }
    }
  }
}
