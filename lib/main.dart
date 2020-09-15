import 'package:flutter/material.dart';
import 'package:my_proc/widgets/my_list_widget.dart';
import 'package:oktoast/oktoast.dart';
import './widgets/auth_widget.dart';

import './widgets/home_screen_widget.dart';
import './widgets/set_up_widget.dart';
import './widgets/que_list_widget.dart';
import './widgets/my_quiz_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
          child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: AuthScreenWidget(),
          routes: {
            '/HomeScreenWidget': (context) => Scaffold(
                  body: HomeScreenWidget(),
                ),
            '/SetUpScreenWidget': (context) => Scaffold(
                  body: SetUpWidget(),
                ),
            '/MyListWidget': (context) => Scaffold(
                  body: MyListWidget(),
                ),
            '/MyQueListWidget': (context) => Scaffold(
                  body: MyQueListWidget(),
                ),
            '/MyQuizWidget': (context) => Scaffold(
                  body: MyQuizWidget(0,10,10),
                ),
          }),
    );
  }
}
