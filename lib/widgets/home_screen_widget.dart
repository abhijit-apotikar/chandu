import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oktoast/oktoast.dart';
import '../widgets/profileWidget.dart';
import '../widgets/main_content_widget.dart';
import '../widgets/settingsWidget.dart';
import 'package:provider/provider.dart';
import '../models/my_model.dart';
import '../models/set_up_model.dart';

import '../shared/constants.dart';
import '../services/firestoreService.dart';
import '../services/authService.dart';
import '../widgets/loadingWidget.dart';

class HomeScreenWidget extends StatefulWidget {
  @override
  _HomeScreenWidgetState createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  //************user id set up variables*********************** */
  final _formKey1 = GlobalKey<FormState>();
  String _userId;
  bool _isUserIdAvailable = false;
  bool _isLoading = false;
  bool _haveUserId = false;

  //*******************course set up variables************** */
  bool _isCourseSetUpDone = false;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final EdgeInsets pdTop = MediaQuery.of(context).padding;
    final cUser = Provider.of<User>(context);
    final AuthService _auth = new AuthService();
    final FirestoreService _fsService = new FirestoreService();

    return Scaffold(
        body: _haveUserId
            ? (_isCourseSetUpDone
                ? ChangeNotifierProvider<MyModel>(
                    create: (context) => MyModel(),
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
                                            ChangeNotifierProvider<SetUpModel>(
                                              create: (context) => SetUpModel(),
                                              child: Positioned(
                                                // alignment: Alignment.centerRight,
                                                right: 10,
                                                top: size.height * 0.01,
                                                child: Consumer<SetUpModel>(
                                                  builder: (context, setUpModel,
                                                      child) {
                                                    return DropdownButton(
                                                      value: setUpModel.curSub,
                                                      icon: Icon(
                                                        Icons.arrow_downward,
                                                        color: Colors
                                                            .deepPurpleAccent,
                                                      ),
                                                      iconSize: 24,
                                                      elevation: 16,
                                                      style: TextStyle(
                                                        fontFamily: 'Nunito',
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors
                                                            .deepPurpleAccent,
                                                      ),
                                                      underline: Container(
                                                        height: 2,
                                                        color: Colors
                                                            .deepPurpleAccent,
                                                      ),
                                                      items: setUpModel.subList
                                                          .map<
                                                              DropdownMenuItem<
                                                                  String>>((String
                                                              value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                      onChanged:
                                                          (String newSub) {
                                                        setUpModel
                                                            .chngCurSub(newSub);
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      : Text(
                                          myModel.titleText,
                                          style: TextStyle(
                                            fontSize: 32,
                                            // fontFamily: 'Ultra',
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Consumer<MyModel>(
                                    builder: (context, myModel, child) {
                                      return InkWell(
                                          child: Container(
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              margin: const EdgeInsets.all(0),
                                              color: myModel.clr1,
                                              width: size.width * 0.33,
                                              child:
                                                  Icon(Icons.home, size: 38)),
                                          onTap: () {
                                            myModel.chngPg(1);
                                          });
                                    },
                                  ),
                                  Consumer<MyModel>(
                                    builder: (context, myModel, child) {
                                      return InkWell(
                                          child: Container(
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              margin: const EdgeInsets.all(0),
                                              color: myModel.clr2,
                                              width: size.width * 0.33,
                                              child:
                                                  Icon(Icons.person, size: 38)),
                                          onTap: () {
                                            myModel.chngPg(2);
                                          });
                                    },
                                  ),
                                  Consumer<MyModel>(
                                    builder: (context, myModel, child) {
                                      return InkWell(
                                          child: Container(
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              margin: const EdgeInsets.all(0),
                                              color: myModel.clr3,
                                              width: size.width * 0.33,
                                              child: Icon(Icons.settings,
                                                  size: 38)),
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
                  )
                : Container(
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
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                          builder:
                                              (context, setUpModel, child) {
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
                                              items: setUpModel.courseList.map<
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
                                            //  fontFamily: 'Ultra',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            // color: Colors.deepPurpleAccent,
                                          ),
                                        ),
                                        Consumer<SetUpModel>(
                                          builder:
                                              (context, setUpModel, child) {
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
                                              items: setUpModel.subCombList.map<
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
                                            //  fontFamily: 'Ultra',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            // color: Colors.deepPurpleAccent,
                                          ),
                                        ),
                                        Consumer<SetUpModel>(
                                          builder:
                                              (context, setUpModel, child) {
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
                                              items: setUpModel.semList.map<
                                                      DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              onChanged: (String newSem) {
                                                setUpModel.chngCurSem(newSem);
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
                                        onPressed: () {
                                          setState(() {
                                            _isCourseSetUpDone = true;
                                          });
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
                  ))
            : Container(
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
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        child: Center(
                            child: _isLoading
                                ? LoadingWidget()
                                : (_isUserIdAvailable
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              'User id Available. Do U want to continue?'),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              RaisedButton(
                                                child: Text('Yes'),
                                                onPressed: () async {
                                                  setState(() {
                                                    _haveUserId = true;
                                                  });
                                                  dynamic result =
                                                      await _fsService
                                                          .createNewUserDocument(
                                                              _userId, cUser);
                                                  if (result == true) {
                                                    showToast(
                                                        'User id has been set successfully.',
                                                        textStyle: TextStyle(
                                                            fontFamily:
                                                                'Nunito'),
                                                        position: ToastPosition
                                                            .bottom);
                                                  } else {
                                                    showToast(
                                                        'Some problem occured.',
                                                        textStyle: TextStyle(
                                                            fontFamily:
                                                                'Nunito'),
                                                        position: ToastPosition
                                                            .bottom);
                                                  }
                                                },
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              RaisedButton(
                                                child: Text('No'),
                                                onPressed: () {
                                                  setState(() {
                                                    _isUserIdAvailable = false;
                                                    showToast(
                                                        'You can look for a different User id.',
                                                        textStyle: TextStyle(
                                                            fontFamily:
                                                                'Nunito'),
                                                        position: ToastPosition
                                                            .bottom);
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : Form(
                                        key: _formKey1,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextFormField(
                                              style: myTextFormFieldTextStyle,
                                              decoration:
                                                  textFormFieldDecoration
                                                      .copyWith(
                                                          hintText: 'User Id'),
                                              validator: (val) => val.isEmpty
                                                  ? "User Id can't be empty."
                                                  : (val.length < 2
                                                      ? 'User Id should be atleast 3 characters long'
                                                      : (val.length > 20
                                                          ? 'User Id should be atmost 20 characters long'
                                                          : null)),
                                              onChanged: (val) {
                                                _userId = val;
                                              },
                                            ),
                                            SizedBox(height: 25),
                                            RaisedButton(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Text(
                                                  "Check Availability",
                                                  style: TextStyle(
                                                      fontFamily: 'Nunito',
                                                      fontSize: 20),
                                                ),
                                              ),
                                              onPressed: () async {
                                                if (_formKey1.currentState
                                                    .validate()) {
                                                  /* String msg =
                                              "Do you want to proceed?";
                                          showUserIdAvailableDialog(
                                              context, msg);*/
                                                  setState(() {
                                                    _isLoading = true;
                                                  });
                                                  dynamic result =
                                                      await _fsService
                                                          .checkAvailability(
                                                              _userId);
                                                  if (result == true) {
                                                    setState(() {
                                                      _isLoading = false;
                                                      _isUserIdAvailable = true;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      _isLoading = false;
                                                      showToast(
                                                          'User id not available. Try with some different user id.',
                                                          textStyle: TextStyle(
                                                              fontFamily:
                                                                  'Nunito'),
                                                          position:
                                                              ToastPosition
                                                                  .bottom);
                                                    });
                                                  }
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ))),
                      ),
                    ],
                  ),
                ),
              ));
    /*: Container(
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
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        child: Center(
                            child: _isLoading
                                ? LoadingWidget()
                                : (_isUserIdAvailable
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              'User id Available. Do U want to continue?'),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              RaisedButton(
                                                child: Text('Yes'),
                                                onPressed: () {
                                                  setState(() {});
                                                },
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              RaisedButton(
                                                child: Text('Yes'),
                                                onPressed: () {},
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : Form(
                                        key: _formKey1,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextFormField(
                                              style: myTextFormFieldTextStyle,
                                              decoration:
                                                  textFormFieldDecoration
                                                      .copyWith(
                                                          hintText: 'User Id'),
                                              validator: (val) => val.isEmpty
                                                  ? "User Id can't be empty."
                                                  : (val.length < 2
                                                      ? 'Uset Id should be atleast 3 characters long'
                                                      : (val.length > 20
                                                          ? 'User Id should be atmost 20 characters long'
                                                          : null)),
                                              onChanged: (val) {
                                                _userId = val;
                                              },
                                            ),
                                            SizedBox(height: 25),
                                            RaisedButton(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Text(
                                                  "Check Availability",
                                                  style: TextStyle(
                                                      fontFamily: 'Nunito',
                                                      fontSize: 20),
                                                ),
                                              ),
                                              onPressed: () {
                                                if (_formKey1.currentState
                                                    .validate()) {
                                                  /* String msg =
                                              "Do you want to proceed?";
                                          showUserIdAvailableDialog(
                                              context, msg);*/
                                                  setState(() {
                                                    // _isUserIdAvailable = true;
                                                    _haveUserId = true;
                                                  });
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ))),
                      ),
                    ],
                  ),
                ),
              ));*/
    /*ChangeNotifierProvider<MyModel>(
              create: (context) => MyModel(),
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
                                      ChangeNotifierProvider<SetUpModel>(
                                        create: (context) => SetUpModel(),
                                        child: Positioned(
                                          // alignment: Alignment.centerRight,
                                          right: 10,
                                          top: size.height * 0.01,
                                          child: Consumer<SetUpModel>(
                                            builder:
                                                (context, setUpModel, child) {
                                              return DropdownButton(
                                                value: setUpModel.curSub,
                                                icon: Icon(
                                                  Icons.arrow_downward,
                                                  color:
                                                      Colors.deepPurpleAccent,
                                                ),
                                                iconSize: 24,
                                                elevation: 16,
                                                style: TextStyle(
                                                  fontFamily: 'Nunito',
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      Colors.deepPurpleAccent,
                                                ),
                                                underline: Container(
                                                  height: 2,
                                                  color:
                                                      Colors.deepPurpleAccent,
                                                ),
                                                items: setUpModel.subList.map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                                onChanged: (String newSub) {
                                                  setUpModel.chngCurSub(newSub);
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : Text(
                                    myModel.titleText,
                                    style: TextStyle(
                                      fontSize: 32,
                                      // fontFamily: 'Ultra',
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
            ),*/
  }
}
