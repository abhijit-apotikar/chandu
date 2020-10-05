import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

//------------ my packages -----------------

import '../models/stateVariablesModel.dart';

_addFirstVisitFlagToSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('firstVisitFlag', true);
}

class WelcomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stateVariablesModel = Provider.of<StateVariablesModel>(context);
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
                    _addFirstVisitFlagToSF();
                    stateVariablesModel.setFirstVisitFlag(true);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
