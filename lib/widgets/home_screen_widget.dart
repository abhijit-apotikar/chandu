import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ------------- my packages -----------------
import '../models/userIdStatus.dart';
import '../widgets/userIdSetUpWidget.dart';
import '../widgets/courseSetUpWidget.dart';
import '../widgets/mainProduct.dart';

class HomePageWidget extends StatefulWidget {
  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  @override
  Widget build(BuildContext context) {
    final userIdStatus = Provider.of<UserIdStatus>(context);
    final _haveUserIdStatus = userIdStatus.getUserIdStatus();
    final _isCourseSetUpDone = userIdStatus.getCourseSetUpStatus();
    return Scaffold(
      body: _haveUserIdStatus
          ? (_isCourseSetUpDone ? MainProductWidget() : CourseSetUpWidget())
          : UserIdSetUpWidget(),
    );
  }
}
