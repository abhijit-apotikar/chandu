import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:oktoast/oktoast.dart';

//-------------- my packages ----------------------------------
import '../services/authService.dart';
import '../services/connectivityCheckUpService.dart';
import '../widgets/loadingWidget.dart';
import '../shared/constants.dart';

class RegisterWidget extends StatefulWidget {
  @override
  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  bool loading = false;
  bool _agreedToTerms = false;
  bool _consent = true;
  final _formKey = GlobalKey<FormState>();
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  ///------------textField e-mail,password local variables--------
  String email = '';
  String password = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    final AuthService _auth = new AuthService();
    final ConnectivityCheckUpService _cCService =
        new ConnectivityCheckUpService();
    // final userIdStatus = Provider.of<UserIdStatus>(context);
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
                color: Colors.white,
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
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
                          SizedBox(height: 10),
                          TextFormField(
                            style: myTextFormFieldTextStyle,
                            decoration: textFormFieldDecoration.copyWith(
                              hintText: 'Enter a Password',
                              suffixIcon: GestureDetector(
                                  child: _obscureText1
                                      ? Icon(Feather.eye)
                                      : Icon(Feather.eye_off),
                                  onTap: () {
                                    setState(() {
                                      _obscureText1 = !_obscureText1;
                                    });
                                  }),
                            ),
                            validator: (val) => val.length < 6
                                ? 'Password must be atleast 6 characters long'
                                : (val.contains(new RegExp(r'[A-Z]'))
                                    ? (val.contains(new RegExp(r'[a-z]'))
                                        ? (val.contains(new RegExp(r'[0-9]'))
                                            ? (val.contains(new RegExp(
                                                    r'[@&%=\$+\-_^\.;:]'))
                                                ? null
                                                : 'Password must contain atleast one from @&%=\$+\-_^\.;:')
                                            : 'Password must contain atleast 1 number')
                                        : 'Password must contain atleast 1 small letter')
                                    : 'Password must contain atleast 1 capital letter'),
                            obscureText: _obscureText1,
                            onChanged: (val) {
                              password = val;
                            },
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            style: myTextFormFieldTextStyle,
                            decoration: textFormFieldDecoration.copyWith(
                              hintText: 'Confirm Password',
                              suffixIcon: GestureDetector(
                                  child: _obscureText2
                                      ? Icon(Feather.eye)
                                      : Icon(Feather.eye_off),
                                  onTap: () {
                                    setState(() {
                                      _obscureText2 = !_obscureText2;
                                    });
                                  }),
                            ),
                            validator: (val) => (val != password)
                                ? 'Passwords don\'t match'
                                : (val.length < 6
                                    ? 'Password must be confirmed'
                                    : null),
                            obscureText: _obscureText2,
                            onChanged: (val) {
                              password = val;
                            },
                          ),
                          SizedBox(
                            height: 10.0,
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  ' Read our ',
                                  style: TextStyle(fontFamily: 'Nunito'),
                                ),
                                GestureDetector(
                                  child: Text(
                                    ' Terms & Conditions ',
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed('/TermsAndConditionsWidget');
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
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
                                  _consent = true;
                                });
                              } else if (_agreedToTerms = true) {
                                setState(() {
                                  _agreedToTerms = false;
                                  _consent = false;
                                });
                              }
                            },
                            subtitle: _consent
                                ? null
                                : Padding(
                                    padding: EdgeInsets.fromLTRB(12.0, 0, 0, 0),
                                    child: Text(
                                      'You need to agree to the Terms & Conditions before proceeding.',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                          fontFamily: 'Nunito'),
                                    ),
                                  ),
                          ),
                          SizedBox(height: 10),
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
                                  var connectivityResult =
                                      await _cCService.checkConnectivity();
                                  if (connectivityResult) {
                                    dynamic result = await _auth
                                        .registerWithEmailAndPassword(
                                            email, password);

                                    if (result == '101') {
                                      setState(() {
                                        loading = false;
                                        showToast(
                                            ' Email already registered with some other account. ',
                                            textStyle:
                                                TextStyle(fontFamily: 'Nunito'),
                                            position: ToastPosition.bottom);
                                      });
                                    } else if (result == '102') {
                                      setState(() {
                                        loading = false;
                                        showToast(
                                            ' Email appears to be malformed. ',
                                            textStyle:
                                                TextStyle(fontFamily: 'Nunito'),
                                            position: ToastPosition.bottom);
                                      });
                                    } else {
                                      Navigator.pop(context);
                                      showToast(' Registered successfuly. ',
                                          textStyle:
                                              TextStyle(fontFamily: 'Nunito'),
                                          position: ToastPosition.bottom);
                                    }
                                  } else {
                                    setState(() {
                                      loading = false;
                                    });
                                    showToast(
                                        ' Internet connection not available. ',
                                        textStyle:
                                            TextStyle(fontFamily: 'Nunito'),
                                        position: ToastPosition.bottom);
                                  }
                                } else if (_agreedToTerms == false) {
                                  setState(() {
                                    _consent = false;
                                  });
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
