import 'package:flutter/material.dart';
import '../models/my_list_model.dart';
import '../my_arguments/my_arguments1.dart';

class MainContentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    MyListModel mlm = new MyListModel();

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            height: size.height * 0.3,
            child: InkWell(
              child: Card(
                shadowColor: Colors.black45,
                color: Colors.transparent,
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
                    ),
                  ),
                ),
              ),
              onTap: () {
                MyArguments1 myArguments1 =
                    new MyArguments1(mlm.title1, mlm.chapterList);
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
                color: Colors.transparent,
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
                    ),
                  ),
                ),
              ),
              onTap: () {
                MyArguments1 myArguments1 =
                    new MyArguments1(mlm.title2, mlm.examList);
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
                color: Colors.transparent,
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
                    ),
                  ),
                ),
              ),
              onTap: () {
                MyArguments1 myArguments1 =
                    new MyArguments1(mlm.title3, mlm.testSchemeList);
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
