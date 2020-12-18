import 'package:firebase_chat_app/helpers/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Text(
      'Flutter Devs',
      style: appbarTextStyle(),
    ),
    elevation: 0.0,
    centerTitle: false,
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: hintTextStyle(),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: ColorTheme.primaryColor,
        width: 0.5,
      ),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: ColorTheme.primaryColor,
        width: 0.5,
      ),
    ),
  );
}

TextStyle appbarTextStyle() {
  return GoogleFonts.redHatDisplay(color: ColorTheme.white, fontSize: 25.0);
}

TextStyle simpleTextStyle() {
  return TextStyle(color: ColorTheme.darkGrey, fontSize: 16.0);
}

TextStyle hintTextStyle() {
  return TextStyle(color: ColorTheme.darkerGrey, fontSize: 16.0);
}

TextStyle solidButtonTextStyle() {
  return TextStyle(color: ColorTheme.white, fontSize: 16.0);
}

TextStyle outlineButtonTextStyle() {
  return TextStyle(color: ColorTheme.primaryColor, fontSize: 16.0);
}

TextStyle messageDateTextStyle() {
  return TextStyle(
    fontSize: ScreenUtil().setSp(12.0),
    color: Colors.grey,
  );
}

TextStyle messageSentByTextStyle() {
  return TextStyle(
    fontSize: ScreenUtil().setSp(12.0),
    color: Colors.grey,
  );
}
