import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthScreenWidget extends StatefulWidget {
  @override
  _AuthScreenWidgetState createState() => _AuthScreenWidgetState();
}

class _AuthScreenWidgetState extends State<AuthScreenWidget> {
  bool _obscureText = true;

  final String assetName = 'assets/svgs/app_title1.svg';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double pt = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: new LinearGradient(
              colors: [
                // Color(0xffffd740),
                Color(0xffb2ff59),
                Color(0xff69f0ae),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: pt,
              ),
              Container(
                // margin: EdgeInsets.all(0),
                height: size.height * 0.4,
                child: Center(
                  child: SvgPicture.asset(
                    assetName,
                    semanticsLabel: 'Acme Logo',
                    fit: BoxFit.contain,
                    // height: size.height * 0.3,
                  ),
                ),
              ),
              Container(
                width: size.width * 0.95,
                height: size.height * 0.6,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: Form(
                      child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 20,
                          ),
                          suffixIcon: GestureDetector(
                              child: _obscureText
                                  ? Icon(Feather.eye)
                                  : Icon(Feather.eye_off),
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              }),
                        ),
                        obscureText: _obscureText,
                      ),
                      SizedBox(height: 20),
                      /* RaisedButton(
                          child: Text('LogIn'),
                          onPressed: () => Navigator.pushReplacementNamed(
                              context, '/SetUpScreenWidget'),
                        ),*/
                      Container(
                        width: size.width * 0.6,
                        child: OutlineButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          highlightElevation: 0,
                          borderSide: BorderSide(color: Colors.grey),
                          child: Center(
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                  fontSize: 32,
                                  fontFamily: 'Nunito',
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          onPressed: () => Navigator.pushReplacementNamed(
                              context, '/SetUpScreenWidget'),
                        ),
                      ),
                      SizedBox(height: 10),
                      Divider(
                        thickness: 2,
                        indent: 10,
                        endIndent: 10,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                              image:
                                  AssetImage("assets/images/google_logo.png"),
                              height: 30.0),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            width: 2,
                            height: 35,
                            color: Colors.black12,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Image(
                              image: AssetImage("assets/images/incognito.png"),
                              height: 37.5),
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account?',
                                style: TextStyle(fontFamily: 'Nunito'),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            'Register',
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                //fontSize: 14,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Forgot Password?',
                                style: TextStyle(fontFamily: 'Nunito'),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            'Reset Password',
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                //fontSize: 14,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
