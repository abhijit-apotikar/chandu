import 'dart:ui';

import 'package:flutter/material.dart';

class TermsAndConditionsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: new Text(
          'Terms & Conditions',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: new IconThemeData(
          size: 20,
          color: Colors.white,
        ),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '1) By agreeing to this T&C\'s, You agree to let us identify you with your email.',
                  style: TextStyle(fontFamily: 'Nunito'),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '2) By agreeing to this T&C\'s, You agree to recieve any account related correspondence emails.',
                  style: TextStyle(fontFamily: 'Nunito'),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '3) By agreeing to this T&C\'s, You declare that you by your own will is sharing your email with us.',
                  style: TextStyle(fontFamily: 'Nunito'),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '4) By agreeing to this T&C\'s, You agree that you will not decompile, reverse-engineer or in any way mess up with this application\'s source code.',
                  style: TextStyle(fontFamily: 'Nunito'),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '5) By agreeing to this T&C\'s, You take the whole responsibility for installing & running this application on your device and the consequences that may arise therein.',
                  style: TextStyle(fontFamily: 'Nunito'),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '6) By agreeing to this T&C\'s, You declare that you are fully aware of the fact that whatever the information is presented to you with this application\'s aide is correct to the best of the developer\'s knowledge and will not be liable for scrutiny and the developer will in no way be held responsible for any error or incorrectness or ill consequences that may arise henceforth. ',
                  style: TextStyle(fontFamily: 'Nunito'),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '7) By agreeing to this T&C\'s, You declare that you know and you agree to the condition that the developer can delete my account with this app at any moment of time without any prior notice. ',
                  style: TextStyle(fontFamily: 'Nunito'),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '8) By agreeing to this T&C\'s, You declare that you know and you agree that the use of this application for any commercial activity is strictly prohibited and you will only use this application for personal use only. ',
                  style: TextStyle(fontFamily: 'Nunito'),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '* ',
                      style: TextStyle(fontFamily: 'Nunito'),
                    ),
                    Text('T&C',
                        style: TextStyle(
                            fontFamily: 'Nunito', fontWeight: FontWeight.bold)),
                    Text(' stands as Terms&Conditions',
                        style: TextStyle(fontFamily: 'Nunito')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
