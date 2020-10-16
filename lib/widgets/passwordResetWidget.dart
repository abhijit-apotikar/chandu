import 'package:flutter/material.dart';

import '../shared/constants.dart';
import '../services/authService.dart';
import '../widgets/loadingWidget.dart';

class PasswordResetWidget extends StatefulWidget {
  @override
  _PasswordResetWidgetState createState() => _PasswordResetWidgetState();
}

class _PasswordResetWidgetState extends State<PasswordResetWidget> {
  final _formKey = GlobalKey<FormState>();
  String email;
  bool isLoading = false;
  bool linkSent = false;
  @override
  Widget build(BuildContext context) {
    final AuthService _authService = new AuthService();
    return isLoading
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
                'Password Reset',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              iconTheme: new IconThemeData(
                size: 20,
                color: Colors.white,
              ),
            ),
            body: linkSent
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_box,size: 28,color: Colors.green,),
                            Text(
                              'Link Sent',
                              style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'We have sent you an email containing the password reset link. Check your email and reset the password using the link. Sometimes it may take 5-10 minutes to receive the email. Be patient.',
                          style: TextStyle(fontFamily: 'Nunito'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Even after waiting for 5-10 minutes if you didn\'t receive the email at all, then you can always repeat the entire process by going back to the login screen.',
                          style: TextStyle(fontFamily: 'Nunito'),
                        ),
                      ),
                    ],
                  )
                : Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Enter the email associated with the account you want to reset password for in the below textfield and then press on the \'Send password reset link\' button. Sometimes it may take you 5-10 minutes to receive the email. Be patient.',
                              style: TextStyle(fontFamily: 'Nunito'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            style: myTextFormFieldTextStyle,
                            decoration: textFormFieldDecoration.copyWith(
                                hintText: 'Enter email'),
                            validator: (val) => val.isEmpty
                                ? 'Enter an e-mail'
                                : (val.contains('@')
                                    ? null
                                    : 'Password is not correctly formatted'),
                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RaisedButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                var result = await _authService
                                    .requestPasswordReset(email.toLowerCase());
                                if (result == true) {
                                  setState(() {
                                    isLoading = false;
                                    linkSent = true;
                                  });
                                }
                              }
                            },
                            child: Text('Send password reset link',
                                style: TextStyle(fontFamily: 'Nunito'))),
                      ],
                    ),
                  ),
          );
  }
}
