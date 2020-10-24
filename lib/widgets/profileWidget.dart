import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// -------------- my packages --------------------
import '../models/set_up_model.dart';

class ProfileWidget extends StatefulWidget {
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    // List<Map<String,dynamic>> _userData = [];

    Size size = MediaQuery.of(context).size;
    //MyListModel mlm = new MyListModel();
    final user = Provider.of<User>(context);
//final userIdStatus = Provider.of<UserIdStatus>(context);
    SetUpModel _setUpModel = Provider.of<SetUpModel>(context);

    // _fsService.getUserInfo(cUser).then((value) => _userData.add(value));
    // String _userNameId = _userData[0]['pubUserId'];

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                fit: BoxFit.contain,
                image: user.isAnonymous
                    ? AssetImage('assets/images/person.png')
                    : (user.photoURL != null
                        ? NetworkImage(user.photoURL)
                        : AssetImage('assets/images/person.png')),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            height: size.height * 0.5,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 2.0, right: 2.0, top: 8.0),
                  child: Row(
                    children: [
                      Text(
                        'User Id: ',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'user',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 16,
                        ),
                      ),

                      /*Text(
                        'User ID: ',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 18,
                        ),
                      ),*/
                    ],
                  ),
                ),
                Divider(
                  thickness: 2,
                ),
                /* SizedBox(
                  height: 10,
                ),*/
                Padding(
                  padding:
                      const EdgeInsets.only(left: 2.0, right: 2.0, top: 8.0),
                  child: Row(
                    children: [
                      Text(
                        'Email: ',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 16,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          user.isAnonymous ? "Annonymous User" : user.email,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 2,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  padding: const EdgeInsets.only(
                      left: 2.0, right: 2.0, top: 8.0, bottom: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2.0,
                      color: Colors.black.withOpacity(0.15),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Course set up',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 2.0,
                          right: 2.0,
                        ),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Course:  ${_setUpModel.curCourse}',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 2.0,
                          right: 2.0,
                        ),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Group:  ${_setUpModel.curSubComb}',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 2.0,
                          right: 2.0,
                        ),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sem:  ${_setUpModel.curSem}',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
