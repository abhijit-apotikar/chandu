import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info/package_info.dart';

// -------------- my packages ------------------
import '../services/authService.dart';
import '../models/stateVariablesModel.dart';
import '../widgets/logOutAlertDialog.dart';
import '../models/colorCodeNotifier.dart';
import '../models/actualColorCodes.dart';
import '../models/colorCodeModel.dart';

class SettingsWidget extends StatefulWidget {
  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  String _version;
  @override
  Widget build(BuildContext context) {
    AuthService _authService = new AuthService();
    ColorCodeNotifier _colorCodeNotifier =
        Provider.of<ColorCodeNotifier>(context);
    ColorCodeModel localColorCode = _colorCodeNotifier.getColorCode();
    StateVariablesModel svm = Provider.of<StateVariablesModel>(context);
    // Size size = MediaQuery.of(context).size;
// ------------------ package info ------------------------
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        _version = packageInfo.version;
      });
    });
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            // height: size.height * 0.3,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 2.0, right: 2.0, top: 8.0, bottom: 8.0),
                  child: InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Log Out',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 16,
                              color: localColorCode.textColor1,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: localColorCode.textColor1,
                          ),
                        ],
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
                ),
                Divider(
                  thickness: 2.0,
                  color: localColorCode.textColor3,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 2.0, right: 2.0, top: 8.0, bottom: 8.0),
                  child: InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Change Course Set Up',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 16,
                              color: localColorCode.textColor1,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: localColorCode.textColor1,
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed('/CourseSetUpWidget');
                      }),
                ),
                Divider(
                  thickness: 2.0,
                  color: localColorCode.textColor3,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 2.0, right: 2.0, top: 8.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dark Mode',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 16,
                          color: localColorCode.textColor1,
                        ),
                      ),
                      Switch(
                        value: _colorCodeNotifier.getColorCode() == lightTheme
                            ? false
                            : true,
                        onChanged: (_) {
                          if (_colorCodeNotifier.getColorCode() == lightTheme) {
                            _colorCodeNotifier.setColorCode(darkTheme);
                          } else if (_colorCodeNotifier.getColorCode() ==
                              darkTheme) {
                            _colorCodeNotifier.setColorCode(lightTheme);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 2.0,
                  color: localColorCode.textColor3,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 2.0, right: 2.0, top: 8.0, bottom: 8.0),
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'FAQ\'s about this app',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 16,
                            color: localColorCode.textColor1,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: localColorCode.textColor1,
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 2.0,
                  color: localColorCode.textColor3,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 2.0, right: 2.0, top: 8.0, bottom: 8.0),
                  child: InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Update',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 16,
                              color: localColorCode.textColor1,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: localColorCode.textColor1,
                          ),
                        ],
                      ),
                      onTap: () {}),
                ),
                Divider(
                  thickness: 2.0,
                  color: localColorCode.textColor3,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 2.0, right: 2.0, top: 8.0, bottom: 8.0),
                  child: InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'About',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 16,
                              color: localColorCode.textColor1,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: localColorCode.textColor1,
                          ),
                        ],
                      ),
                      onTap: () {}),
                ),
                Divider(
                  thickness: 2.0,
                  color: localColorCode.textColor3,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 2.0, right: 2.0, top: 8.0, bottom: 8.0),
                  child: InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Developer Details',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 16,
                              color: localColorCode.textColor1,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: localColorCode.textColor1,
                          ),
                        ],
                      ),
                      onTap: () {}),
                ),
                Divider(
                  thickness: 2.0,
                  color: localColorCode.textColor3,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 2.0, right: 2.0, top: 8.0, bottom: 8.0),
                  child: InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Delete Account',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 16,
                              color: localColorCode.textColor1,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: localColorCode.textColor1,
                          ),
                        ],
                      ),
                      onTap: () {}),
                ),
                Divider(
                  thickness: 2.0,
                  color: localColorCode.textColor3,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 2.0,
                    right: 2.0,
                    top: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Chandu - ',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 16,
                          color: localColorCode.textColor1,
                        ),
                      ),
                      Text(
                        '$_version',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 16,
                          color: localColorCode.textColor1,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Made with ',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        // fontSize: 16,
                        color: localColorCode.textColor1,
                      ),
                    ),
                    Icon(
                      Icons.favorite,
                      color: Colors.pink,
                    ),
                    Text(
                      ' by Abhjit Apotikar.',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        //  fontSize: 16,
                        color: localColorCode.textColor1,
                      ),
                    ),
                  ],
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
