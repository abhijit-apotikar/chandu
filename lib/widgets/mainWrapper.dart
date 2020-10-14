import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//-------------- my packages ------------------------
import '../widgets/auth_widget.dart';
import '../widgets/homePageWidget.dart';
import '../widgets/userIdSetUpWidget.dart';
import '../widgets/verificationWidget.dart ';
import '../widgets/welcomeWidget.dart';
import '../widgets/courseSetUpWidget.dart';
import '../models/stateVariablesModel.dart';

class MainWrapper extends StatefulWidget {
  /*dynamic setUserDocFlag(StateVariablesModel svm) async {
    return await svm.getUDocFlag();
  }

  dynamic setFirstVisitFlag(StateVariablesModel svm) async {
    return await svm.getFirstVisitFlag();
  }

  dynamic setCourseFlag(StateVariablesModel svm) async {
    return await svm.getCourseFlag();
  }*/

  @override
  _MainWrapperState createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  dynamic firstVisitFlag;
  dynamic userDocFlag;
  dynamic courseFlag;
  _getUDocFlagFromSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool uDocFlag = prefs.getBool('uDocFlag') ?? false;
    return uDocFlag;
  }

  _getFirstVisitFlagFromSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool firstVisitFlag = prefs.getBool('firstVisitFlag') ?? true;
    return firstVisitFlag;
  }

  _getCourseFlagFromSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool courseFlag = prefs.getBool('courseFlag') ?? false;
    return courseFlag;
  }

  _setVariables(StateVariablesModel svm) async {
    await svm.setFirstVisitFlag(await _getFirstVisitFlagFromSF());
    await svm.setUDocFlag(await _getUDocFlagFromSF());
    await svm.setCourseFlag(await _getCourseFlagFromSF());
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final svm = Provider.of<StateVariablesModel>(context);
    if (svm.getFirstVisitFlag() == true) _setVariables(svm);
    dynamic firstVisitFlag = svm.getFirstVisitFlag();
    dynamic userDocFlag = svm.getUDocFlag();
    dynamic courseFlag = svm.getCourseFlag();

    return Scaffold(
        body: user == null
            ? AuthScreenWidget()
            : (user.emailVerified
                ? (firstVisitFlag == true
                    ? WelcomeWidget()
                    : (userDocFlag == true
                        ? (courseFlag == true
                            ? HomePageWidget()
                            : CourseSetUpWidget())
                        : UserIdSetUpWidget()))
                : VerificationWidget()));
    /*if (user == null) {
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
            if (courseFlag == true) {
              return HomePageWidget();
            } else {
              return CourseSetUpWidget();
            }
          } else {
            return UserIdSetUpWidget();
          }
        }
      } else {
        return VerificationWidget();
      }
    }*/
  }
}
