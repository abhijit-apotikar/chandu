import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../my_arguments/test_arguments.dart';

import '../models/chartData _1.dart';
import '../models/my_que_list.dart';

class ResultWidget extends StatelessWidget {
  int countCorrect(List<Map<String, String>> testAttempt1, int totalQue1) {
    List<Map<String, String>> testAttempt = testAttempt1;
    int totalQue = totalQue1;
    int correct = 0;
    MyQueList myQueList = new MyQueList();
    for (int i = 0; i < testAttempt.length; i++) {
      /* if(testAttempt[i].forEach((key, value) {
        if(key == myQueList.queList.firstWhere((element) => element.queId)){}
      }))*/
      testAttempt[i].forEach((key, value) {
        if (myQueList.queList
                .firstWhere((element) => element.queId == key)
                .ans ==
            testAttempt[i][key]) {
          correct++;
        }
        ;
      });
    }
    return correct;
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
    int correct = countCorrect(_testAttempt, _totalQue);
    int notAttempted = _totalQue - _testAttempt.length;
    int wrong = _totalQue - (correct + notAttempted);
    final List<ChartData1> chartData = [
      ChartData1('Correct', correct, Colors.green[400]),
      ChartData1('Wrong', wrong, Colors.redAccent),
      ChartData1('Not Attempted', notAttempted, Colors.blueGrey.shade300),
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
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Colors.white,
                    child: SfCircularChart(
                      title: ChartTitle(
                        text: 'Breakdown',
                        textStyle: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      series: <CircularSeries>[
                        DoughnutSeries<ChartData1, String>(
                            dataSource: chartData,
                            pointColorMapper: (ChartData1 data, _) =>
                                data.color,
                            xValueMapper: (ChartData1 data, _) => data.name,
                            yValueMapper: (ChartData1 data, _) => data.value,
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
                          child: Card(
                            child: Icon(Icons.thumb_up),
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
                        flex: 1,
                        child: Container(
                          height: size.height * 0.1,
                          child: Card(
                            child: Center(
                              child: Icon(Icons.thumb_up),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: size.height * 0.1,
                          child: Card(
                            child: Icon(Icons.thumb_down),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: size.height * 0.1,
                          child: Card(
                            child: Icon(Icons.share),
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
