import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../models/my_que_list.dart';
import '../my_arguments/my_arguments2.dart';

class MyQueListWidget extends StatefulWidget {
  @override
  _MyQueListWidgetState createState() => _MyQueListWidgetState();
}

class _MyQueListWidgetState extends State<MyQueListWidget> {
  int _curListItemIndex;
  @override
  Widget build(BuildContext context) {
    RouteSettings settings = ModalRoute.of(context).settings;
    MyArguments2 myArguments2 = settings.arguments;
    String titleString = myArguments2.titleString;
    Size size = MediaQuery.of(context).size;
    EdgeInsets pdTop = MediaQuery.of(context).padding;
    MyQueList myQueList = new MyQueList();
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
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            height: size.height * 0.85,
            child: ListView.builder(
                itemCount: myQueList.queList.length,
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
                                            child:
                                                Icon(Entypo.info_with_circle),
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
                                                  myQueList.queList[index].que,
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
                                            'a)' + myQueList.queList[index].op1,
                                            style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 20,
                                              color: myQueList
                                                          .queList[index].ans ==
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
                                            'b)' + myQueList.queList[index].op2,
                                            style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 20,
                                              color: myQueList
                                                          .queList[index].ans ==
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
                                            'c)' + myQueList.queList[index].op3,
                                            style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 20,
                                              color: myQueList
                                                          .queList[index].ans ==
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
                                            'd)' + myQueList.queList[index].op4,
                                            style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 20,
                                              color: myQueList
                                                          .queList[index].ans ==
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
                                          Text(myQueList.queList[index].queId,
                                              style: TextStyle(
                                                  fontFamily: 'Nunito',
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
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
                                              color: myQueList
                                                      .queList[index].bkStatus
                                                  ? Colors.yellow
                                                  : Colors.grey,
                                            ),
                                            onTap: () {
                                              setState(() {
                                                myQueList.queList[index]
                                                        .bkStatus =
                                                    !myQueList.queList[index]
                                                        .bkStatus;
                                              });
                                            },
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            myQueList.queList[index].bkCount
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
                                              color: myQueList
                                                      .queList[index].bkStatus
                                                  ? Colors.yellow
                                                  : Colors.grey,
                                            ),
                                            onTap: () {
                                              setState(() {
                                                myQueList.queList[index]
                                                        .bkStatus =
                                                    !myQueList.queList[index]
                                                        .bkStatus;
                                              });
                                            },
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            myQueList.queList[index].rprtCount
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
                                              myQueList.queList[index].veteran
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
        ]),
      ),
    );
  }
}
