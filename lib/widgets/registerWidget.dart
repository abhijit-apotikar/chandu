import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/authService.dart';

import '../widgets/loadingWidget.dart';
import '../widgets/alertDialog.dart';

import '../shared/constants.dart';
import '../models/userIdStatus.dart';

class RegisterWidget extends StatefulWidget {
  @override
  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  bool loading = false;
  bool _agreedToTerms = false;
  final _formKey = GlobalKey<FormState>();
 
   

  ///------------textField e-mail,password local variables--------
  String email = '';
  String password = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    AuthService _auth = new AuthService();
  final userIdStatus = Provider.of<UserIdStatus>(context);
    return loading
        ? LoadingWidget()
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: new Text(
                'Register',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              iconTheme: new IconThemeData(
                size: 20,
              ),
              /*  actions: <Widget>[
                Material(
                  elevation: 4,
                  color: Colors.pink,
                  child: FlatButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      label: Text(
                        'sign in',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )),
                
              ],*/
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 40,
                      horizontal: 20,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            style: myTextFormFieldTextStyle,
                            decoration: textFormFieldDecoration.copyWith(
                                hintText: 'Email'),
                            validator: (val) =>
                                val.isEmpty ? 'Enter an e-mail' : null,
                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            style: myTextFormFieldTextStyle,
                            decoration: textFormFieldDecoration.copyWith(
                                hintText: 'Password'),
                            validator: (val) => val.length < 6
                                ? 'Password should be atleast 6 characters long'
                                : null,
                            obscureText: true,
                            onChanged: (val) {
                              password = val;
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: new BoxDecoration(
                              border: new Border.all(
                                width: 2,
                                color: Colors.green,
                              ),
                              borderRadius: new BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Terms & Conditions',
                                      style: TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Flexible(
                                      child: Text(
                                        'Your email will be used in no way other than for identification purpose and account related correspondence.',
                                        style: TextStyle(fontFamily: 'Nunito'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CheckboxListTile(
                            title: Text(
                              'I agree to terms & conditions',
                              style: TextStyle(fontFamily: 'Nunito'),
                            ),
                            value: _agreedToTerms,
                            onChanged: (value) {
                              if (_agreedToTerms == false) {
                                setState(() {
                                  _agreedToTerms = true;
                                });
                              } else if (_agreedToTerms = true) {
                                setState(() {
                                  _agreedToTerms = false;
                                });
                              }
                            },
                            subtitle: !_agreedToTerms
                                ? Padding(
                                    padding: EdgeInsets.fromLTRB(12.0, 0, 0, 0),
                                    child: Text(
                                      'You need to agree to the Terms & Conditions before proceeding.',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                          fontFamily: 'Nunito'),
                                    ),
                                  )
                                : null,
                          ),
                          SizedBox(height: 30),
                          Material(
                            elevation: 5,
                            color: Colors.amber[300],
                            child: FlatButton(
                              onPressed: () async {
                                if (_formKey.currentState.validate() &&
                                    _agreedToTerms) {
                                  setState(() {
                                    loading = true;
                                  });
                                  dynamic result =
                                      await _auth.registerWithEmailAndPassword(
                                          email, password);
                                  if (result != null) {
                                    Navigator.pop(context);
                                    userIdStatus.chngUIdStatus(false);
                                  }
                                  if (result == null) {
                                    setState(() {
                                      loading = false;
                                      error = 'Please enter a valid email id';
                                      showAlertDialog(context, error);
                                    });
                                  }
                                }
                              },
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                            ),
                          ),
                          /* SizedBox(
                      height: 20,
                    ),
                    Text(
                      error,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),*/
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
