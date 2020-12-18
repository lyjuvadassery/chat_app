import 'package:firebase_chat_app/pages/chat_page.dart';
import 'package:firebase_chat_app/services/auth_service.dart';
import 'package:firebase_chat_app/services/database_service.dart';
import 'package:firebase_chat_app/helpers/app_utils.dart';
import 'package:firebase_chat_app/helpers/color_theme.dart';
import 'package:firebase_chat_app/widgets/common_widgets.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final Function toggleView;
  RegisterPage(this.toggleView);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _usernameFieldController = TextEditingController();
  TextEditingController _emailFieldController = TextEditingController();
  TextEditingController _passwordFieldController = TextEditingController();

  AuthService _authService = AuthService();
  DatabaseService _databaseService = DatabaseService();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameFieldController.dispose();
    _emailFieldController.dispose();
    _passwordFieldController.dispose();
    super.dispose();
  }

  _registerWithEmailAndPassword() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      await _authService
          .signUpWithEmailAndPassword(_emailFieldController.text.trim(),
              _passwordFieldController.text.trim())
          .then((result) {
        if (result != null) {
          Map<String, String> userDataMap = {
            "userName": _usernameFieldController.text.trim(),
            "userEmail": _emailFieldController.text.trim()
          };

          _databaseService.addUserInfo(userDataMap);

          AppUtils.saveUserLoggedIn(true);
          AppUtils.saveUserName(_usernameFieldController.text.trim());
          AppUtils.saveUserEmail(_emailFieldController.text.trim());

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatPage()));
        }
      });
    }
  }

  _registerWithFacebook() async {
    await _authService.signInWithFacebook(context).then((result) {
      if (result != null) {
        Map<String, String> userDataMap = {
          "userName": result.displayName,
          "userEmail": result.displayName,
        };

        _databaseService.addUserInfo(userDataMap);

        AppUtils.saveUserLoggedIn(true);
        AppUtils.saveUserName(result.displayName);
        AppUtils.saveUserEmail(result.displayName);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: _isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Spacer(),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          style: simpleTextStyle(),
                          controller: _usernameFieldController,
                          validator: (value) {
                            return value.isEmpty || value.length < 3
                                ? "Username must be more than 3 characters"
                                : null;
                          },
                          cursorColor: ColorTheme.darkGrey,
                          decoration: textFieldInputDecoration("Username"),
                        ),
                        TextFormField(
                          controller: _emailFieldController,
                          style: simpleTextStyle(),
                          validator: (value) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)
                                ? null
                                : "Enter a valid email address";
                          },
                          cursorColor: ColorTheme.darkGrey,
                          decoration: textFieldInputDecoration("Email address"),
                        ),
                        TextFormField(
                          obscureText: true,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration("Password"),
                          controller: _passwordFieldController,
                          cursorColor: ColorTheme.darkGrey,
                          validator: (val) {
                            return val.length < 6
                                ? "Password must be at least 6 characters"
                                : null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: _registerWithEmailAndPassword,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: ColorTheme.primaryColor,
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        'Register',
                        style: solidButtonTextStyle(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    'Or',
                    style: simpleTextStyle(),
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  InkWell(
                    onTap: _registerWithFacebook,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorTheme.primaryColor,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Register with Facebook",
                        style: outlineButtonTextStyle(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: simpleTextStyle(),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.toggleView();
                        },
                        child: Text(
                          "Log In",
                          style: TextStyle(
                            color: ColorTheme.highlightColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
    );
    ;
  }
}
