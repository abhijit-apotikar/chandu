import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_proc/my_arguments/my_arguments1.dart';
import '../my_arguments/my_arguments1.dart';
import '../my_arguments/my_arguments2.dart';
import '../widgets/my_quiz_widget.dart';
import '../models/set_up_model.dart';

class MyListWidget extends StatefulWidget {
  @override
  _MyListWidgetState createState() => _MyListWidgetState();
}

class _MyListWidgetState extends State<MyListWidget> {
  @override
  Widget build(BuildContext context) {
    RouteSettings settings = ModalRoute.of(context).settings;
    MyArguments1 myArguments1 = settings.arguments;
    String titleString = myArguments1.title;
    List<Map<String, String>> contentArray = myArguments1.contentArray;
    Size size = MediaQuery.of(context).size;
    EdgeInsets pdTop = MediaQuery.of(context).padding;
    SetUpModel _setUpModel = Provider.of<SetUpModel>(context);
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
                  SizedBox(width: 10),
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
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            height: size.height * 0.8,
            child: ListView.builder(
                itemCount: _setUpModel.subList.length,
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
                              child: Text(
                            _setUpModel.subList[index],
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              //fontSize: 24,
                            ),
                          )),
                        )),
                    onTap: () {
                      if (contentArray[index]['listType'] == 'test') {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return MyQuizWidget(
                                int.parse(contentArray[index]['hours']),
                                int.parse(contentArray[index]['minutes']),
                                int.parse(contentArray[index]['seconds']));
                          },
                        ));
                      } else {
                        MyArguments2 myArguments2 =
                            new MyArguments2(contentArray[index]['title']);
                        Navigator.pushNamed(context, '/MyQueListWidget',
                            arguments: myArguments2);
                      }
                    },
                  );
                }),
          ),
        ]),
      ),
    );
  }
}
