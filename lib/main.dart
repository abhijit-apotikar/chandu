import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:my_proc/widgets/my_list_widget.dart';
import 'package:oktoast/oktoast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

// ---------------- my packages ------------------------
import './widgets/mainWrapper.dart';
import './widgets/homePageWidget.dart';
import './widgets/que_list_widget.dart';
import './widgets/result_widget.dart';
import './widgets/review_questions_widget.dart';
import './widgets/registerWidget.dart';
import './widgets/courseSetUpWidget.dart';
import './widgets/termsAndConditionsWidget.dart';
import './widgets/passwordResetWidget.dart';
import './widgets/testListWidget.dart';
import './services/authService.dart';
import './models/stateVariablesModel.dart';
import './models/set_up_model.dart';
import './models/my_list_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SyncfusionLicense.registerLicense(
      'NT8mJyc2IWhia31ifWN9Z2FoYmF8YGJ8ampqanNiYmlmamlmanMDHmgyMTs6OTonfTIjPCc6ODIhYmZlEzQ+Mjo/fTA8Pg==');
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider<StateVariablesModel>(
        create: (_) => StateVariablesModel(),
      ),
      ChangeNotifierProvider<SetUpModel>(
        create: (_) => SetUpModel(),
      ),
      ChangeNotifierProvider<MyListModel>(
        create: (_) => MyListModel(),
      )
    ], child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
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
              '/HomePageWidget': (context) => Scaffold(
                    body: HomePageWidget(),
                  ),
              '/MyListWidget': (context) => Scaffold(
                    body: MyListWidget(),
                  ),
              '/MyQueListWidget': (context) => Scaffold(
                    body: MyQueListWidget(),
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
              '/CourseSetUpWidget': (context) => Scaffold(
                    body: CourseSetUpWidget(),
                  ),
              '/TermsAndConditionsWidget': (context) => Scaffold(
                    body: TermsAndConditionsWidget(),
                  ),
              '/PasswordResetWidget': (context) => Scaffold(
                    body: PasswordResetWidget(),
                  ),
              '/TestListWidget': (context) => Scaffold(
                    body: TestListWidget(),
                  ),
            }),
      ),
    );
  }
}
