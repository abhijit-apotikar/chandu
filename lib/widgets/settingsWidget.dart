import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// -------------- my packages ------------------
import '../services/authService.dart';
import '../models/stateVariablesModel.dart';
import '../widgets/logOutAlertDialog.dart';

class SettingsWidget extends StatefulWidget {
  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  @override
  Widget build(BuildContext context) {
    AuthService _authService = new AuthService();
    StateVariablesModel svm = Provider.of<StateVariablesModel>(context);
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            height: size.height * 0.3,
            child: Column(
              children: [
                Card(
                  margin: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                            child: Text(
                              'Log Out',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 24,
                                color: Colors.red,
                              ),
                            ),
                            onTap: () {
                              String msg = 'Do you really want to log out?';
                              showLogOutDialog(
                                context,
                                msg,
                                _authService,
                                svm, /*userIdStatus*/
                              );
                            }),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10,), Card(
                  margin: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                            child: Text(
                              'Change Course Set Up',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 24,
                                color: Colors.red,
                              ),
                            ),
                            onTap: () {
                            Navigator.of(context).pushNamed('/CourseSetUpWidget');
                            }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
