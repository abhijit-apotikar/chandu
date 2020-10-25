import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// --------------- my packages -----------------------
import '../models/my_list_model.dart';
import '../models/set_up_model.dart';
import '../my_arguments/my_arguments1.dart';
import '../models/colorCodeNotifier.dart';
import '../models/colorCodeModel.dart';

class MainContentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    MyListModel mlm = new MyListModel();
    SetUpModel _setUpModel = Provider.of<SetUpModel>(context);
    ColorCodeNotifier _colorCodeNotifier =
        Provider.of<ColorCodeNotifier>(context);
    ColorCodeModel localColorCode = _colorCodeNotifier.getColorCode();
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 10.0,
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            height: size.height * 0.1,
            child: InkWell(
              child: Card(
                shadowColor: Colors.black45,
                color: localColorCode.transparentCard,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'Current Subject',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 18,
                          color: localColorCode.textColor1,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        '${_setUpModel.curSub}',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          color: localColorCode.textColor1,
                          //fontSize: 18,
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
              onTap: () {
                /* MyArguments1 myArguments1 =
                    new MyArguments1(mlm.title1, mlm.chapterList);
                Navigator.pushNamed(context, '/MyListWidget',
                    arguments: myArguments1);*/
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            height: size.height * 0.3,
            child: InkWell(
              child: Card(
                shadowColor: Colors.black45,
                color: localColorCode.transparentCard,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'See Chapterwise M.C.Q.\'s',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 18,
                      color: localColorCode.textColor1,
                    ),
                  ),
                ),
              ),
              onTap: () {
                MyArguments1 myArguments1 = new MyArguments1(mlm.title1);
                Navigator.pushNamed(context, '/MyListWidget',
                    arguments: myArguments1);
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            height: size.height * 0.3,
            child: InkWell(
              child: Card(
                shadowColor: Colors.black45,
                color: localColorCode.transparentCard,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'See Previous Examwise M.C.Q.\'s',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 18,
                      color: localColorCode.textColor1,
                    ),
                  ),
                ),
              ),
              onTap: () {
                MyArguments1 myArguments1 = new MyArguments1(mlm.title2);
                Navigator.pushNamed(context, '/MyListWidget',
                    arguments: myArguments1);
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            height: size.height * 0.3,
            child: InkWell(
              child: Card(
                shadowColor: Colors.black45,
                color: localColorCode.transparentCard,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'Take a TEST',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 18,
                      color: localColorCode.textColor1,
                    ),
                  ),
                ),
              ),
              onTap: () {
                MyArguments1 myArguments1 = new MyArguments1(mlm.title3);
                Navigator.pushNamed(context, '/MyListWidget',
                    arguments: myArguments1);
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
