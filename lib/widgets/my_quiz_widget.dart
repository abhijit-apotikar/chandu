import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

// ----------------- my packages ----------------
import '../my_arguments/test_arguments.dart';
import '../widgets/alertDialog.dart';
import '../widgets/loadingWidget.dart';
import '../services/firestoreService.dart';
import '../models/set_up_model.dart';

class MyQuizWidget extends StatefulWidget {
  final String _testName;
  final int _hours;
  final int _minutes;
  final int _seconds;
  MyQuizWidget(this._testName, this._hours, this._minutes, this._seconds);
  @override
  _MyQuizWidgetState createState() => _MyQuizWidgetState();
}

class _MyQuizWidgetState extends State<MyQuizWidget> {
  //Color _reviewIconColor = Colors.grey;
  bool _isLoading = false;
  int _curIndex = 0;
  Timer _timer;
  int _start1;
  bool _tmpBool = false;
  bool _tmpBoolCancel = false;
  bool _presentSubmitDialog = false;
  bool _submit = false;

  //test result variables*******************************************************************
  int _queAttempted = 0;
  bool _markedForReview = false;
  int _queMarkedForReview = 0;
  String _curMarked;
  List<Map<String, String>> _testAttempt = [];
  List<Map<String, bool>> _reviewList = [];

  int index = 0;

  void setStart1() {
    _start1 =
        (widget._hours * 60 * 60) + (widget._minutes * 60) + widget._seconds;
  }

