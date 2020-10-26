import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

//-------------------- my packages ------------------------
import '../my_arguments/test_arguments.dart';
import '../my_arguments/arguments_to_review_questions.dart';
import '../models/chartData _1.dart';
//import '../models/my_que_list.dart';
import '../models/chartData_2.dart';
import '../models/set_up_model.dart';
import '../data/test_statistics_data.dart';
import '../widgets/alert_dialoge_reappear.dart';
import '../services/firestoreService.dart';
import '../widgets/loadingWidget.dart';
import '../models/colorCodeModel.dart';
import '../models/colorCodeNotifier.dart';

class ResultWidget extends StatefulWidget {
  @override
  _ResultWidgetState createState() => _ResultWidgetState();
}

class _ResultWidgetState extends State<ResultWidget> {
  TestStatisticsData testStatisticsData = new TestStatisticsData();
  String _chartTitle = 'Breakdown';
  bool _isShowingToppers = false;
  bool _dataLoaded = false;

  /* List<Map<String, int>> calcResult(
      List<Map<String, String>> testAttempt1, int totalQue1) {
    List<Map<String, String>> testAttempt = testAttempt1;
    int totalQue = totalQue1;
    List<Map<String, int>> response = [];
    int correct = 0;
    int wrong = 0;
    int nonAttempted = 0;
    MyQueList myQueList = new MyQueList();

    for (int i = 0; i < testAttempt.length; i++) {
      testAttempt[i].forEach((key, value) {
        if (myQueList.queList
            .where((element) => element.queId == key)
            .isNotEmpty) {
          if ((myQueList.queList
                  .firstWhere((element) => element.queId == key)
                  .ans ==
              testAttempt[i][key])) {
            correct++;
          } else {
            wrong++;
          }
        }
      });
    }
    nonAttempted = totalQue - (correct + wrong);
    response.add({'correct': correct});
    response.add({'wrong': wrong});
    response.add({'nonAttempted': nonAttempted});
    return response;
  }*/

  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    EdgeInsets pdTop = MediaQuery.of(context).padding;
    RouteSettings settings = ModalRoute.of(context).settings;
    TestArguments testArguments = settings.arguments;
    String _testName = testArguments.testName;
    List<Map<String, String>> _testAttempt = testArguments.testAttempt;
    List<Map<String, bool>> _reviewList = testArguments.reviewList;
    int _queAttempted = testArguments.queAttempted;
    // int _totalQue = testArguments.totalQue;
    // List<Map<String, int>> result = calcResult(_testAttempt, _totalQue);
    FirestoreService _fService = new FirestoreService();
    SetUpModel _setUpModel = Provider.of<SetUpModel>(context);
    final _user = Provider.of<User>(context);
    ColorCodeNotifier _colorCodeNotifier =
        Provider.of<ColorCodeNotifier>(context);
    ColorCodeModel localColorCode = _colorCodeNotifier.getColorCode();
    List<ChartData1> chartData = [
      /* ChartData1('Correct', result[0]['correct'], Colors.green[400]),
      ChartData1('Wrong', result[1]['wrong'], Colors.redAccent),
      ChartData1(
          'Not Attempted', result[2]['nonAttempted'], Colors.blueGrey.shade300),*/
    ];

    List<ChartData2> chartData2 = [
      /* ChartData2(
        'Topper\'s Score',
        testStatisticsData.testList[0].toppersMarks,
        Colors.redAccent,
      ),
      ChartData2(
        'Your Score',
        result[0]['correct'],
        Colors.green,
      ),
      ChartData2(
        'Average Score',
        testStatisticsData.testList[0].avgMarks,
        Colors.blue,
      ),*/
    ];

