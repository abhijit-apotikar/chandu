import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oktoast/oktoast.dart';

// ------------- my packages -------------
import 'main_content_widget.dart';
import '../models/set_up_model.dart';
import '../models/my_model.dart';
import 'profileWidget.dart';
import 'settingsWidget.dart';
import '../services/firestoreService.dart';
import '../widgets/loadingWidget.dart';
import '../models/colorCodeNotifier.dart';
import '../models/colorCodeModel.dart';

class HomePageWidget extends StatefulWidget {
  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  int _index = 0;
  int _curMarked = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    EdgeInsets pdTop = MediaQuery.of(context).padding;
    SetUpModel _setUpModel = Provider.of<SetUpModel>(context);
    final FirestoreService _fService = new FirestoreService();
    ColorCodeNotifier _colorCodeNotifier =
        Provider.of<ColorCodeNotifier>(context);
    ColorCodeModel localColorCode = _colorCodeNotifier.getColorCode();

    /* setState(() {
      if (_curMarked == null) {
        _curMarked = _setUpModel.subList
            .indexWhere((element) => element['subName'] == _setUpModel.curSub);
      }
    });*/

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
          future: _fService.getSetUpData(_setUpModel.curCourse,
              _setUpModel.curSubComb, _setUpModel.curSem),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (_setUpModel.subList.isEmpty) {
                _setUpModel.setData(snapshot.data);
              }
              return IndexedStack(index: _index, children: [
                ChangeNotifierProvider<MyModel>(
                  create: (_) => MyModel(),
                  child: Column(
                    children: [
                      Container(
                        height: pdTop.top,
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: size.height * 0.085,
                        margin: const EdgeInsets.all(0),
                        child: Card(
                          color: localColorCode.cardColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          elevation: 10,
                          child: Center(child: Consumer<MyModel>(
                            builder: (context, myModel, child) {
                              return myModel.curPg == "Home"
                                  ? Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            myModel.titleText,
                                            style: TextStyle(
                                              fontSize: 32,
                                              fontFamily: 'Nunito',
                                              color: localColorCode.textColor1,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                            // alignment: Alignment.centerRight,
                                            right: 10,
                                            top: size.height * 0.01,
                                            child: RaisedButton(
                                              child: Text(
                                                'Subject',
                                                style: TextStyle(
                                                  fontFamily: 'Nunito',
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      localColorCode.textColor2,
                                                ),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _index = 1;
                                                });
                                              },
                                            ) /*Consumer<SetUpModel>(
                            builder: (context, setUpModel, child) {
                              return ;
                              DropdownButton(
                                value: setUpModel.curSub,
                                icon: Icon(
                                  Icons.arrow_downward,
                                  color: Colors.deepPurpleAccent,
                                ),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurpleAccent,
                                ),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                items: setUpModel.subList
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String newSub) {
                                  setUpModel.chngCurSub(newSub);
                                },
                              );
                            },
                          ),*/
                                            )
                                      ],
                                    )
                                  : Text(
                                      myModel.titleText,
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontFamily: 'Nunito',
                                        color: localColorCode.textColor1,
                                      ),
                                    );
                            },
                          )),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: size.width,
                          child: Consumer<MyModel>(
                            builder: (context, myModel, child) {
                              return myModel.curPg == 'Home'
                                  ? MainContentWidget()
                                  : (myModel.curPg == 'Profile'
                                      ? ProfileWidget()
                                      : SettingsWidget());
                            },
                          ),
                        ),
                      ),
                      Card(
                        color: Colors.white.withOpacity(0.4),
                        elevation: 10,
                        margin: const EdgeInsets.all(0),
                        child: Container(
                          margin: const EdgeInsets.all(0),
                          height: size.height * 0.1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Consumer<MyModel>(
                                builder: (context, myModel, child) {
                                  return InkWell(
                                      child: Container(
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          margin: const EdgeInsets.all(0),
                                          color: myModel.clr1,
                                          width: size.width * 0.33,
                                          child: Icon(
                                            Icons.home,
                                            size: 38,
                                            color: localColorCode.textColor1,
                                          )),
                                      onTap: () {
                                        myModel.chngPg(1);
                                      });
                                },
                              ),
                              Consumer<MyModel>(
                                builder: (context, myModel, child) {
                                  return InkWell(
                                      child: Container(
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          margin: const EdgeInsets.all(0),
                                          color: myModel.clr2,
                                          width: size.width * 0.33,
                                          child: Icon(
                                            Icons.person,
                                            size: 38,
                                            color: localColorCode.textColor1,
                                          )),
                                      onTap: () {
                                        myModel.chngPg(2);
                                      });
                                },
                              ),
                              Consumer<MyModel>(
                                builder: (context, myModel, child) {
                                  return InkWell(
                                      child: Container(
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          margin: const EdgeInsets.all(0),
                                          color: myModel.clr3,
                                          width: size.width * 0.33,
                                          child: Icon(
                                            Icons.settings,
                                            size: 38,
                                            color: localColorCode.textColor1,
                                          )),
                                      onTap: () {
                                        myModel.chngPg(3);
                                      });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: pdTop.top + 10.0,
                      ),

                      SizedBox(
                        height: 10.0,
                      ),

                      Container(
                        //padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                _setUpModel.totalElectives == 0
                                    ? 'You have total ${_setUpModel.totalPapers} papers and all are compulsory'
                                    : 'You have total ${_setUpModel.totalPapers} theory papers out of which ${(_setUpModel.totalPapers - _setUpModel.totalElectives)} are compulsory(marked with a yellow stripe) and ${_setUpModel.totalElectives} is elective which is to be chosen from among a set of ${_setUpModel.totalElectiveChoices} papers(marked with a red stripe). ',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  color: localColorCode.textColor1,
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                'Select any one subject from the following:',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.bold,
                                  color: localColorCode.textColor1,
                                ),
                              ),
                              Text(
                                '(Current subject is marked in blue)',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.bold,
                                  color: localColorCode.textColor1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      //Text('${_setUpModel.subList[0]}'),
                      /* Text('${_setUpModel.subList[0]}'),
                    Text('${_setUpModel.subList[1]}'),
                    Text('${_setUpModel.subList[2]}'),
                    Text('${_setUpModel.subList[3]}'),
                    Text('${_setUpModel.subList[4]}'),
                    Text('${_setUpModel.subList[5]}'),
                    Text('${_setUpModel.subList.length}'),*/
                      Expanded(
                        flex: 5,
                        child: Container(
                          // height: size.height * 0.8,
                          constraints: BoxConstraints(
                            minHeight: size.height * 0.8,
                            //maxHeight: size.height * 0.4,
                          ),
                          child: ListView.builder(
                              itemCount: _setUpModel.subList.length,
                              itemBuilder: (context, index) {
                                return Container(
                                    // height: size.height * 0.2,
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(children: [
                                      Card(
                                        color: _setUpModel.subList[index]
                                                    ['isElective'] ==
                                                true
                                            ? Colors.redAccent
                                            : Colors.amberAccent,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '${index + 1}',
                                            style: TextStyle(
                                              fontFamily: 'Nunito',
                                              color: localColorCode.textColor1,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          child: Card(
                                            color: _curMarked == index
                                                ? Colors.blue
                                                : localColorCode.cardColor,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                '${_setUpModel.subList[index]['subName']}',
                                                style: TextStyle(
                                                  fontFamily: 'Nunito',
                                                  color:
                                                      localColorCode.textColor1,
                                                ),
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              if (_setUpModel.subList[index]
                                                      ['isAvailable'] ==
                                                  true) {
                                                String msg = _curMarked == index
                                                    ? ' Current subject stands unchanged '
                                                    : ' Current subject stands changed ';

                                                _curMarked = index;
                                                showToast(msg,
                                                    textStyle: TextStyle(
                                                        fontFamily: 'Nunito',
                                                        color: localColorCode
                                                            .toastTextColor),
                                                    position:
                                                        ToastPosition.bottom,
                                                    backgroundColor: localColorCode
                                                        .toastBackgroundColor);
                                                _setUpModel.chngCurSub(
                                                    '${_setUpModel.subList[index]['subName']}');
                                              } else {
                                                showToast(
                                                    ' This subject is not available. ',
                                                    textStyle: TextStyle(
                                                        fontFamily: 'Nunito',
                                                        color: localColorCode
                                                            .toastTextColor),
                                                    position:
                                                        ToastPosition.center,
                                                    backgroundColor: localColorCode
                                                        .toastBackgroundColor);
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ]));
                              }),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      RaisedButton(
                          child: Text(
                            'Close',
                            style: TextStyle(fontFamily: 'Nunito'),
                          ),
                          onPressed: () {
                            setState(() {
                              _index = 0;
                            });
                          }),
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                    ],
                  ),
                ),
              ]);
            } else {
              return LoadingWidget();
            }
          },
        ),
      ),
    );
  }
}
