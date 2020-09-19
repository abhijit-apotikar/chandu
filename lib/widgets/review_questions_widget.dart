import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../my_arguments/arguments_to_review_questions.dart';
import '../models/my_que_list.dart';
import '../models/my_que_model.dart';

class ReviewQuestionsWidget extends StatefulWidget {
  @override
  _ReviewQuestionsWidgetState createState() => _ReviewQuestionsWidgetState();
}

class _ReviewQuestionsWidgetState extends State<ReviewQuestionsWidget> {
  int _curListItemIndex;

  //function to get custom review list ########################################
  List<MyQueModel> _getCustomReviewList(
      List<Map<String, bool>> reviewList1, MyQueList myQueList1) {
    List<Map<String, bool>> _reviewList = reviewList1;
    MyQueList myQueList = myQueList1;
    List<MyQueModel> customList = [];
    for (int i = 0; i < _reviewList.length; i++) {
      _reviewList[i].forEach((key, value) {
        customList.add(
            myQueList.queList.firstWhere((element) => (element.queId == key)));
      });
    }
    return customList;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    EdgeInsets pdTop = MediaQuery.of(context).padding;
    RouteSettings settings = ModalRoute.of(context).settings;
    ArgumentsToReviewQuestions argumetnsToReviewQuestions = settings.arguments;
    List<Map<String, bool>> _reviewList = argumetnsToReviewQuestions.reviewList;
    MyQueList myQueList = new MyQueList();
    List<MyQueModel> customList = _getCustomReviewList(_reviewList, myQueList);
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: pdTop.top + 10,
              ),
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
                      InkWell(
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
                        'Review Questions',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: size.height * 0.05,
                child: Center(
                  child: Text(
                    'You had marked ${customList.length} questions for review.',
                    style: TextStyle(fontFamily: 'Nunito'),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 5,right: 5, top: 0,bottom: 40),
                height: size.height * 0.85,
                child: ListView.builder(
                    itemCount: _reviewList.length,
                    itemBuilder: (context, index) {
                      return IndexedStack(
                          index: index == _curListItemIndex ? 1 : 0,
                          children: [
                            Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 10),
                                // height: size.height * 0.45,
                                constraints: BoxConstraints(
                                  maxHeight: size.height * 0.8,
                                  maxWidth: size.width,
                                  minWidth: size.width,
                                  minHeight: size.height * 0.2,
                                ),
                                child: Card(
                                  shadowColor: Colors.black45,
                                  //margin: EdgeInsets.all(10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  color: Colors.transparent,
                                  child: SingleChildScrollView(
                                    child: Container(
                                      // margin: EdgeInsets.all(10),
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
                                              InkWell(
                                                child: Icon(Entypo.bookmark),
                                                onTap: () {},
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              InkWell(
                                                child: Icon(FontAwesome
                                                    .exclamation_triangle),
                                                onTap: () {},
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              InkWell(
                                                child: Icon(
                                                    Entypo.info_with_circle),
                                                onTap: () {
                                                  setState(() {
                                                    _curListItemIndex = index;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  'Que.) ' +
                                                      customList[index].que,
                                                  style: TextStyle(
                                                    fontFamily: 'Nunito',
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Text(
                                                'a)' + customList[index].op1,
                                                style: TextStyle(
                                                  fontFamily: 'Nunito',
                                                  fontSize: 20,
                                                  color:
                                                      customList[index].ans ==
                                                              'op1'
                                                          ? Colors.red
                                                          : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'b)' + customList[index].op2,
                                                style: TextStyle(
                                                  fontFamily: 'Nunito',
                                                  fontSize: 20,
                                                  color:
                                                      customList[index].ans ==
                                                              'op2'
                                                          ? Colors.red
                                                          : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'c)' + customList[index].op3,
                                                style: TextStyle(
                                                  fontFamily: 'Nunito',
                                                  fontSize: 20,
                                                  color:
                                                      customList[index].ans ==
                                                              'op3'
                                                          ? Colors.red
                                                          : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'd)' + customList[index].op4,
                                                style: TextStyle(
                                                  fontFamily: 'Nunito',
                                                  fontSize: 20,
                                                  color:
                                                      customList[index].ans ==
                                                              'op4'
                                                          ? Colors.red
                                                          : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                            Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 10),
                                // height: size.height * 0.45,
                                constraints: BoxConstraints(
                                  maxHeight: size.height * 0.8,
                                  maxWidth: size.width,
                                  minWidth: size.width,
                                  minHeight: size.height * 0.2,
                                ),
                                child: Card(
                                  shadowColor: Colors.black45,
                                  //margin: EdgeInsets.all(10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  color: Colors.transparent,
                                  child: SingleChildScrollView(
                                    child: Container(
                                      // margin: EdgeInsets.all(10),
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
                                                InkWell(
                                                  child: Icon(
                                                    Entypo.cross,
                                                    size: 32,
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      _curListItemIndex = null;
                                                    });
                                                  },
                                                ),
                                              ]),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Text('Que. No.: ',
                                                  style: TextStyle(
                                                    fontFamily: 'Nunito',
                                                    fontSize: 20,
                                                  )),
                                              Text(customList[index].queId,
                                                  style: TextStyle(
                                                      fontFamily: 'Nunito',
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.redAccent)),
                                              SizedBox(
                                                width: 15,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text('Bookmark ',
                                                  style: TextStyle(
                                                    fontFamily: 'Nunito',
                                                    fontSize: 20,
                                                  )),
                                              InkWell(
                                                child: Icon(
                                                  Icons.star,
                                                  size: 24,
                                                  color:
                                                      customList[index].bkStatus
                                                          ? Colors.yellow
                                                          : Colors.grey,
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    customList[index].bkStatus =
                                                        customList[index]
                                                            .bkStatus;
                                                  });
                                                },
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                customList[index]
                                                    .bkCount
                                                    .toString(),
                                                style: TextStyle(
                                                  fontFamily: 'Nunito',
                                                  fontSize: 20,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Report: ',
                                                style: TextStyle(
                                                    fontFamily: 'Nunito',
                                                    fontSize: 20),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              InkWell(
                                                child: Icon(
                                                  Icons.error,
                                                  size: 24,
                                                  color:
                                                      customList[index].bkStatus
                                                          ? Colors.yellow
                                                          : Colors.grey,
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    customList[index].bkStatus =
                                                        customList[index]
                                                            .bkStatus;
                                                  });
                                                },
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                customList[index]
                                                    .rprtCount
                                                    .toString(),
                                                style: TextStyle(
                                                  fontFamily: 'Nunito',
                                                  fontSize: 20,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Added on: ',
                                                style: TextStyle(
                                                    fontFamily: 'Nunito',
                                                    fontSize: 20),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Veteran: ',
                                                style: TextStyle(
                                                    fontFamily: 'Nunito',
                                                    fontSize: 20),
                                              ),
                                              Text(
                                                  customList[index].veteran
                                                      ? 'Yes'
                                                      : 'No',
                                                  style: TextStyle(
                                                    fontFamily: 'Nunito',
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.redAccent,
                                                  )),
                                              SizedBox(
                                                width: 10,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Last Reviewed: ',
                                                style: TextStyle(
                                                  fontFamily: 'Nunito',
                                                  fontSize: 20,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                          ]);
                    }),
              ),
             
            ],
          ),
        ),
      ),
    );
  }
}
