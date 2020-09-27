import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/auth_widget.dart';
import '../widgets/home_screen_widget.dart';

class MainWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user == null) {
      return AuthScreenWidget();
    } else {
      return HomePageWidget();
    }
  }
}
