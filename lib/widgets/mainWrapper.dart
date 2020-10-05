import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/auth_widget.dart';
import '../widgets/homePageWidget.dart';
import '../widgets/userIdSetUpWidget.dart';
import '../widgets/verificationWidget.dart ';
import '../services/firestoreService.dart';
import '../models/stateVariablesModel.dart';
import '../widgets/welcomeWidget.dart';

class MainWrapper extends StatelessWidget {
  _getUDocFlagFromSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool uDocFlag = prefs.getBool('uDocFalg') ?? false;
    return uDocFlag;
  }

  _getFirstVisitFlagFromSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool firstVisitFlag = prefs.getBool('firstVisitFlag') ?? false;
    return firstVisitFlag;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final stateVariablesModel = Provider.of<StateVariablesModel>(context);
    FirestoreService fsService = new FirestoreService();
    stateVariablesModel.setUDocFlag(_getUDocFlagFromSF());
    stateVariablesModel.setFirstVisitFlag(_getFirstVisitFlagFromSF());
    bool userDocFlag = stateVariablesModel.getUDocFlag();
    bool firstVisitFlag = stateVariablesModel.getFirstVisitFlag();
    dynamic userExistenceResult = fsService.checkUserExistence(user);

    if (user == null) {
      return AuthScreenWidget();
    } else {
      if (user.emailVerified) {
        //dynamic userDocFlag = _getUDocFlagFromSF();

        if (userExistenceResult == true) {
          return !firstVisitFlag ? WelcomeWidget() : HomePageWidget();
        } else if (userDocFlag == true) {
          return !firstVisitFlag ? WelcomeWidget() : HomePageWidget();
        } else {
          return !firstVisitFlag ? WelcomeWidget() : UserIdSetUpWidget();
        }
      } else {
        return VerificationWidget();
      }
    }
  }
}
