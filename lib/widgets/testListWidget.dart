import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ------------------ my packages -----------------------
import '../my_arguments/my_time_arguments.dart';
import '../widgets/loadingWidget.dart';
import '../widgets/my_quiz_widget.dart';
import '../models/set_up_model.dart';
import '../services/firestoreService.dart';
import '../models/colorCodeNotifier.dart';
import '../models/colorCodeModel.dart';

class TestListWidget extends StatefulWidget {
  @override
  _TestListWidgetState createState() => _TestListWidgetState();
}

class _TestListWidgetState extends State<TestListWidget> {
  @override
  Widget build(BuildContext context) {
    RouteSettings settings = ModalRoute.of(context).settings;
    MyTimeArguments myTimeArguments = settings.arguments;
    String titleString = myTimeArguments.title;
    int _hours = myTimeArguments.hours;
    int _minutes = myTimeArguments.minutes;
    int _seconds = myTimeArguments.seconds;
    Size size = MediaQuery.of(context).size;
    EdgeInsets pdTop = MediaQuery.of(context).padding;
    SetUpModel _setUpModel = Provider.of<SetUpModel>(context);
    final FirestoreService _fService = new FirestoreService();
    ColorCodeNotifier _colorCodeNotifier =
        Provider.of<ColorCodeNotifier>(context);
    ColorCodeModel localColorCode = _colorCodeNotifier.getColorCode();

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
        child: Column(children: [
          SizedBox(
            height: pdTop.top,
          ),
          SizedBox(height: 10),
          Container(
            height: size.height * 0.085,
            child: Card(
              color: localColorCode.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Row(
                children: [
                  SizedBox(width: 20),
                  GestureDetector(
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 32,
                      color: localColorCode.textColor1,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  SizedBox(width: 10),
                  Text(
                    titleString,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 32,
                      color: localColorCode.textColor1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder(
            future: _fService.getTests(
                _setUpModel.curSub, _hours, _minutes, _seconds),
            builder: (context, snapshot) {
              if (snapshot.hasError || snapshot.data == false) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  height: size.height * 0.85,
                  child: Center(
                    child: Text(
                      'Sorry, No tests available.',
                      style: TextStyle(
                          fontFamily: 'Nunito',
                          color: localColorCode.textColor1),
                    ),
                  ),
                );
              } else if (snapshot.hasData) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  height: size.height * 0.8,
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          child: Container(
                              child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: localColorCode.transparentCard,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      snapshot.data[index]['testName'],
                                      style: TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: 18,
                                        color: localColorCode.textColor1,
                                      ),
                                    ),
                                    Text(
                                      'Test Setter: ${snapshot.data[index]['testSetter']}',
                                      style: TextStyle(
                                        fontFamily: 'Nunito',
                                        color: localColorCode.textColor1,
                                      ),
                                    ),
                                    Text(
                                      'Attempts: ${snapshot.data[index]['attempts']}',
                                      style: TextStyle(
                                        fontFamily: 'Nunito',
                                        color: localColorCode.textColor1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return MyQuizWidget(
                                    snapshot.data[index]['testName'],
                                    _hours,
                                    _minutes,
                                    _seconds);
                              },
                            ));
                          },
                        );
                      }),
                );
              } else {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  height: size.height * 0.85,
                  child: Center(
                    child: LoadingWidget(),
                  ),
                );
              }
            },
          ),
        ]),
      ),
    );
  }
}
