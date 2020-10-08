import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ------- my packages ---------------
import '../services/firestoreService.dart';
import '../models/set_up_model.dart';
import '../models/stateVariablesModel.dart';

class CourseSetUpWidget extends StatefulWidget {
  @override
  _CourseSetUpWidgetState createState() => _CourseSetUpWidgetState();
}

class _CourseSetUpWidgetState extends State<CourseSetUpWidget> {
  _addCourseFlagToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('courseFlag', true);
  }

  String course = "B.Sc.";
  String group = 'PMCS';
  String sem = "I";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    EdgeInsets pdTop = MediaQuery.of(context).padding;
    final cUser = Provider.of<User>(context);
    StateVariablesModel svm = Provider.of<StateVariablesModel>(context);
    final FirestoreService _fsService = new FirestoreService();
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
      child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
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
                    'Set Up Screen',
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: ChangeNotifierProvider<SetUpModel>(
                  create: (context) => SetUpModel(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 30),
                          Text(
                            'Course: ',
                            style: TextStyle(
                              //  fontFamily: 'Ultra',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              // color: Colors.deepPurpleAccent,
                            ),
                          ),
                          Consumer<SetUpModel>(
                            builder: (context, setUpModel, child) {
                              return DropdownButton(
                                value: setUpModel.curCourse,
                                icon: Icon(Icons.arrow_downward),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(
                                  fontFamily: 'Typewriter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurpleAccent,
                                ),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                items: setUpModel.courseList
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String newCourse) {
                                  setUpModel.chngCurCourse(newCourse);
                                  setState(() {
                                    course = setUpModel.curCourse;
                                  });
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 30),
                          Text(
                            'Group: ',
                            style: TextStyle(
                              //  fontFamily: 'Ultra',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              // color: Colors.deepPurpleAccent,
                            ),
                          ),
                          Consumer<SetUpModel>(
                            builder: (context, setUpModel, child) {
                              return DropdownButton(
                                value: setUpModel.curSubComb,
                                icon: Icon(Icons.arrow_downward),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(
                                  fontFamily: 'Typewriter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurpleAccent,
                                ),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                items: setUpModel.subCombList
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String newSubComb) {
                                  setUpModel.chngCurSubComb(newSubComb);
                                  setState(() {
                                    course = setUpModel.curSubComb;
                                  });
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 30),
                          Text(
                            'Sem: ',
                            style: TextStyle(
                              //  fontFamily: 'Ultra',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              // color: Colors.deepPurpleAccent,
                            ),
                          ),
                          Consumer<SetUpModel>(
                            builder: (context, setUpModel, child) {
                              return DropdownButton(
                                value: setUpModel.curSem,
                                icon: Icon(Icons.arrow_downward),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(
                                  fontFamily: 'Typewriter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurpleAccent,
                                ),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                items: setUpModel.semList
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String newSem) {
                                  setUpModel.chngCurSem(newSem);
                                  setState(() {
                                    course = setUpModel.curSem;
                                  });
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 24,
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              // userIdStatus.courseSetUpStatus(true);
                            });
                            await _fsService.setCourse(
                                cUser, course, group, sem);
                            await _addCourseFlagToSF();
                            await svm.setCourseFlag(true);
                          }),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              height: size.height * 0.15,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: Text(
                      "In future you can CHANGE this SET UP through SETTINGS menu.",
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
    ));
  }
}
