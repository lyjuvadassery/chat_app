import 'package:firebase_chat_app/helpers/app_utils.dart';
import 'package:firebase_chat_app/helpers/color_theme.dart';
import 'package:firebase_chat_app/pages/chat_page.dart';
import 'package:firebase_chat_app/services/auth_service.dart';
import 'package:firebase_chat_app/services/database_service.dart';
import 'package:firebase_chat_app/pages/forgot_password_page.dart';
import 'package:firebase_chat_app/widgets/common_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function toggleView;

  LoginPage(this.toggleView);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailFieldController = TextEditingController();
  TextEditingController _passwordFieldController = TextEditingController();

  AuthService _authService = AuthService();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void dispose() {
    _emailFieldController.dispose();
    _passwordFieldController.dispose();
    super.dispose();
  }

  _logInWithEmailAndPassword() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await _authService
          .signInWithEmailAndPassword(_emailFieldController.text.trim(),
              _passwordFieldController.text.trim())
          .then((result) async {
        if (result != null) {
          QuerySnapshot userInfoSnapshot = await DatabaseService()
              .getUserInfo(_emailFieldController.text.trim());

          AppUtils.saveUserLoggedIn(true);
          AppUtils.saveUserName(userInfoSnapshot.docs[0].data()["userName"]);
          AppUtils.saveUserEmail(userInfoSnapshot.docs[0].data()["userEmail"]);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatPage()));
        } else {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  _logInWithFacebook() async {
    await _authService.signInWithFacebook(context).then((result) async {
      if (result != null) {
        AppUtils.saveUserLoggedIn(true);
        AppUtils.saveUserName(result.displayName);
        AppUtils.saveUserEmail(result.displayName);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatPage()));
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              // color: Colors.red[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Spacer(),
                  Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          validator: (value) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)
                                ? null
                                : "Enter a valid email address";
                          },
                          controller: _emailFieldController,
                          style: simpleTextStyle(),
                          cursorColor: ColorTheme.darkGrey,
                          decoration: textFieldInputDecoration("Email Address"),
                        ),
                        TextFormField(
                          obscureText: true,
                          style: simpleTextStyle(),
                          controller: _passwordFieldController,
                          cursorColor: ColorTheme.darkGrey,
                          decoration: textFieldInputDecoration("Password"),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // First, log out the user if he's logged in.
                          _authService.signOut();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage(),
                            ),
                          );
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              "Forgot Password?",
                              style: simpleTextStyle(),
                            )),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: _logInWithEmailAndPassword,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: ColorTheme.primaryColor,
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Log In",
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
                    onTap: _logInWithFacebook,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorTheme.primaryColor,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.white,
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Log In with Facebook",
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
                        "Don't have an account? ",
                        style: simpleTextStyle(),
                      ),
                      GestureDetector(
                        onTap: widget.toggleView,
                        child: Text(
                          "Register now",
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
  }
}