    return Scaffold(
      body: Container(
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
        child: FutureBuilder(
          future: !_dataLoaded
              ? _fService.calcResult(_user.uid, _setUpModel.curSub, _testName,
                  _testAttempt, _queAttempted)
              : null,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (chartData.isEmpty) {
                chartData.add(ChartData1(
                    'Correct', snapshot.data['correct'], Colors.green[400]));
                chartData.add(ChartData1(
                    'Wrong', snapshot.data['wrong'], Colors.redAccent));
                chartData.add(ChartData1('Not Attempted',
                    snapshot.data['nonAttempted'], Colors.blueGrey.shade300));
              }
              if (chartData2.isEmpty) {
                chartData2.add(ChartData2(
                  'Topper\'s Score',
                  snapshot.data['topperScore'],
                  Colors.redAccent,
                ));
                chartData2.add(ChartData2(
                  'Your Score',
                  snapshot.data['correct'],
                  Colors.green,
                ));
                chartData2.add(ChartData2(
                  'Average Score',
                  snapshot.data['averageScore'],
                  Colors.blue,
                ));
              }

              return Column(
                children: [
                  SizedBox(
                    height: pdTop.top + 10,
                  ),
                  Container(
                    height: size.height * 0.085,
                    child: Card(
                      color: localColorCode.cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          InkWell(
                            child: Icon(Icons.arrow_back_ios,
                                size: 32, color: localColorCode.textColor1),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Test Result',
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 32,
                                color: localColorCode.textColor1
                                // fontWeight: FontWeight.bold,
                                ),
                          ),
                          Expanded(
                            child: SizedBox(),
                          ),
                          /* InkWell(
                        child: Icon(
                          Icons.more_vert,
                          size: 32,
                        ),
                        onTap: () {},
                      ),*/
                          PopupMenuButton(
                            icon: Icon(
                              Icons.more_vert,
                              color: localColorCode.textColor1,
                            ),
                            // initialValue: 0,
                            onSelected: (value) {
                              if (value == 0) {
                                ArgumentsToReviewQuestions
                                    argumentsToReviewQuestions =
                                    new ArgumentsToReviewQuestions(_reviewList);
                                Navigator.of(context).pushNamed(
                                    '/ReviewQuestionsWidget',
                                    arguments: argumentsToReviewQuestions);
                              } else if (value == 1) {
                                String msg =
                                    'Do you really want to reappear for this test?';
                                showAlertDialogReappear(
                                    context,
                                    msg,
                                    testArguments.testName,
                                    testArguments.hours,
                                    testArguments.minutes,
                                    testArguments.seconds);
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem(
                                  value: 0,
                                  child: Text('Review Questions'),
                                ),
                                PopupMenuItem(
                                  value: 1,
                                  child: Text('Reappear'),
                                ),
                              ];
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        height: size.height * 0.85,
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                        child: Stack(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              color: localColorCode.cardColor,
                              child: PageView(
                                controller: _controller,
                                onPageChanged: (value) {
                                  setState(() {
                                    _dataLoaded = true;
                                    if (value == 0) {
                                      _chartTitle = 'Breakdown';
                                    } else if (value == 1) {
                                      _chartTitle = 'Relative';
                                      _isShowingToppers = false;
                                    } else if (value == 2) {
                                      _chartTitle = 'Toppers';
                                      _isShowingToppers = true;
                                    }
                                  });
                                },
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 70, bottom: 50),
                                    child: SfCircularChart(
                                      series: <CircularSeries>[
                                        DoughnutSeries<ChartData1, String>(
                                            dataSource: chartData,
                                            pointColorMapper:
                                                (ChartData1 data, _) =>
                                                    data.color,
                                            xValueMapper:
                                                (ChartData1 data, _) =>
                                                    data.name,
                                            yValueMapper:
                                                (ChartData1 data, _) =>
                                                    data.value,
                                            explode: true,
                                            explodeIndex: 0),
                                      ],
                                      legend: Legend(
                                        textStyle: TextStyle(
                                          fontFamily: 'Nunito',
                                          color: localColorCode.textColor1,
                                        ),
                                        isVisible: true,
                                        position: LegendPosition.bottom,
                                        overflowMode:
                                            LegendItemOverflowMode.wrap,
                                        title: LegendTitle(
                                            text: 'Overall Performance',
                                            textStyle: TextStyle(
                                                color: Colors.red,
                                                fontSize: 15,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.w900)),
                                      ),
                                      tooltipBehavior: TooltipBehavior(
                                        enable: true,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 70, bottom: 50),
                                    child: SfCartesianChart(
                                      /* title: ChartTitle(
                                    text: 'Relative',
                                    textStyle: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepOrangeAccent,
                                    ),
                                  ),*/
                                      primaryXAxis: CategoryAxis(
                                        title: AxisTitle(
                                            text: 'Scores',
                                            textStyle: TextStyle(
                                              fontFamily: 'Nunito',
                                              color: localColorCode.textColor1,
                                            )),
                                      ),
                                      primaryYAxis: NumericAxis(
                                        minimum: testStatisticsData
                                            .testList[0].minMarks,
                                        maximum: testStatisticsData
                                            .testList[0].maxMarks,
                                        title: AxisTitle(
                                            text: 'Marks',
                                            textStyle: TextStyle(
                                              fontFamily: 'Nunito',
                                              color: localColorCode.textColor1,
                                            )),
                                        interval: 1,
                                      ),
                                      series: <ChartSeries>[
                                        ColumnSeries<ChartData2, String>(
                                            name: 'Score',
                                            dataSource: chartData2,
                                            pointColorMapper:
                                                (ChartData2 data, _) =>
                                                    data.color,
                                            xValueMapper:
                                                (ChartData2 data, _) =>
                                                    data.name,
                                            yValueMapper:
                                                (ChartData2 data, _) =>
                                                    data.value,
                                            dataLabelSettings:
                                                DataLabelSettings(
                                              textStyle: TextStyle(
                                                fontFamily: 'Nunito',
                                                color:
                                                    localColorCode.textColor1,
                                              ),
                                              isVisible: true,
                                            )),
                                      ],
                                      /*  legend: Legend(
                                    isVisible: false,
                                    position: LegendPosition.bottom,
                                    overflowMode: LegendItemOverflowMode.wrap,
                                    title: LegendTitle(
                                        text: 'Relative Performance',
                                        textStyle: TextStyle(
                                            color: Colors.red,
                                            fontSize: 10,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w900)),
                                  ),*/
                                      tooltipBehavior: TooltipBehavior(
                                        enable: true,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 115,
                                      bottom: 10,
                                      left: 4,
                                      right: 4,
                                    ),
                                    child: ListView.builder(
                                        itemCount: snapshot.data['topperList']
                                            .length /*testStatisticsData
                                            .testList[0].topperList.length*/
                                        ,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            height: size.height * 0.1,
                                            child: Card(
                                              color: localColorCode
                                                  .topperListCardColor,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Center(
                                                      child: (index == 0 ||
                                                              index == 1 ||
                                                              index == 2)
                                                          ? Icon(
                                                              Entypo.medal,
                                                              color: index == 0
                                                                  ? Colors
                                                                      .yellow
                                                                  : (index == 1
                                                                      ? Colors.grey[
                                                                          350]
                                                                      : Colors.brown[
                                                                          400]),
                                                            )
                                                          : Text(
                                                              '${index + 1}',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Nunito',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: localColorCode
                                                                    .textColor1,
                                                              ),
                                                            ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 6,
                                                    child: Center(
                                                      child: Text(
                                                        // '${testStatisticsData.testList[0].topperList[index]['name']}',
                                                        '${snapshot.data['topperList'][index]['userId']}',
                                                        style: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          color: localColorCode
                                                              .textColor1,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Center(
                                                      child: Text(
                                                        //'${testStatisticsData.testList[0].topperList[index]['score']}',
                                                        '${snapshot.data['topperList'][index]['score']}',
                                                        style: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          color: localColorCode
                                                              .textColor1,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  /*Expanded(
                                                    flex: 3,
                                                    child: Center(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            ((testStatisticsData.testList[0].topperList[index]
                                                                            [
                                                                            'timeTaken']) /
                                                                        3600) <
                                                                    10
                                                                ? '0' +
                                                                    '${((testStatisticsData.testList[0].topperList[index]['timeTaken']) / 3600).floor()}' +
                                                                    ':'
                                                                : '${((testStatisticsData.testList[0].topperList[index]['timeTaken']) / 3600).floor()}' +
                                                                    ':',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Nunito',
                                                            ),
                                                          ),
                                                          Text(
                                                            ((((testStatisticsData.testList[0].topperList[index]['timeTaken']) %
                                                                                3600) /
                                                                            60)
                                                                        .floor()) <
                                                                    10
                                                                ? '0' +
                                                                    '${(((testStatisticsData.testList[0].topperList[index]['timeTaken']) % 3600) / 60).floor()}' +
                                                                    ':'
                                                                : '${(((testStatisticsData.testList[0].topperList[index]['timeTaken']) % 3600) / 60).floor()}' +
                                                                    ':',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Nunito',
                                                            ),
                                                          ),
                                                          Text(
                                                            (((testStatisticsData.testList[0].topperList[index]['timeTaken']) %
                                                                                3600) %
                                                                            60)
                                                                        .floor() <
                                                                    10
                                                                ? ((testStatisticsData.testList[0].topperList[index]
                                                                            [
                                                                            'timeTaken']) ==
                                                                        0
                                                                    ? '00'
                                                                    : '0' +
                                                                        '${(((testStatisticsData.testList[0].topperList[index]['timeTaken']) % 3600) % 60).floor()}')
                                                                : '${(((testStatisticsData.testList[0].topperList[index]['timeTaken']) % 3600) % 60).floor()}',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Nunito',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),*/
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 4.0, right: 4.0, top: 20, bottom: 0),
                              height: size.height * 0.85,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                      ),
                                      InkWell(
                                        child: Icon(
                                          Icons.arrow_back_ios,
                                          size: 32,
                                          color: localColorCode.textColor1,
                                        ),
                                        onTap: () {
                                          setState(() {
                                            _dataLoaded = true;
                                            /* _currentGraph = _currentGraph == 1
                                                  ? 0
                                                  : showToast(
                                                      'This is the first card.');*/
                                            /*   _controller.page = _controller.page == 1 ?  :showToast('This is the first page');
                                                      if(_controller.page == 1){
                                                        setState(() {
                                                          _controller.page = _controller.page - 1;
                                                        });
                                                      }*/

                                            if (_controller.page == 0) {
                                              showToast(
                                                'This is the first card.',
                                                textStyle: TextStyle(
                                                  fontFamily: 'Nunito',
                                                  color: localColorCode
                                                      .toastTextColor,
                                                ),
                                                position: ToastPosition.bottom,
                                                backgroundColor: localColorCode
                                                    .toastBackgroundColor,
                                              );
                                            } else if (_controller.page == 1) {
                                              _chartTitle = 'Breakdown';
                                              _controller.animateToPage(0,
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.ease);
                                            } else if (_controller.page == 2) {
                                              _chartTitle = 'Relative';
                                              _isShowingToppers = false;
                                              _controller.animateToPage(1,
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.ease);
                                            }
                                          });
                                        },
                                      ),
                                      Expanded(
                                          child:
                                              /*SizedBox(),*/ Center(
                                        child: Text(
                                          _chartTitle,
                                          style: TextStyle(
                                            fontFamily: 'Nunito',
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepOrangeAccent,
                                          ),
                                        ),
                                      )),
                                      InkWell(
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 32,
                                            color: localColorCode.textColor1,
                                          ),
                                          onTap: () {
                                            setState(
                                              () {
                                                _dataLoaded = true;
                                                if (_controller.page == 2) {
                                                  showToast(
                                                    'This is the last card.',
                                                    textStyle: TextStyle(
                                                      fontFamily: 'Nunito',
                                                      color: localColorCode
                                                          .toastTextColor,
                                                    ),
                                                    position:
                                                        ToastPosition.bottom,
                                                    backgroundColor:
                                                        localColorCode
                                                            .toastBackgroundColor,
                                                  );
                                                } else if (_controller.page ==
                                                    1) {
                                                  _chartTitle = 'Toppers';
                                                  _isShowingToppers = true;
                                                  _controller.animateToPage(2,
                                                      duration: Duration(
                                                          milliseconds: 500),
                                                      curve: Curves.ease);
                                                } else if (_controller.page ==
                                                    0) {
                                                  _chartTitle = 'Relative';
                                                  _isShowingToppers = false;
                                                  _controller.animateToPage(1,
                                                      duration: Duration(
                                                          milliseconds: 500),
                                                      curve: Curves.ease);
                                                }
                                              },
                                            );
                                          }),
                                      SizedBox(
                                        width: 20,
                                      ),
                                    ],
                                  ),
                                  _isShowingToppers
                                      ? Container(
                                          margin: EdgeInsets.only(top: 8.0),
                                          height: size.height * 0.085,
                                          child: Card(
                                            color: localColorCode
                                                .topperListCardColor,
                                            // elevation: 0,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Center(
                                                    child: Text(
                                                      'Rank',
                                                      style: TextStyle(
                                                        fontFamily: 'Nunito',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: localColorCode
                                                            .textColor1,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 6,
                                                  child: Center(
                                                    child: Text(
                                                      'Name',
                                                      style: TextStyle(
                                                        fontFamily: 'Nunito',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: localColorCode
                                                            .textColor1,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Center(
                                                    child: Text(
                                                      'Score',
                                                      style: TextStyle(
                                                        fontFamily: 'Nunito',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: localColorCode
                                                            .textColor1,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                /* Expanded(
                                                  flex: 3,
                                                  child: Center(
                                                    child: Text(
                                                      'Time',
                                                      style: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          fontWeight:
                                                              FontWeight.bold,color: localColorCode.textColor1,),
                                                    ),
                                                  ),
                                                ),*/
                                              ],
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '.',
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 82,
                                          color: _chartTitle == 'Breakdown'
                                              ? Colors.black
                                              : Colors.grey,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        '.',
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 82,
                                          color: _chartTitle == 'Relative'
                                              ? Colors.black
                                              : Colors.grey,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        '.',
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 82,
                                          color: _chartTitle == 'Toppers'
                                              ? Colors.black
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      /* Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: size.height * 0.1,
                            child: Card(
                              child: Center(
                                  child: Text(
                                'See questions marked for Review.',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  //fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: size.height * 0.1,
                            child: InkWell(
                              child: Card(
                                child: Center(
                                    child: Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 48,
                                )),
                              ),
                              onTap: () {
                                _reviewList.length == 1
                                    ? showToast(
                                        'Currently ${_reviewList.length} question marked for review.',
                                        textStyle: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontWeight: FontWeight.bold,
                                        ),
                                        position: ToastPosition.bottom,
                                      )
                                    : showToast(
                                        'Currently ${_reviewList.length} questions marked for review.',
                                        textStyle: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontWeight: FontWeight.bold,
                                        ),
                                        position: ToastPosition.bottom,
                                      );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: size.height * 0.1,
                            child: Card(
                              child: Center(
                                child: Text(
                                  'Hard',
                                  style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: size.height * 0.1,
                            child: Card(
                              child: Center(
                                child: Text(
                                  'Moderate',
                                  style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: size.height * 0.1,
                            child: Card(
                              child: Center(
                                child: Text(
                                  'Easy',
                                  style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: size.height * 0.1,
                            child: Card(
                              child: Center(
                                child: Text(
                                  'Reappear',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),*/
                    ],
                  ),
                ],
              );
            } else {
              return LoadingWidget();
            }
          },
        ),
      ),
    );
  }
}
