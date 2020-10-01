import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oktoast/oktoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ------------------------ my packages ---------------
import '../services/firestoreService.dart';
import '../models/userIdStatus.dart';
import '../widgets/loadingWidget.dart';

class AcceptUserIdWidget extends StatefulWidget {
  @override
  _AcceptUserIdWidgetState createState() => _AcceptUserIdWidgetState();
}

class _AcceptUserIdWidgetState extends State<AcceptUserIdWidget> {
  // --------------- state variables -------------
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    EdgeInsets pdTop = MediaQuery.of(context).padding;
    final cUser = Provider.of<User>(context);
    final userIdStatus = context.watch<UserIdStatus>();
    final FirestoreService _fsService = new FirestoreService();
    final userId = userIdStatus.getCurUserId();
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: pdTop.top,
            ),
            SizedBox(height: 10),
            Container(
              height: size.height * 0.085,
              margin: const EdgeInsets.all(0),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                elevation: 10,
                child: Center(
                  child: Text(
                    "Set Up User ID",
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),
              ),
            ),
            Container(
                height: size.height * 0.85,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Center(
                  child: _isLoading
                      ? LoadingWidget()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'User Id Available',
                                  style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Do you want to proceed?',
                                  style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                RaisedButton(
                                  child: Text(
                                    'No',
                                    style: TextStyle(fontFamily: 'Nunito'),
                                  ),
                                  onPressed: () async {},
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                RaisedButton(
                                  child: Text(
                                    'Yes',
                                    style: TextStyle(fontFamily: 'Nunito'),
                                  ),
                                  onPressed: () async {
                                    dynamic result = await _fsService
                                        .createNewUserDocument(userId, cUser);
                                    if (result == true) {
                                     // _fsService.updateIsHaveUserId(cUser);
                                     userIdStatus.setHaveUserId(true);
                                     userIdStatus.setIsUserIdAvailable(false);
                                     userIdStatus.setIsCourseSetUpDone(false);
                                      userIdStatus.processUserId(true);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                )),
          ],
        ),
      ),
    ));
  }
}
