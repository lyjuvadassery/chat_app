import 'package:firebase_chat_app/helpers/color_theme.dart';
import 'package:firebase_chat_app/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppUtils {
  AppUtils._();
  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferenceUserNameKey = "USERNAMEKEY";
  static String sharedPreferenceUserEmailKey = "USEREMAILKEY";

  static Future<bool> saveUserLoggedIn(bool isUserLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(
        sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserName(String userName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceUserNameKey, userName);
  }

  static Future<bool> saveUserEmail(String userEmail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceUserEmailKey, userEmail);
  }

  static Future<bool> getUserLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(sharedPreferenceUserLoggedInKey);
  }

  static Future<String> getUserName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserNameKey);
  }

  static showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 4,
      backgroundColor: ColorTheme.black,
      textColor: ColorTheme.white,
      fontSize: 16.0,
    );
  }

  static Future<bool> showYesOrNoAlertDialog({
    @required BuildContext context,
    @required String alertDialogTitle,
    String alertDialogMessage,
    Widget alertDialogWidget,
    bool isReturnWidget = false,
  }) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            alertDialogTitle,
            style: TextStyle(
              color: ColorTheme.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          content: (alertDialogMessage != null)
              ? Text(
                  alertDialogMessage,
                  style: TextStyle(
                    color: ColorTheme.darkGrey,
                    fontSize: 16.0,
                  ),
                )
              : alertDialogWidget,
          actions: <Widget>[
            FlatButton(
              child: const Text('NO'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
              child: const Text('YES'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }

  // processRawMessages() adds date markers between messages.
  static List<dynamic> processRawMessages(List<MessageModel> rawMessages) {
    List<dynamic> messagesWithDateMarkers = [];

    String dateOfPreviousMessage =
        DateFormat('dd-MMM-yyyy').format(rawMessages[0].time.toLocal());

    if (dateOfPreviousMessage ==
        DateFormat('dd-MMM-yyyy').format(DateTime.now().toLocal()))
      dateOfPreviousMessage = 'Today';

    messagesWithDateMarkers.add(dateOfPreviousMessage);

    for (int i = 0; i < rawMessages.length; i++) {
      String dateOfMessage =
          DateFormat('dd-MMM-yyyy').format(rawMessages[i].time.toLocal());

      if (dateOfMessage ==
          DateFormat('dd-MMM-yyyy').format(DateTime.now().toLocal()))
        dateOfMessage = 'Today';

      if (dateOfMessage != dateOfPreviousMessage) {
        messagesWithDateMarkers.add(dateOfMessage);
        dateOfPreviousMessage = dateOfMessage;
      }

      messagesWithDateMarkers.add(rawMessages[i]);
    }

    print('messagesWithDateMarkers');

    messagesWithDateMarkers.forEach((element) {
      print(element.runtimeType);
    });

    return messagesWithDateMarkers;
  }
}