  void startTimer1(context) async {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        if (_start1 < 1) {
          timer.cancel();
        } else {
          _start1 = _start1 - 1;
          if (_submit) {
            if (_tmpBool) {
              timer.cancel();
            } else if (_tmpBoolCancel) {
              _submit = false;
            }
          }
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setStart1();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    EdgeInsets pdTop = MediaQuery.of(context).padding;
    FirestoreService _fService = new FirestoreService();
    SetUpModel _setUpModel = Provider.of<SetUpModel>(context);
    List<Map<String, dynamic>> myQueList = [];

    return WillPopScope(
      onWillPop: () async {
        if (index != 0) {
          showAlertDialog(context, 'Going back not allowed.');
        }
        return index == 0 ? true : false;
      },
      child: Scaffold(
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
          child: _isLoading
              ? LoadingWidget()
              : FutureBuilder(
                  future: _fService.getTestQuestions(
                    _setUpModel.curSub,
                    widget._testName,
                    /*  widget._hours,
                  widget._minutes,
                  widget._seconds*/
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasError || snapshot.data == false) {
                      return Text('Test failed to load');
                    } else if (snapshot.hasData) {
                      myQueList = snapshot.data;
                      return myQueList.length == 0
                          ? Text('Test failed to load')
                          : IndexedStack(index: _curIndex, children: [
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: pdTop.top + 10.0),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(4.0),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.blueAccent),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0)),
                                            ),
                                            child: Text(
                                              'Test Id: ${widget._testName}',
                                              style: TextStyle(
                                                fontFamily: 'Nunito',
                                                fontSize: 22,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'As soon as you press on the Start button, the test timer will start running, marking the start of the test. You can also give up the thought of taking up the test by pressing on the Cancel button or back button, if you wish to do so.',
                                                style: TextStyle(
                                                    fontFamily: 'Nunito'),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            InkWell(
                                              child: Container(
                                                width: size.width * 0.4,
                                                height: size.height * 0.1,
                                                child: Card(
                                                  color: Colors.green,
                                                  child: Center(
                                                    child: Text('Start',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Nunito',
                                                            fontSize: 28)),
                                                  ),
                                                ),
                                              ),
                                              onTap: () async {
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                                var _docId = await _fService
                                                    .getTestDocumentId(
                                                        widget._testName);
                                                var _result = await _fService
                                                    .increaseTestAttempCount(
                                                        _docId,
                                                        widget._testName);
                                                if (_result == true) {
                                                  setState(() {
                                                    _isLoading = false;
                                                    _curIndex = 1;
                                                    startTimer1(context);
                                                  });
                                                }
                                              },
                                            ),
                                            SizedBox(
                                              height: 40,
                                            ),
                                            InkWell(
                                                child: Container(
                                                  width: size.width * .4,
                                                  height: size.height * 0.1,
                                                  child: Card(
                                                    color: Colors.red[400],
                                                    child: Center(
                                                      child: Text('Cancel',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Nunito',
                                                              fontSize: 28)),
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    Navigator.of(context).pop();
                                                  });
                                                }),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: pdTop.top,
                                  ),
                                  Container(
                                    height: size.height * 0.11,
                                    child: Row(
                                      children: [
                                        Card(
                                          margin: const EdgeInsets.all(0),
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            width: size.width * 0.2,
                                            child: GestureDetector(
                                              child: Icon(
                                                Icons.star,
                                                size: 52,
                                                color: _markedForReview == true
                                                    ? Colors.yellow
                                                    : Colors.grey,
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  if (!_presentSubmitDialog) {
                                                    _markedForReview =
                                                        !_markedForReview;

                                                    if (_markedForReview) {
                                                      showToast(
                                                          'Current question added to review list.',
                                                          textStyle: TextStyle(
                                                              fontFamily:
                                                                  'Nunito'),
                                                          position:
                                                              ToastPosition
                                                                  .bottom);
                                                    } else {
                                                      showToast(
                                                          'Current question removed from review list.',
                                                          textStyle: TextStyle(
                                                              fontFamily:
                                                                  'Nunito'),
                                                          position:
                                                              ToastPosition
                                                                  .bottom);
                                                    }

                                                    if (_reviewList
                                                        .where((element) =>
                                                            element.containsKey(
                                                                '${myQueList[index]['queId']}'))
                                                        .isEmpty) {
                                                      _queMarkedForReview++;

                                                      _reviewList.add({
                                                        '${myQueList[index]['queId']}':
                                                            true
                                                      });
                                                    } else {
                                                      _queMarkedForReview--;

                                                      _reviewList
                                                          .firstWhere((element) =>
                                                              element.containsKey(
                                                                  '${myQueList[index]['queId']}'))
                                                          .remove(
                                                              '${myQueList[index]['queId']}');
                                                    }
                                                  } else {
                                                    showToast(
                                                        ' Action not allowed. ',
                                                        textStyle: TextStyle(
                                                            fontFamily:
                                                                'Nunito'),
                                                        position: ToastPosition
                                                            .bottom);
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      ((_start1) / 3600) < 10
                                                          ? '0' +
                                                              '${((_start1) / 3600).floor()}' +
                                                              ':'
                                                          : '${((_start1) / 3600).floor()}' +
                                                              ':',
                                                      style: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 38),
                                                    ),
                                                    Text(
                                                      ((((_start1) % 3600) / 60)
                                                                  .floor()) <
                                                              10
                                                          ? '0' +
                                                              '${(((_start1) % 3600) / 60).floor()}' +
                                                              ':'
                                                          : '${(((_start1) % 3600) / 60).floor()}' +
                                                              ':',
                                                      style: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 38),
                                                    ),
                                                    Text(
                                                      (((_start1) % 3600) % 60)
                                                                  .floor() <
                                                              10
                                                          ? ((_start1) == 0
                                                              ? '00'
                                                              : '0' +
                                                                  '${(((_start1) % 3600) % 60).floor()}')
                                                          : '${(((_start1) % 3600) % 60).floor()}',
                                                      style: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 38),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Divider(
                                                thickness: 2,
                                                height: 1,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Attempted : ',
                                                    style: TextStyle(
                                                      fontFamily: 'Nunito',
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  Text(
                                                    '$_queAttempted',
                                                    style: TextStyle(
                                                        fontFamily: 'Nunito',
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red),
                                                  ),
                                                ],
                                              ),
                                              Divider(
                                                thickness: 2,
                                                height: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Card(
                                          margin: const EdgeInsets.all(0),
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            width: size.width * 0.2,
                                            child: GestureDetector(
                                              child: Icon(
                                                Icons.power_settings_new,
                                                size: 52,
                                                color: Colors.red,
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  _presentSubmitDialog = true;
                                                  _submit = true;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      child: _start1 < 1
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: Center(
                                                    child: Card(
                                                      color: Colors.redAccent,
                                                      elevation: 20,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Container(
                                                        width: size.width * 0.8,
                                                        height:
                                                            size.height * 0.3,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 20,
                                                                vertical: 10),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'Time\'s up!',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Nunito',
                                                                    fontSize:
                                                                        32,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Expanded(
                                                              child: Row(
                                                                children: [
                                                                  Flexible(
                                                                    child: Text(
                                                                      'Your test has been submitted successfully.',
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Nunito',
                                                                        fontSize:
                                                                            18,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                RaisedButton(
                                                                  color: Colors
                                                                      .yellow,
                                                                  child: Text(
                                                                      'Ok',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Nunito',
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      _tmpBool =
                                                                          true;
                                                                      TestArguments testArguments = new TestArguments(
                                                                          widget
                                                                              ._testName,
                                                                          _testAttempt,
                                                                          _reviewList,
                                                                          myQueList
                                                                              .length,
                                                                          widget
                                                                              ._hours,
                                                                          widget
                                                                              ._minutes,
                                                                          widget
                                                                              ._seconds);
                                                                      Navigator.of(
                                                                              context)
                                                                          .pushReplacementNamed(
                                                                        '/ResultWidget',
                                                                        arguments:
                                                                            testArguments,
                                                                      );
                                                                    });
                                                                  },
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : (_presentSubmitDialog
                                              ? Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Center(
                                                      child: Center(
                                                        child: Card(
                                                          color:
                                                              Colors.redAccent,
                                                          elevation: 20,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          child: Container(
                                                            width: size.width *
                                                                0.8,
                                                            height:
                                                                size.height *
                                                                    0.3,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        10),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      'Alert!',
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Nunito',
                                                                        fontSize:
                                                                            32,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        //color: Colors.red,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Expanded(
                                                                  child: Row(
                                                                    children: [
                                                                      Flexible(
                                                                        child:
                                                                            Text(
                                                                          'Do you really want to submit your test?',
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                'Nunito',
                                                                            fontSize:
                                                                                18,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    RaisedButton(
                                                                      color: Colors
                                                                          .yellow,
                                                                      child: Text(
                                                                          'Yes',
                                                                          style: TextStyle(
                                                                              fontFamily: 'Nunito',
                                                                              fontSize: 20,
                                                                              fontWeight: FontWeight.bold)),
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          _tmpBool =
                                                                              true;
                                                                          TestArguments testArguments = new TestArguments(
                                                                              widget._testName,
                                                                              _testAttempt,
                                                                              _reviewList,
                                                                              myQueList.length,
                                                                              widget._hours,
                                                                              widget._minutes,
                                                                              widget._seconds);
                                                                          Navigator.of(context)
                                                                              .pushReplacementNamed(
                                                                            '/ResultWidget',
                                                                            arguments:
                                                                                testArguments,
                                                                          );
                                                                        });
                                                                      },
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    RaisedButton(
                                                                      child:
                                                                          Text(
                                                                        'No',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Nunito',
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          _tmpBoolCancel =
                                                                              true;
                                                                          _presentSubmitDialog =
                                                                              false;
                                                                        });
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                                  child: Card(
                                                    shadowColor: Colors.black45,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    color: Colors.transparent,
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 15,
                                                          vertical: 15,
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                  '${index + 1} / ${myQueList.length}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Nunito',
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.9),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Flexible(
                                                                  child: Text(
                                                                    'Q.) ' +
                                                                        myQueList[index]
                                                                            [
                                                                            'que'],
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Nunito',
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 20),
                                                            Container(
                                                              child: InkWell(
                                                                child: Card(
                                                                  color: Colors
                                                                      .transparent,
                                                                  margin:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0),
                                                                  child: Row(
                                                                    children: [
                                                                      Card(
                                                                        margin:
                                                                            EdgeInsets.all(0),
                                                                        color: _curMarked ==
                                                                                '${myQueList[index]['options'][0]}'
                                                                            ? Colors.blue
                                                                            : Colors.white,
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(4.0),
                                                                          child:
                                                                              Text(
                                                                            'a)',
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: 'Nunito',
                                                                              fontSize: 16,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Card(
                                                                        color: Colors
                                                                            .transparent,
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Card(
                                                                          color: _curMarked == '${myQueList[index]['options'][0]}'
                                                                              ? Colors.blue
                                                                              : Colors.white,
                                                                          margin:
                                                                              EdgeInsets.all(0),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.all(4),
                                                                            child:
                                                                                Text(
                                                                              myQueList[index]['options'][0],
                                                                              style: TextStyle(
                                                                                fontFamily: 'Nunito',
                                                                                fontSize: 18,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  setState(() {
                                                                    if (_curMarked ==
                                                                        '${myQueList[index]['options'][0]}') {
                                                                      _curMarked =
                                                                          null;
                                                                      _queAttempted--;
                                                                      _testAttempt
                                                                          .firstWhere((element) => element.containsKey(
                                                                              '${myQueList[index]['queId']}'))
                                                                          .remove(
                                                                              '${myQueList[index]['queId']}');
                                                                    } else {
                                                                      _curMarked =
                                                                          '${myQueList[index]['options'][0]}';

                                                                      if (_testAttempt
                                                                          .where((element) =>
                                                                              element.containsKey('${myQueList[index]['queId']}'))
                                                                          .isEmpty) {
                                                                        _queAttempted++;

                                                                        _testAttempt
                                                                            .add({
                                                                          '${myQueList[index]['queId']}':
                                                                              '${myQueList[index]['options'][0]}'
                                                                        });
                                                                      } else {
                                                                        _testAttempt.firstWhere((element) => element.containsKey('${myQueList[index]['queId']}')).update(
                                                                            '${myQueList[index]['queId']}',
                                                                            (value) =>
                                                                                '${myQueList[index]['options'][0]}');
                                                                      }
                                                                    }
                                                                  });
                                                                  debugPrint(
                                                                      '$_curMarked %%%%%%%%%%%%%%%%%%%%%%%%%');
                                                                },
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Container(
                                                              child: InkWell(
                                                                child: Card(
                                                                  color: Colors
                                                                      .transparent,
                                                                  margin:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0),
                                                                  child: Row(
                                                                    children: [
                                                                      Card(
                                                                        color: _curMarked ==
                                                                                '${myQueList[index]['options'][1]}'
                                                                            ? Colors.blue
                                                                            : Colors.white,
                                                                        margin:
                                                                            EdgeInsets.all(0),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(4.0),
                                                                          child:
                                                                              Text(
                                                                            'b)',
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: 'Nunito',
                                                                              fontSize: 16,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Card(
                                                                        color: Colors
                                                                            .transparent,
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Card(
                                                                          color: _curMarked == '${myQueList[index]['options'][1]}'
                                                                              ? Colors.blue
                                                                              : Colors.white,
                                                                          margin:
                                                                              EdgeInsets.all(0),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.all(4),
                                                                            child:
                                                                                Text(
                                                                              myQueList[index]['options'][1],
                                                                              style: TextStyle(
                                                                                fontFamily: 'Nunito',
                                                                                fontSize: 16,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  setState(() {
                                                                    if (_curMarked ==
                                                                        '${myQueList[index]['options'][1]}') {
                                                                      _curMarked =
                                                                          null;
                                                                      _queAttempted--;

                                                                      _testAttempt
                                                                          .firstWhere((element) => element.containsKey(
                                                                              '${myQueList[index]['queId']}'))
                                                                          .remove(
                                                                              '${myQueList[index]['queId']}');
                                                                    } else {
                                                                      _curMarked =
                                                                          '${myQueList[index]['options'][1]}';

                                                                      if (_testAttempt
                                                                          .where((element) =>
                                                                              element.containsKey('${myQueList[index]['queId']}'))
                                                                          .isEmpty) {
                                                                        _queAttempted++;

                                                                        _testAttempt
                                                                            .add({
                                                                          '${myQueList[index]['queId']}':
                                                                              '${myQueList[index]['options'][1]}'
                                                                        });
                                                                      } else {
                                                                        _testAttempt.firstWhere((element) => element.containsKey('${myQueList[index]['queId']}')).update(
                                                                            '${myQueList[index]['queId']}',
                                                                            (value) =>
                                                                                '${myQueList[index]['options'][1]}');
                                                                      }
                                                                    }
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Container(
                                                              child: InkWell(
                                                                child: Card(
                                                                  color: Colors
                                                                      .transparent,
                                                                  margin:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0),
                                                                  child: Row(
                                                                    children: [
                                                                      /*Expanded(
                                                                    child: Card(
                                                                      color: _curMarked ==
                                                                              'op3'
                                                                          ? Colors
                                                                              .blue
                                                                          : Colors
                                                                              .white,
                                                                      margin: EdgeInsets
                                                                          .all(
                                                                              0),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(4.0),
                                                                        child:
                                                                            Text(
                                                                          'c) ${myQueList[index]['options'][2]}',
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                'Nunito',
                                                                            fontSize:
                                                                                16,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),*/
                                                                      Card(
                                                                        color: _curMarked ==
                                                                                '${myQueList[index]['options'][2]}'
                                                                            ? Colors.blue
                                                                            : Colors.white,
                                                                        margin:
                                                                            EdgeInsets.all(0),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(4.0),
                                                                          child:
                                                                              Text(
                                                                            'c)',
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: 'Nunito',
                                                                              fontSize: 16,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Card(
                                                                        color: Colors
                                                                            .transparent,
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Card(
                                                                          color: _curMarked == '${myQueList[index]['options'][2]}'
                                                                              ? Colors.blue
                                                                              : Colors.white,
                                                                          margin:
                                                                              EdgeInsets.all(0),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.all(4),
                                                                            child:
                                                                                Text(
                                                                              myQueList[index]['options'][2],
                                                                              style: TextStyle(
                                                                                fontFamily: 'Nunito',
                                                                                fontSize: 16,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  setState(() {
                                                                    if (_curMarked ==
                                                                        '${myQueList[index]['options'][2]}') {
                                                                      _curMarked =
                                                                          null;
                                                                      _queAttempted--;

                                                                      _testAttempt
                                                                          .firstWhere((element) => element.containsKey(
                                                                              '${myQueList[index]['queId']}'))
                                                                          .remove(
                                                                              '${myQueList[index]['queId']}');
                                                                    } else {
                                                                      _curMarked =
                                                                          '${myQueList[index]['options'][2]}';

                                                                      if (_testAttempt
                                                                          .where((element) =>
                                                                              element.containsKey('${myQueList[index]['queId']}'))
                                                                          .isEmpty) {
                                                                        _queAttempted++;

                                                                        _testAttempt
                                                                            .add({
                                                                          '${myQueList[index]['queId']}':
                                                                              '${myQueList[index]['options'][2]}'
                                                                        });
                                                                      } else {
                                                                        _testAttempt.firstWhere((element) => element.containsKey('${myQueList[index]['queId']}')).update(
                                                                            '${myQueList[index]['queId']}',
                                                                            (value) =>
                                                                                '${myQueList[index]['options'][2]}');
                                                                      }
                                                                    }
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Container(
                                                              child: InkWell(
                                                                child: Card(
                                                                  color: Colors
                                                                      .transparent,
                                                                  margin:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0),
                                                                  child: Row(
                                                                    children: [
                                                                      Card(
                                                                        color: _curMarked ==
                                                                                '${myQueList[index]['options'][3]}'
                                                                            ? Colors.blue
                                                                            : Colors.white,
                                                                        margin:
                                                                            EdgeInsets.all(0),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(4.0),
                                                                          child:
                                                                              Text(
                                                                            'd)',
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: 'Nunito',
                                                                              fontSize: 16,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Card(
                                                                        color: Colors
                                                                            .transparent,
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Card(
                                                                          color: _curMarked == '${myQueList[index]['options'][3]}'
                                                                              ? Colors.blue
                                                                              : Colors.white,
                                                                          margin:
                                                                              EdgeInsets.all(0),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.all(4),
                                                                            child:
                                                                                Text(
                                                                              myQueList[index]['options'][3],
                                                                              style: TextStyle(
                                                                                fontFamily: 'Nunito',
                                                                                fontSize: 16,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  setState(() {
                                                                    if (_curMarked ==
                                                                        '${myQueList[index]['options'][3]}') {
                                                                      _curMarked =
                                                                          null;
                                                                      _queAttempted--;

                                                                      _testAttempt
                                                                          .firstWhere((element) => element.containsKey(
                                                                              '${myQueList[index]['queId']}'))
                                                                          .remove(
                                                                              '${myQueList[index]['queId']}');
                                                                    } else {
                                                                      _curMarked =
                                                                          '${myQueList[index]['options'][3]}';

                                                                      if (_testAttempt
                                                                          .where((element) =>
                                                                              element.containsKey('${myQueList[index]['queId']}'))
                                                                          .isEmpty) {
                                                                        _queAttempted++;

                                                                        _testAttempt
                                                                            .add({
                                                                          '${myQueList[index]['queId']}':
                                                                              '${myQueList[index]['options'][3]}'
                                                                        });
                                                                      } else {
                                                                        _testAttempt.firstWhere((element) => element.containsKey('${myQueList[index]['queId']}')).update(
                                                                            '${myQueList[index]['queId']}',
                                                                            (value) =>
                                                                                '${myQueList[index]['options'][3]}');
                                                                      }
                                                                    }
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )))),
                                  Container(
                                    height: size.height * 0.1,
                                    child: Row(
                                      children: [
                                        Card(
                                          margin: const EdgeInsets.all(0),
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            width: size.width * 0.2,
                                            child: InkWell(
                                                child: Icon(
                                                  Icons.arrow_back,
                                                  size: 42,
                                                ),
                                                onTap: () {
                                                  if (!_presentSubmitDialog) {
                                                    if (index > 0) {
                                                      setState(() {
                                                        index = index - 1;

                                                        _markedForReview = _reviewList
                                                                .isEmpty
                                                            ? false
                                                            : (_reviewList
                                                                    .where((element) =>
                                                                        element.containsKey(
                                                                            '${myQueList[index]['queId']}'))
                                                                    .isEmpty
                                                                ? false
                                                                : true);
                                                        _curMarked = _testAttempt
                                                                .where((element) =>
                                                                    element.containsKey(
                                                                        '${myQueList[index]['queId']}'))
                                                                .isEmpty
                                                            ? null
                                                            : _testAttempt
                                                                .firstWhere((element) =>
                                                                    element.containsKey(
                                                                        '${myQueList[index]['queId']}'))
                                                                .entries
                                                                .first
                                                                .value
                                                                .toString();
                                                        /*.entries
                                                            .toList()
                                                            .elementAt(0)
                                                            .value;*/
                                                        debugPrint(
                                                            '${_testAttempt} *******************back button****************');
                                                      });
                                                    } else {
                                                      showToast(
                                                        'This is the first question.',
                                                        position: ToastPosition
                                                            .bottom,
                                                        backgroundColor:
                                                            Colors.white,
                                                        radius: 5.0,
                                                        textStyle: TextStyle(
                                                          fontSize: 16.0,
                                                          color: Colors.black,
                                                          fontFamily: 'Nunito',
                                                        ),
                                                      );
                                                    }
                                                  } else {
                                                    showToast(
                                                        ' Action not allowed. ',
                                                        textStyle: TextStyle(
                                                            fontFamily:
                                                                'Nunito'),
                                                        position: ToastPosition
                                                            .bottom);
                                                  }
                                                }),
                                          ),
                                        ),
                                        Expanded(
                                            child: Column(
                                          children: [
                                            /*Divider(
                              height: 1,
                              thickness: 2,
                            ),*/
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: Text(
                                                    'Quick Navigation Buttons',
                                                    style: TextStyle(
                                                        fontFamily: 'Nunito'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            /* Divider(
                              height: 1,
                              thickness: 1,
                            ),*/
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                SizedBox(width: 2.0),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 1.0,
                                                          bottom: 1.0),
                                                  child: Card(
                                                    margin:
                                                        const EdgeInsets.all(0),
                                                    child: Container(
                                                      // height: MediaQuery.of(context).size.height,
                                                      height:
                                                          size.height * 0.065,
                                                      width: size.width * 0.16,
                                                      child: Center(
                                                        child: InkWell(
                                                            child: Text(
                                                              'first',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  // fontWeight: FontWeight.bold,
                                                                  fontSize: 22),
                                                            ),
                                                            onTap: () {
                                                              setState(() {
                                                                if (!_presentSubmitDialog) {
                                                                  index = 0;
                                                                  _curMarked = _testAttempt
                                                                          .where((element) => element.containsKey(
                                                                              '${myQueList[index]['queId']}'))
                                                                          .isEmpty
                                                                      ? null
                                                                      : _testAttempt
                                                                          .firstWhere((element) =>
                                                                              element.containsKey('${myQueList[index]['queId']}'))
                                                                          .entries
                                                                          .first
                                                                          .value
                                                                          .toString();
                                                                } else {
                                                                  showToast(
                                                                      ' Action not allowed. ',
                                                                      textStyle: TextStyle(
                                                                          fontFamily:
                                                                              'Nunito'),
                                                                      position:
                                                                          ToastPosition
                                                                              .bottom);
                                                                }
                                                              });
                                                            }),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 2.0,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 1.0,
                                                          bottom: 1.0),
                                                  child: Card(
                                                    margin:
                                                        const EdgeInsets.all(0),
                                                    child: Container(
                                                      //height: MediaQuery.of(context).size.height,
                                                      height:
                                                          size.height * 0.065,
                                                      width: size.width * 0.18,
                                                      child: Center(
                                                        child: InkWell(
                                                            child: Text(
                                                              ((myQueList.length ~/
                                                                              2)
                                                                          .floor()
                                                                          .toString()) ==
                                                                      '1'
                                                                  ? '1st'
                                                                  : (((myQueList.length ~/ 2)
                                                                              .floor()
                                                                              .toString()) ==
                                                                          '2'
                                                                      ? '2nd'
                                                                      : (((myQueList.length ~/ 2).floor().toString()) ==
                                                                              '3'
                                                                          ? '3rd'
                                                                          : (((myQueList.length ~/ 2).floor().toString()) +
                                                                              'th'))),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  // fontWeight: FontWeight.bold,
                                                                  fontSize: 22),
                                                            ),
                                                            onTap: () {
                                                              setState(() {
                                                                if (!_presentSubmitDialog) {
                                                                  index = (myQueList.length ~/
                                                                              2)
                                                                          .floor() -
                                                                      1;
                                                                  _curMarked = _testAttempt
                                                                          .where((element) => element.containsKey(
                                                                              '${myQueList[index]['queId']}'))
                                                                          .isEmpty
                                                                      ? null
                                                                      : _testAttempt
                                                                          .firstWhere((element) =>
                                                                              element.containsKey('${myQueList[index]['queId']}'))
                                                                          .entries
                                                                          .first
                                                                          .value
                                                                          .toString();
                                                                } else {
                                                                  showToast(
                                                                      ' Action not allowed. ',
                                                                      textStyle: TextStyle(
                                                                          fontFamily:
                                                                              'Nunito'),
                                                                      position:
                                                                          ToastPosition
                                                                              .bottom);
                                                                }
                                                              });
                                                            }),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 2.0),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 1.0,
                                                          bottom: 1.0),
                                                  child: Card(
                                                    margin:
                                                        const EdgeInsets.all(0),
                                                    child: Container(
                                                      // height: MediaQuery.of(context).size.height,
                                                      height:
                                                          size.height * 0.065,
                                                      width: size.width * 0.18,
                                                      child: Center(
                                                        child: InkWell(
                                                            child: Text(
                                                              'last',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  // fontWeight: FontWeight.bold,
                                                                  fontSize: 22),
                                                            ),
                                                            onTap: () {
                                                              setState(() {
                                                                if (!_presentSubmitDialog) {
                                                                  index = (myQueList
                                                                              .length)
                                                                          .toInt() -
                                                                      1;
                                                                  _curMarked = _testAttempt
                                                                          .where((element) => element.containsKey(
                                                                              '${myQueList[index]['queId']}'))
                                                                          .isEmpty
                                                                      ? null
                                                                      : _testAttempt
                                                                          .firstWhere((element) =>
                                                                              element.containsKey('${myQueList[index]['queId']}'))
                                                                          .entries
                                                                          .first
                                                                          .value
                                                                          .toString();
                                                                } else {
                                                                  showToast(
                                                                      ' Action not allowed. ',
                                                                      textStyle: TextStyle(
                                                                          fontFamily:
                                                                              'Nunito'),
                                                                      position:
                                                                          ToastPosition
                                                                              .bottom);
                                                                }
                                                              });
                                                            }),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 2.0),
                                              ],
                                            ),
                                          ],
                                        )),
                                        Card(
                                          margin: const EdgeInsets.all(0),
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            width: size.width * 0.2,
                                            child: InkWell(
                                              child: Icon(
                                                Icons.arrow_forward,
                                                size: 42,
                                              ),
                                              onTap: () {
                                                if (!_presentSubmitDialog) {
                                                  if (index <
                                                      myQueList.length - 1) {
                                                    setState(() {
                                                      index = index + 1;

                                                      _markedForReview = _reviewList
                                                              .isEmpty
                                                          ? false
                                                          : (_reviewList
                                                                  .where((element) =>
                                                                      element.containsKey(
                                                                          '${myQueList[index]['queId']}'))
                                                                  .isEmpty
                                                              ? false
                                                              : true);
                                                      _curMarked = _testAttempt
                                                              .where((element) =>
                                                                  element.containsKey(
                                                                      '${myQueList[index]['queId']}'))
                                                              .isEmpty
                                                          ? null
                                                          : _testAttempt
                                                              .firstWhere((element) =>
                                                                  element.containsKey(
                                                                      '${myQueList[index]['queId']}'))
                                                              .entries
                                                              .toList()
                                                              .elementAt(0)
                                                              .value;
                                                      debugPrint(
                                                          '${_testAttempt} *******************next button****************');
                                                    });
                                                  } else {
                                                    showToast(
                                                      'This is the last question.',
                                                      position:
                                                          ToastPosition.bottom,
                                                      backgroundColor:
                                                          Colors.white,
                                                      radius: 5.0,
                                                      textStyle: TextStyle(
                                                          fontSize: 16.0,
                                                          color: Colors.black,
                                                          fontFamily: 'Nunito'),
                                                    );
                                                  }
                                                } else {
                                                  showToast(
                                                      ' Action not allowed. ',
                                                      textStyle: TextStyle(
                                                          fontFamily: 'Nunito'),
                                                      position:
                                                          ToastPosition.bottom);
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ]);
                    } else {
                      return LoadingWidget();
                    }
                  }),
        ),
      ),
    );
  }
}
