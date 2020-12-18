import 'package:flutter/material.dart';

class ColorTheme {
  ColorTheme._();

  static MaterialColor get primarySwatch {
    return MaterialColor(0xffF0674C, customColor);
  }

  static Map<int, Color> customColor = {
    50: Color.fromRGBO(240, 103, 76, .1),
    100: Color.fromRGBO(240, 103, 76, .2),
    200: Color.fromRGBO(240, 103, 76, .3),
    300: Color.fromRGBO(240, 103, 76, .4),
    400: Color.fromRGBO(240, 103, 76, .5),
    500: Color.fromRGBO(240, 103, 76, .6),
    600: Color.fromRGBO(240, 103, 76, .7),
    700: Color.fromRGBO(240, 103, 76, .8),
    800: Color.fromRGBO(240, 103, 76, .9),
    900: Color.fromRGBO(240, 103, 76, 1),
  };

  static Color get primaryColor {
    return Color.fromRGBO(7, 94, 84, 1.0);
  }

  static Color get secondaryColor {
    return Color.fromRGBO(37, 211, 102, 1.0);
  }

  static Color get highlightColor {
    return Color.fromRGBO(18, 140, 126, 1.0);
  }

  static Color get cardColor {
    return Color.fromRGBO(250, 250, 250, 1.0);
  }

  static Color get accentColor {
    return Color.fromRGBO(236, 229, 221, 1.0);
  }

  static Color get darkGrey {
    return Color(0xFF666666);
  }

  static Color get lightGrey {
    return Color(0xFFf5f5f5);
  }

  static Color get darkerGrey {
    return Color(0xFF999999);
  }

  static Color get backgroundGreen {
    return Colors.lime[50];
  }

  static Color get fieldBorderGrey {
    return Color(0xFFE3E3E3);
  }

  static Color get white {
    return Colors.white;
  }

  static Color get black {
    return Colors.black;
  }

  static Color get lightGreen {
    return Color(0xffADE1C2);
  }

  static Color get green {
    return Color(0xff19AC53);
  }

  static Color get red {
    return Colors.redAccent;
  }
}
