import 'package:firebase_chat_app/pages/login_page.dart';
import 'package:firebase_chat_app/pages/register_page.dart';
import 'package:flutter/material.dart';

class AuthenticationHelper extends StatefulWidget {
  @override
  _AuthenticationHelperState createState() => _AuthenticationHelperState();
}

class _AuthenticationHelperState extends State<AuthenticationHelper> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return LoginPage(toggleView);
    } else {
      return RegisterPage(toggleView);
    }
  }
}
