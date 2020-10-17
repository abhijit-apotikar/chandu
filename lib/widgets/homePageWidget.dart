import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ------------- my packages -------------
import '../widgets/main_content_widget.dart';
import '../widgets/loadingWidget.dart';
import '../widgets/profileWidget.dart';
import '../widgets/settingsWidget.dart';
import '../models/set_up_model.dart';
import '../models/my_model.dart';
import '../services/firestoreService.dart';

class HomePageWidget extends StatefulWidget {
  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  bool _isLoading = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    EdgeInsets pdTop = MediaQuery.of(context).padding;
    SetUpModel _setUpModel = Provider.of<SetUpModel>(context);
     final cUser = Provider.of<User>(context);
    final FirestoreService _fService = new FirestoreService();

    return Scaffold(
      body: _isLoading
          ? LoadingWidget()
          : ChangeNotifierProvider<MyModel>(
              create: (_) => MyModel(),
              child: Container(
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
                // color: Color(0xfff44f),
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
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        elevation: 10,
                        child: Center(child: Consumer<MyModel>(
                          builder: (context, myModel, child) {
                            return myModel.curPg == "Home"
                                ? Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          myModel.titleText,
                                          style: TextStyle(
                                            fontSize: 32,
                                            fontFamily: 'Nunito',
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        // alignment: Alignment.centerRight,
                                        right: 10,
                                        top: size.height * 0.01,
                                        child: DropdownButton(
                                          value: _setUpModel.curSub,
                                          icon: Icon(
                                            Icons.arrow_downward,
                                            color: Colors.deepPurpleAccent,
                                          ),
                                          iconSize: 24,
                                          elevation: 16,
                                          style: TextStyle(
                                            fontFamily: 'Nunito',
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepPurpleAccent,
                                          ),
                                          underline: Container(
                                            height: 2,
                                            color: Colors.deepPurpleAccent,
                                          ),
                                          items: _setUpModel.subList
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          onChanged: (String newSub) {
                                            _setUpModel.chngCurSub(newSub);
                                          },
                                        ),
                                      )
                                    ],
                                  )
                                : Text(
                                    myModel.titleText,
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontFamily: 'Nunito',
                                    ),
                                  );
                          },
                        )),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: size.width,
                        child: Consumer<MyModel>(
                          builder: (context, myModel, child) {
                            return myModel.curPg == 'Home'
                                ? MainContentWidget()
                                : (myModel.curPg == 'Profile'
                                    ? ProfileWidget()
                                    : SettingsWidget());
                          },
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.white.withOpacity(0.4),
                      elevation: 10,
                      margin: const EdgeInsets.all(0),
                      child: Container(
                        margin: const EdgeInsets.all(0),
                        height: size.height * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Consumer<MyModel>(
                              builder: (context, myModel, child) {
                                return InkWell(
                                    child: Container(
                                        height:
                                            MediaQuery.of(context).size.height,
                                        margin: const EdgeInsets.all(0),
                                        color: myModel.clr1,
                                        width: size.width * 0.33,
                                        child: Icon(Icons.home, size: 38)),
                                    onTap: () {
                                      myModel.chngPg(1);
                                    });
                              },
                            ),
                            Consumer<MyModel>(
                              builder: (context, myModel, child) {
                                return InkWell(
                                    child: Container(
                                        height:
                                            MediaQuery.of(context).size.height,
                                        margin: const EdgeInsets.all(0),
                                        color: myModel.clr2,
                                        width: size.width * 0.33,
                                        child: Icon(Icons.person, size: 38)),
                                    onTap: () {
                                      myModel.chngPg(2);
                                    });
                              },
                            ),
                            Consumer<MyModel>(
                              builder: (context, myModel, child) {
                                return InkWell(
                                    child: Container(
                                        height:
                                            MediaQuery.of(context).size.height,
                                        margin: const EdgeInsets.all(0),
                                        color: myModel.clr3,
                                        width: size.width * 0.33,
                                        child: Icon(Icons.settings, size: 38)),
                                    onTap: () {
                                      myModel.chngPg(3);
                                    });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
