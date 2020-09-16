import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_proc/widgets/result_widget.dart';
import 'package:oktoast/oktoast.dart';

import '../widgets/que_list_widget.dart';
import '../widgets/my_list_widget.dart';
import '../widgets/alert_dialoge_time_finish.dart';
import '../widgets/result_widget.dart';

import '../models/my_que_list.dart';
import '../my_arguments/test_arguments.dart';

class MyQuizWidget extends StatefulWidget {
  final int _hours;
  final int _minutes;
  final int _seconds;
  MyQuizWidget(this._hours, this._minutes, this._seconds);
  @override
  _MyQuizWidgetState createState() => _MyQuizWidgetState();
}

class _MyQuizWidgetState extends State<MyQuizWidget> {
  //Color _reviewIconColor = Colors.grey;
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

  MyQueList myQueList = new MyQueList();
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
          submitByTime(context);
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

  void submitByTime(BuildContext context) {
    String msg = 'Your test has been submitted successfully.';
    showAlertDialog(context, msg);
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
        child: IndexedStack(index: _curIndex, children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  child: Text('Start'),
                  onPressed: () {
                    setState(() {
                      _curIndex = 1;
                      startTimer1(context);
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).pop();
                    });
                  },
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
                height: size.height * 0.1,
                child: Row(
                  children: [
                    Card(
                      margin: const EdgeInsets.all(0),
                      child: Container(
                        height: MediaQuery.of(context).size.height,
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
                              _markedForReview = !_markedForReview;

                              if (_reviewList
                                  .where((element) => element.containsKey(
                                      '${myQueList.queList[index].queId}'))
                                  .isEmpty) {
                                _queMarkedForReview++;
                                debugPrint(
                                    '$_queMarkedForReview ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;');
                                _reviewList.add({
                                  '${myQueList.queList[index].queId}': true
                                });
                                debugPrint(
                                    '$_reviewList !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
                              } else {
                                _queMarkedForReview--;
                                debugPrint(
                                    '$_queMarkedForReview ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;');
                                _reviewList
                                    .firstWhere((element) => element.containsKey(
                                        '${myQueList.queList[index].queId}'))
                                    .remove(
                                        '${myQueList.queList[index].queId}');
                                debugPrint(
                                    '$_reviewList !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              ((_start1) / 3600) < 10
                                  ? '0' + '${((_start1) / 3600).floor()}' + ':'
                                  : '${((_start1) / 3600).floor()}' + ':',
                              style:
                                  TextStyle(fontFamily: 'Nunito', fontSize: 42),
                            ),
                            Text(
                              ((((_start1) % 3600) / 60).floor()) < 10
                                  ? '0' +
                                      '${(((_start1) % 3600) / 60).floor()}' +
                                      ':'
                                  : '${(((_start1) % 3600) / 60).floor()}' +
                                      ':',
                              style:
                                  TextStyle(fontFamily: 'Nunito', fontSize: 42),
                            ),
                            Text(
                              (((_start1) % 3600) % 60).floor() < 10
                                  ? ((_start1) == 0
                                      ? '00'
                                      : '0' +
                                          '${(((_start1) % 3600) % 60).floor()}')
                                  : '${(((_start1) % 3600) % 60).floor()}',
                              style:
                                  TextStyle(fontFamily: 'Nunito', fontSize: 42),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.all(0),
                      child: Container(
                        height: MediaQuery.of(context).size.height,
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
                  child: _presentSubmitDialog
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Center(
                                child: Card(
                                  color: Colors.redAccent,
                                  elevation: 20,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Container(
                                    width: size.width * 0.8,
                                    height: size.height * 0.3,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Alert!',
                                              style: TextStyle(
                                                fontFamily: 'Nunito',
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
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
                                                  'Do you really want to submit your test?',
                                                  style: TextStyle(
                                                    fontFamily: 'Nunito',
                                                    fontSize: 18,
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
                                              MainAxisAlignment.end,
                                          children: [
                                            RaisedButton(
                                              color: Colors.yellow,
                                              child: Text('Yes'),
                                              onPressed: () {
                                                setState(() {
                                                  _tmpBool = true;
                                                  TestArguments testArguments =
                                                      new TestArguments(
                                                          _testAttempt,
                                                          _reviewList,
                                                          myQueList
                                                              .queList.length);
                                                  Navigator.of(context)
                                                      .pushReplacementNamed(
                                                    '/ResultWidget',
                                                    arguments: testArguments,
                                                  );
                                                });
                                              },
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            RaisedButton(
                                              child: Text('Cancel'),
                                              onPressed: () {
                                                setState(() {
                                                  _tmpBoolCancel = true;
                                                  _presentSubmitDialog = false;
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          child: GestureDetector(
                            onHorizontalDragStart: (details) {
                              if (details.localPosition.direction.isNegative) {
                                setState(() {
                                  if (index > 0) {
                                    index--;
                                  }
                                });
                              } else if (!details
                                  .localPosition.direction.isFinite) {
                                setState(() {
                                  if (index < myQueList.queList.length) {
                                    index++;
                                  }
                                });
                              }
                            },
                            child: Card(
                              shadowColor: Colors.black45,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              color: Colors.transparent,
                              child: SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 15,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${index + 1} / ${myQueList.queList.length}',
                                            style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Colors.white.withOpacity(0.9),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              'Q.) ' +
                                                  myQueList.queList[index].que,
                                              style: TextStyle(
                                                fontFamily: 'Nunito',
                                                fontSize: 22,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      Container(
                                        child: InkWell(
                                          child: Card(
                                            color: Colors.transparent,
                                            margin: EdgeInsets.all(0),
                                            child: Row(
                                              children: [
                                                Card(
                                                  margin: EdgeInsets.all(0),
                                                  color: _curMarked == 'op1'
                                                      ? Colors.blue
                                                      : Colors.white,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Text(
                                                      'a)',
                                                      style: TextStyle(
                                                        fontFamily: 'Nunito',
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Card(
                                                  color: Colors.transparent,
                                                ),
                                                Expanded(
                                                  child: Card(
                                                    color: _curMarked == 'op1'
                                                        ? Colors.blue
                                                        : Colors.white,
                                                    margin: EdgeInsets.all(0),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(4),
                                                      child: Text(
                                                        myQueList
                                                            .queList[index].op1,
                                                        style: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 20,
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
                                              if (_curMarked == 'op1') {
                                                _curMarked = null;
                                                _queAttempted--;

                                                _testAttempt
                                                    .firstWhere((element) =>
                                                        element.containsKey(
                                                            '${myQueList.queList[index].queId}'))
                                                    .remove(
                                                        '${myQueList.queList[index].queId}');
                                              } else {
                                                _curMarked = 'op1';

                                                if (_testAttempt
                                                    .where((element) =>
                                                        element.containsKey(
                                                            '${myQueList.queList[index].queId}'))
                                                    .isEmpty) {
                                                  _queAttempted++;

                                                  _testAttempt.add({
                                                    '${myQueList.queList[index].queId}':
                                                        'op1'
                                                  });
                                                } else {
                                                  _testAttempt
                                                      .firstWhere((element) =>
                                                          element.containsKey(
                                                              '${myQueList.queList[index].queId}'))
                                                      .update(
                                                          '${myQueList.queList[index].queId}',
                                                          (value) => 'op1');
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
                                            color: Colors.transparent,
                                            margin: EdgeInsets.all(0),
                                            child: Row(
                                              children: [
                                                Card(
                                                  color: _curMarked == 'op2'
                                                      ? Colors.blue
                                                      : Colors.white,
                                                  margin: EdgeInsets.all(0),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Text(
                                                      'b)',
                                                      style: TextStyle(
                                                        fontFamily: 'Nunito',
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Card(
                                                  color: Colors.transparent,
                                                ),
                                                Expanded(
                                                  child: Card(
                                                    color: _curMarked == 'op2'
                                                        ? Colors.blue
                                                        : Colors.white,
                                                    margin: EdgeInsets.all(0),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(4),
                                                      child: Text(
                                                        myQueList
                                                            .queList[index].op2,
                                                        style: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 20,
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
                                              if (_curMarked == 'op2') {
                                                _curMarked = null;
                                                _queAttempted--;

                                                _testAttempt
                                                    .firstWhere((element) =>
                                                        element.containsKey(
                                                            '${myQueList.queList[index].queId}'))
                                                    .remove(
                                                        '${myQueList.queList[index].queId}');
                                              } else {
                                                _curMarked = 'op2';

                                                if (_testAttempt
                                                    .where((element) =>
                                                        element.containsKey(
                                                            '${myQueList.queList[index].queId}'))
                                                    .isEmpty) {
                                                  _queAttempted++;

                                                  _testAttempt.add({
                                                    '${myQueList.queList[index].queId}':
                                                        'op2'
                                                  });
                                                } else {
                                                  _testAttempt
                                                      .firstWhere((element) =>
                                                          element.containsKey(
                                                              '${myQueList.queList[index].queId}'))
                                                      .update(
                                                          '${myQueList.queList[index].queId}',
                                                          (value) => 'op2');
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
                                            color: Colors.transparent,
                                            margin: EdgeInsets.all(0),
                                            child: Row(
                                              children: [
                                                Card(
                                                  color: _curMarked == 'op3'
                                                      ? Colors.blue
                                                      : Colors.white,
                                                  margin: EdgeInsets.all(0),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Text(
                                                      'c)',
                                                      style: TextStyle(
                                                        fontFamily: 'Nunito',
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Card(
                                                  color: Colors.transparent,
                                                ),
                                                Expanded(
                                                  child: Card(
                                                    color: _curMarked == 'op3'
                                                        ? Colors.blue
                                                        : Colors.white,
                                                    margin: EdgeInsets.all(0),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(4),
                                                      child: Text(
                                                        myQueList
                                                            .queList[index].op3,
                                                        style: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 20,
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
                                              if (_curMarked == 'op3') {
                                                _curMarked = null;
                                                _queAttempted--;

                                                _testAttempt
                                                    .firstWhere((element) =>
                                                        element.containsKey(
                                                            '${myQueList.queList[index].queId}'))
                                                    .remove(
                                                        '${myQueList.queList[index].queId}');
                                              } else {
                                                _curMarked = 'op3';

                                                if (_testAttempt
                                                    .where((element) =>
                                                        element.containsKey(
                                                            '${myQueList.queList[index].queId}'))
                                                    .isEmpty) {
                                                  _queAttempted++;

                                                  _testAttempt.add({
                                                    '${myQueList.queList[index].queId}':
                                                        'op3'
                                                  });
                                                } else {
                                                  _testAttempt
                                                      .firstWhere((element) =>
                                                          element.containsKey(
                                                              '${myQueList.queList[index].queId}'))
                                                      .update(
                                                          '${myQueList.queList[index].queId}',
                                                          (value) => 'op3');
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
                                            color: Colors.transparent,
                                            margin: EdgeInsets.all(0),
                                            child: Row(
                                              children: [
                                                Card(
                                                  color: _curMarked == 'op4'
                                                      ? Colors.blue
                                                      : Colors.white,
                                                  margin: EdgeInsets.all(0),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Text(
                                                      'd)',
                                                      style: TextStyle(
                                                        fontFamily: 'Nunito',
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Card(
                                                  color: Colors.transparent,
                                                ),
                                                Expanded(
                                                  child: Card(
                                                    color: _curMarked == 'op4'
                                                        ? Colors.blue
                                                        : Colors.white,
                                                    margin: EdgeInsets.all(0),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(4),
                                                      child: Text(
                                                        myQueList
                                                            .queList[index].op4,
                                                        style: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 20,
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
                                              if (_curMarked == 'op4') {
                                                _curMarked = null;
                                                _queAttempted--;

                                                _testAttempt
                                                    .firstWhere((element) =>
                                                        element.containsKey(
                                                            '${myQueList.queList[index].queId}'))
                                                    .remove(
                                                        '${myQueList.queList[index].queId}');
                                              } else {
                                                _curMarked = 'op4';

                                                if (_testAttempt
                                                    .where((element) =>
                                                        element.containsKey(
                                                            '${myQueList.queList[index].queId}'))
                                                    .isEmpty) {
                                                  _queAttempted++;

                                                  _testAttempt.add({
                                                    '${myQueList.queList[index].queId}':
                                                        'op4'
                                                  });
                                                } else {
                                                  _testAttempt
                                                      .firstWhere((element) =>
                                                          element.containsKey(
                                                              '${myQueList.queList[index].queId}'))
                                                      .update(
                                                          '${myQueList.queList[index].queId}',
                                                          (value) => 'op4');
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
                            ),
                          ),
                        )),
              Container(
                height: size.height * 0.1,
                child: Row(
                  children: [
                    Card(
                      margin: const EdgeInsets.all(0),
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: size.width * 0.2,
                        child: InkWell(
                          child: Icon(
                            Icons.arrow_back,
                            size: 42,
                          ),
                          onTap: () {
                            if (index > 0) {
                              setState(() {
                                index = index - 1;
                                _markedForReview = _reviewList.isEmpty
                                    ? false
                                    : (_reviewList
                                            .where((element) => element.containsKey(
                                                '${myQueList.queList[index].queId}'))
                                            .isEmpty
                                        ? false
                                        : true);
                                _curMarked = _testAttempt
                                        .where((element) => element.containsKey(
                                            '${myQueList.queList[index].queId}'))
                                        .isEmpty
                                    ? null
                                    : _testAttempt
                                        .firstWhere((element) =>
                                            element.containsKey(
                                                '${myQueList.queList[index].queId}'))
                                        .entries
                                        .toList()
                                        .elementAt(0)
                                        .value;
                              });
                            } else {
                              showToast(
                                'This is the first question.',
                                position: ToastPosition.bottom,
                                backgroundColor: Colors.white,
                                radius: 5.0,
                                textStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontFamily: 'Nunito',
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Card(
                      margin: const EdgeInsets.all(0),
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: size.width * 0.2,
                        child: InkWell(
                          child: Icon(
                            Icons.arrow_forward,
                            size: 42,
                          ),
                          onTap: () {
                            if (index < myQueList.queList.length - 1) {
                              setState(() {
                                index = index + 1;
                                _markedForReview = _reviewList.isEmpty
                                    ? false
                                    : (_reviewList
                                            .where((element) => element.containsKey(
                                                '${myQueList.queList[index].queId}'))
                                            .isEmpty
                                        ? false
                                        : true);
                                _curMarked = _testAttempt
                                        .where((element) => element.containsKey(
                                            '${myQueList.queList[index].queId}'))
                                        .isEmpty
                                    ? null
                                    : _testAttempt
                                        .firstWhere((element) =>
                                            element.containsKey(
                                                '${myQueList.queList[index].queId}'))
                                        .entries
                                        .toList()
                                        .elementAt(0)
                                        .value;
                              });
                            } else {
                              showToast(
                                'This is the last question.',
                                position: ToastPosition.bottom,
                                backgroundColor: Colors.white,
                                radius: 5.0,
                                textStyle: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                    fontFamily: 'Nunito'),
                              );
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
        ]),
      ),
    );
  }
}
