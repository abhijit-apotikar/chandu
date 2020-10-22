import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ------------------ my packages -----------------------
import '../my_arguments/my_time_arguments.dart';
import '../widgets/loadingWidget.dart';
import '../models/set_up_model.dart';
import '../services/firestoreService.dart';

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
        child: Column(children: [
          SizedBox(
            height: pdTop.top,
          ),
          SizedBox(height: 10),
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
                  SizedBox(width: 20),
                  GestureDetector(
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 32,
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
                    child: Text('Sorry, No Questions Available.'),
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
                              height: size.height * 0.1,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                color: Colors.transparent,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      snapshot.data[index]['testName'],
                                      style: TextStyle(
                                        fontFamily: 'Nunito',
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                          onTap: () {},
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