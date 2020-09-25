import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:my_proc/widgets/my_list_widget.dart';
import 'package:oktoast/oktoast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import './widgets/mainWrapper.dart';
import './widgets/home_screen_widget.dart';

import './widgets/que_list_widget.dart';
import './widgets/my_quiz_widget.dart';
import './widgets/result_widget.dart';
import './widgets/review_questions_widget.dart';
import './widgets/registerWidget.dart';

import './services/authService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SyncfusionLicense.registerLicense(
      'NT8mJyc2IWhia31ifWN9Z2FoYmF8YGJ8ampqanNiYmlmamlmanMDHmgyMTs6OTonfTIjPCc6ODIhYmZlEzQ+Mjo/fTA8Pg==');
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: OKToast(
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Chandu',
            routes: {
              '/': (context) => Scaffold(
                    body: MainWrapper(),
                  ),
              '/HomeScreenWidget': (context) => Scaffold(
                    body: HomeScreenWidget(),
                  ),
              '/MyListWidget': (context) => Scaffold(
                    body: MyListWidget(),
                  ),
              '/MyQueListWidget': (context) => Scaffold(
                    body: MyQueListWidget(),
                  ),
              '/MyQuizWidget': (context) => Scaffold(
                    body: MyQuizWidget(0, 0, 10),
                  ),
              '/ResultWidget': (context) => Scaffold(
                    body: ResultWidget(),
                  ),
              '/ReviewQuestionsWidget': (context) => Scaffold(
                    body: ReviewQuestionsWidget(),
                  ),
              '/RegisterWidget': (context) => Scaffold(
                    body: RegisterWidget(),
                  ),
            }),
      ),
    );
  }
}
