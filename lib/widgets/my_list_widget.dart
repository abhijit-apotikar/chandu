import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ------------------ my packages -----------------------
import '../my_arguments/my_arguments1.dart';
import '../my_arguments/my_arguments2.dart';
import '../widgets/my_quiz_widget.dart';
import '../widgets/loadingWidget.dart';
import '../models/set_up_model.dart';
import '../models/my_list_model.dart';
import '../services/firestoreService.dart';

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
    Size size = MediaQuery.of(context).size;
    EdgeInsets pdTop = MediaQuery.of(context).padding;
    SetUpModel _setUpModel = Provider.of<SetUpModel>(context);
    MyListModel _myListModel = Provider.of<MyListModel>(context);
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
      child: FutureBuilder(
        future: titleString == 'Chapters'
            ? _fService.getChapters(_setUpModel.curCourse,
                _setUpModel.curSubComb, _setUpModel.curSem, _setUpModel.curSub)
            : (titleString == 'Exams'
                ? _fService.getPreviousExams()
                : _fService.getTestSchemes()),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            titleString == 'Chapters'
                ? _myListModel.setChapterList(snapshot.data)
                : (titleString == 'Exams'
                    ? _myListModel.setExamList(snapshot.data)
                    : _myListModel.setTestSchemeList(snapshot.data));
            return Column(children: [
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
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                    itemCount: titleString == 'Chapters'
                        ? _myListModel.chapterList.length
                        : (titleString == 'Exams'
                            ? _myListModel.examList.length
                            : _myListModel.testSchemeList.length),
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
                                titleString == 'Chapters'
                                    ? _myListModel.chapterList[index]
                                        ['chapterName']
                                    : (titleString == 'Exams'
                                        ? _myListModel.examList[index]
                                            ['examName']
                                        : _myListModel.testSchemeList[index]
                                            ['title']),
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                ),
                              )),
                            )),
                        onTap: () {},
                      );
                    }),
              ),
            ]);
          } else {
            return LoadingWidget();
          }
        },
      ),
    ));
  }
}
