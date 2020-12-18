import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_chat_app/helpers/app_fonts.dart';
import 'package:firebase_chat_app/helpers/authentication_helper.dart';
import 'package:firebase_chat_app/helpers/app_utils.dart';
import 'package:firebase_chat_app/helpers/color_theme.dart';
import 'package:firebase_chat_app/pages/chat_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await AppUtils.getUserLoggedIn().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromRGBO(7, 94, 84, 1.0),
        secondaryHeaderColor: Color.fromRGBO(37, 211, 102, 1.0),
        highlightColor: Color.fromRGBO(18, 140, 126, 1.0),
        cardColor: Color.fromRGBO(250, 250, 250, 1.0),
        accentColor: Color.fromRGBO(236, 229, 221, 1.0),
        textTheme: TextTheme(
          bodyText1: TextStyle(
              color: ColorTheme.darkGrey, fontSize: AppFonts.textSize14),
          subtitle1: TextStyle(
              color: ColorTheme.darkGrey, fontSize: AppFonts.textSize12),
        ),
      ),
      home: userIsLoggedIn != null
          ? userIsLoggedIn
              ? ChatPage()
              : AuthenticationHelper()
          : Container(
              child: Center(
                child: AuthenticationHelper(),
              ),
            ),
    );
  }
}
