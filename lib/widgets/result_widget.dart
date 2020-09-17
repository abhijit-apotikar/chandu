import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../my_arguments/test_arguments.dart';

import '../models/chartData _1.dart';
import '../models/my_que_list.dart';
import '../models/chartData_2.dart';
import '../models/test_statistics.dart';

import '../data/test_statistics_data.dart';

class ResultWidget extends StatefulWidget {
  @override
  _ResultWidgetState createState() => _ResultWidgetState();
}

class _ResultWidgetState extends State<ResultWidget> {
  TestStatisticsData testStatisticsData = new TestStatisticsData();
  String _chartTitle = 'Breakdown';

  List<Map<String, int>> calcResult(
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
  }

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
    List<Map<String, String>> _testAttempt = testArguments.testAttempt;
    List<Map<String, bool>> _reviewList = testArguments.reviewList;
    int _totalQue = testArguments.totalQue;
    List<Map<String, int>> result = calcResult(_testAttempt, _totalQue);

    final List<ChartData1> chartData = [
      ChartData1('Correct', result[0]['correct'], Colors.green[400]),
      ChartData1('Wrong', result[1]['wrong'], Colors.redAccent),
      ChartData1(
          'Not Attempted', result[2]['nonAttempted'], Colors.blueGrey.shade300),
    ];

    final List<ChartData2> chartData2 = [
      ChartData2(
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
      ),
    ];

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
          children: [
            SizedBox(
              height: pdTop.top + 10,
            ),
            Container(
              height: size.height * 0.085,
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    GestureDetector(
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 32,
                      ),
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed('/HomeScreenWidget');
                      },
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Test Result',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  height: size.height * 0.6,
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                  child: Stack(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: Colors.white,
                        child: PageView(
                          controller: _controller,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: SfCircularChart(
                                /* title: ChartTitle(
                                  text: 'Breakdown',
                                  textStyle: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrangeAccent,
                                  ),
                                ),*/
                                series: <CircularSeries>[
                                  DoughnutSeries<ChartData1, String>(
                                      dataSource: chartData,
                                      pointColorMapper: (ChartData1 data, _) =>
                                          data.color,
                                      xValueMapper: (ChartData1 data, _) =>
                                          data.name,
                                      yValueMapper: (ChartData1 data, _) =>
                                          data.value,
                                      explode: true,
                                      explodeIndex: 0),
                                ],
                                legend: Legend(
                                  isVisible: true,
                                  position: LegendPosition.bottom,
                                  overflowMode: LegendItemOverflowMode.wrap,
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
                              padding: const EdgeInsets.only(top: 50),
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
                                  title: AxisTitle(text: 'Subjects'),
                                ),
                                primaryYAxis: NumericAxis(
                                  minimum:
                                      testStatisticsData.testList[0].minMarks,
                                  maximum:
                                      testStatisticsData.testList[0].maxMarks,
                                  title: AxisTitle(text: 'marks'),
                                  interval: 1,
                                ),
                                series: <ChartSeries>[
                                  ColumnSeries<ChartData2, String>(
                                      name: 'Score',
                                      dataSource: chartData2,
                                      pointColorMapper: (ChartData2 data, _) =>
                                          data.color,
                                      xValueMapper: (ChartData2 data, _) =>
                                          data.name,
                                      yValueMapper: (ChartData2 data, _) =>
                                          data.value,
                                      dataLabelSettings: DataLabelSettings(
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
                                top: 50,
                                bottom: 10,
                                left: 4,
                                right: 4,
                              ),
                              child: ListView.builder(
                                  itemCount: testStatisticsData
                                          .testList[0].topperList.length +
                                      1,
                                  itemBuilder: (context, index) {
                                    return index == 0
                                        ? Container(
                                            height: size.height * 0.1,
                                            child: Card(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Center(
                                                      child: Text(
                                                        'Sr. No.',
                                                        style: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Center(
                                                      child: Text(
                                                        'Time',
                                                        style: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: size.height * 0.1,
                                            child: Card(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Center(
                                                      child: Text(
                                                        '${index}',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Nunito'),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 6,
                                                    child: Center(
                                                      child: Text(
                                                        '${testStatisticsData.testList[0].topperList[index - 1]['name']}',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Nunito'),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Center(
                                                      child: Text(
                                                        '${testStatisticsData.testList[0].topperList[index - 1]['score']}',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Nunito'),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Center(
                                                      child: Text(
                                                        '${testStatisticsData.testList[0].topperList[index - 1]['timeTaken']}',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Nunito'),
                                                      ),
                                                    ),
                                                  ),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        height: size.height * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 32,
                                color: Colors.grey,
                              ),
                              onTap: () {
                                setState(() {
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
                                      position: ToastPosition.bottom,
                                    );
                                  } else if (_controller.page == 1) {
                                    _chartTitle = 'Breakdown';
                                    _controller.animateToPage(0,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                  } else {
                                    _chartTitle = 'Relative';
                                    _controller.animateToPage(1,
                                        duration: Duration(milliseconds: 500),
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
                                  color: Colors.grey,
                                ),
                                onTap: () {
                                  setState(
                                    () {
                                      if (_controller.page == 2) {
                                        showToast(
                                          'This is the last card.',
                                          position: ToastPosition.bottom,
                                        );
                                      } else if (_controller.page == 1) {
                                        _chartTitle = 'Toppers';
                                        _controller.animateToPage(2,
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.ease);
                                      } else {
                                        _chartTitle = 'Breakdown';
                                        _controller.animateToPage(1,
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.ease);
                                      }
                                    },
                                  );
                                }),
                          ],
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
