import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ------- my packages ---------------
import '../widgets/loadingWidget.dart';
import '../services/firestoreService.dart';
import '../models/set_up_model.dart';
import '../models/stateVariablesModel.dart';
import '../models/colorCodeModel.dart';
import '../models/colorCodeNotifier.dart';

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
  String sem = "VI";

  bool groupSelect = false;
  bool semSelect = false;
  bool courseAvailability = false;

  GlobalKey _scaffold = GlobalKey();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    EdgeInsets pdTop = MediaQuery.of(context).padding;
    final cUser = Provider.of<User>(context);
    StateVariablesModel svm = Provider.of<StateVariablesModel>(context);
    final FirestoreService _fsService = new FirestoreService();
    ColorCodeNotifier _colorCodeNotifier =
        Provider.of<ColorCodeNotifier>(context);
    ColorCodeModel localColorCode = _colorCodeNotifier.getColorCode();
    return Scaffold(
        backgroundColor: localColorCode.cardColor,
        key: _scaffold,
        body: isLoading
            ? LoadingWidget()
            : Container(
                decoration: BoxDecoration(
                  gradient: new LinearGradient(
                      colors: [
                        localColorCode.backGroundColor1,
                        localColorCode.backGroundColor2,
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
                          color: localColorCode.cardColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          elevation: 10,
                          child: Center(
                            child: Text(
                              'Set Up Screen',
                              style: TextStyle(
                                fontSize: 32,
                                fontFamily: 'Nunito',
                                color: localColorCode.textColor1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: StreamBuilder(
                          stream: _fsService.fireStoreInstance
                              .collection('courses')
                              .snapshots(),
                          builder: (context, snapshots) {
                            if (!snapshots.hasData) {
                              return Center(
                                child: new CircularProgressIndicator(),
                              );
                            }
                            List<String> courseList = [];
                            List<String> groupList = [];
                            List<String> semList = [];

                            for (int i = 0;
                                i < snapshots.data.documents.length;
                                i++) {
                              courseList.add(
                                  '${snapshots.data.documents[i].data()['cName']}');
                            }

                            for (int i = 0;
                                i < snapshots.data.documents.length;
                                i++) {
                              for (int j = 0;
                                  j <
                                      snapshots.data.documents[i]
                                          .data()['cScheme']['branches']
                                          .length;
                                  j++) {
                                if (snapshots.data.documents[i]
                                        .data()['cName'] ==
                                    course) {
                                  groupList.add(snapshots.data.documents[i]
                                          .data()['cScheme']['branches'][j]
                                      ['bName']);
                                }
                              }
                            }

                            for (int i = 0;
                                i < snapshots.data.documents.length;
                                i++) {
                              if (snapshots.data.documents[i].data()['cName'] ==
                                  course) {
                                if (snapshots.data.documents[i]
                                        .data()['cScheme']['totalSem'] ==
                                    4) {
                                  semList.add('I');
                                  semList.add('II');
                                  semList.add('III');
                                  semList.add('IV');
                                } else if (snapshots.data.documents[i]
                                        .data()['cScheme']['totalSem'] ==
                                    6) {
                                  semList.add('I');
                                  semList.add('II');
                                  semList.add('III');
                                  semList.add('IV');
                                  semList.add('V');
                                  semList.add('VI');
                                } else if (snapshots.data.documents[i]
                                        .data()['cScheme']['totalSem'] ==
                                    8) {
                                  semList.add('I');
                                  semList.add('II');
                                  semList.add('III');
                                  semList.add('IV');
                                  semList.add('V');
                                  semList.add('VI');
                                  semList.add('VII');
                                  semList.add('VIII');
                                }
                              }
                            }

                            return new Container(
                              child: ChangeNotifierProvider<SetUpModel>(
                                create: (context) => SetUpModel(),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 30),
                                        Text(
                                          'Course: ',
                                          style: TextStyle(
                                            fontFamily: 'Nunito',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: localColorCode.textColor1,
                                          ),
                                        ),
                                        Consumer<SetUpModel>(
                                          builder:
                                              (context, setUpModel, child) {
                                            return DropdownButton(
                                              value: setUpModel.curCourse ==
                                                      courseList[0]
                                                  ? courseList[0]
                                                  : course,
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
                                              items: courseList.map<
                                                      DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              onChanged: (String newCourse) {
                                                setUpModel
                                                    .chngCurCourse(newCourse);
                                                groupList.clear();
                                                semList.clear();
                                                setState(() {
                                                  course = newCourse;
                                                  groupSelect = false;
                                                  semSelect = false;
                                                });

                                                setUpModel.chngCurSubComb(
                                                    groupList[0]);

                                                setUpModel
                                                    .chngCurSem(semList[0]);
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 30),
                                        Text(
                                          'Group: ',
                                          style: TextStyle(
                                            fontFamily: 'Nunito',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: localColorCode.textColor1,
                                          ),
                                        ),
                                        Consumer<SetUpModel>(
                                          builder:
                                              (context, setUpModel, child) {
                                            return DropdownButton(
                                              value: groupList.contains(
                                                      setUpModel.curSubComb)
                                                  ? setUpModel.curSubComb
                                                  : groupList[0],
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
                                              items: groupList.map<
                                                      DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              onChanged: (String newSubComb) {
                                                setUpModel
                                                    .chngCurSubComb(newSubComb);
                                                setState(() {
                                                  group = newSubComb;
                                                  groupSelect = true;
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 30),
                                        Text(
                                          'Sem: ',
                                          style: TextStyle(
                                            fontFamily: 'Nunito',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: localColorCode.textColor1,
                                          ),
                                        ),
                                        Consumer<SetUpModel>(
                                          builder:
                                              (context, setUpModel, child) {
                                            return DropdownButton(
                                              value: semList.contains(
                                                      setUpModel.curSem)
                                                  ? setUpModel.curSem
                                                  : semList[0],
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
                                              items: semList.map<
                                                      DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              onChanged: (String newSem) {
                                                setUpModel.chngCurSem(newSem);
                                                setState(() {
                                                  sem = newSem;
                                                  semSelect = true;
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
                                          color: localColorCode.textColor2,
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (groupSelect && semSelect) {
                                          setState(() {
                                            // userIdStatus.courseSetUpStatus(true);
                                            isLoading = true;
                                          });
                                          bool courseAvailability =
                                              await _fsService
                                                  .checkCourseAvailability(
                                                      course);
                                          if (courseAvailability) {
                                            bool branchAvailability =
                                                await _fsService
                                                    .checkBranchAvailability(
                                                        course, group);
                                            if (branchAvailability) {
                                              bool semAvailability =
                                                  await _fsService
                                                      .checkSemAvailability(
                                                          course, group, sem);
                                              if (semAvailability) {
                                                dynamic result =
                                                    await _fsService.setCourse(
                                                        cUser,
                                                        course,
                                                        group,
                                                        sem);
                                                if (result == true) {
                                                  /* Map<String, dynamic>
                                                      _setData =
                                                      await _fsService
                                                          .getSetUpData(course,
                                                              group, sem);
                                                  if (_setData.isNotEmpty) {
                                                    _setUpModel
                                                        .setData(_setData);
                                                  }
                                                  List<Map<String, dynamic>>
                                                      _setListModel =
                                                      await _fsService
                                                          .getChapters(
                                                              course,
                                                              group,
                                                              sem,
                                                              'Linear Algebra');
                                                  if (_setListModel
                                                      .isNotEmpty) {
                                                    _myListModel.setChapterList(
                                                        _setListModel);
                                                  }*/
                                                  if (result == true) {
                                                    if (await svm
                                                        .getCourseFlag()) {
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                      Navigator.of(_scaffold
                                                              .currentContext)
                                                          .pop();
                                                    } else {
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                      await _addCourseFlagToSF();
                                                      await svm
                                                          .setCourseFlag(true);
                                                    }
                                                    showToast(
                                                      ' Course set up successful. ',
                                                      textStyle: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          color: localColorCode
                                                              .toastTextColor),
                                                      position:
                                                          ToastPosition.bottom,
                                                      backgroundColor:
                                                          localColorCode
                                                              .toastBackgroundColor,
                                                    );
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                  }
                                                } else {
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                  showToast(
                                                    ' Sorry, Selected sem not available. ',
                                                    textStyle: TextStyle(
                                                        fontFamily: 'Nunito',
                                                        color: localColorCode
                                                            .toastTextColor),
                                                    position:
                                                        ToastPosition.bottom,
                                                    backgroundColor:
                                                        localColorCode
                                                            .toastBackgroundColor,
                                                  );
                                                }
                                              } else {
                                                setState(() {
                                                  isLoading = false;
                                                });
                                                showToast(
                                                  ' Sorry, Selected branch not available. ',
                                                  textStyle: TextStyle(
                                                      fontFamily: 'Nunito',
                                                      color: localColorCode
                                                          .toastTextColor),
                                                  position:
                                                      ToastPosition.bottom,
                                                  backgroundColor:
                                                      localColorCode
                                                          .toastBackgroundColor,
                                                );
                                              }
                                            } else {
                                              setState(() {
                                                isLoading = false;
                                              });
                                              showToast(
                                                ' Sorry, Selected course not available. ',
                                                textStyle: TextStyle(
                                                    fontFamily: 'Nunito',
                                                    color: localColorCode
                                                        .toastTextColor),
                                                position: ToastPosition.bottom,
                                                backgroundColor: localColorCode
                                                    .toastBackgroundColor,
                                              );
                                            }
                                          } else if (!groupSelect) {
                                            showToast(
                                              ' You must explicitly select group. ',
                                              textStyle: TextStyle(
                                                  fontFamily: 'Nunito',
                                                  color: localColorCode
                                                      .toastTextColor),
                                              position: ToastPosition.bottom,
                                              backgroundColor: localColorCode
                                                  .toastBackgroundColor,
                                            );
                                          } else if (!semSelect) {
                                            showToast(
                                              ' You must explicitly select sem. ',
                                              textStyle: TextStyle(
                                                  fontFamily: 'Nunito',
                                                  color: localColorCode
                                                      .toastTextColor),
                                              position: ToastPosition.bottom,
                                              backgroundColor: localColorCode
                                                  .toastBackgroundColor,
                                            );
                                          }
                                        }
                                      },
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      /*Container(
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
                      ),*/
                    ]),
              ));
  }
}
