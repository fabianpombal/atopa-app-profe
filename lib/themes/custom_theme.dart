import 'package:flutter/material.dart';

class CustomTheme {
  static const Color atopaBlue = Color.fromRGBO(13, 96, 254, 1);
  static const Color atopaBlueLight = Color.fromRGBO(179, 226, 255, 1);
  static const Color atopaBlueDark = Color.fromRGBO(24, 39, 102, 1);

  static const Color whiteTrans = Colors.white12;

  static const Color atopaGreyDark = Color.fromRGBO(113, 114, 117, 1);
  static const Color atopaGrey = Color.fromRGBO(195, 203, 219, 1);
  static const Color atopaGreyTrans = Color.fromRGBO(195, 203, 219, 150);

  static const Color atopaGreenDark = Color.fromRGBO(11, 86, 87, 1);
  static const Color atopaGreenLight = Color.fromRGBO(89, 153, 107, 1);

  static const Color atopaYellow = Color.fromRGBO(195, 196, 98, 1);

  static const Color atopaViolet = Color.fromRGBO(118, 89, 153, 1);
  static const Color atopaPink = Color.fromRGBO(153, 89, 151, 1);

  static const Color graphYellow = Color.fromRGBO(214, 194, 43, 1);
  static const Color graphGreen = Color.fromRGBO(13, 168, 99, 1);
  static const Color graphPink = Color.fromRGBO(224, 90, 184, 1);
  static const Color graphBlue = Color.fromRGBO(52, 155, 235, 1);
  static const Color graphRed = Color.fromRGBO(237, 62, 70, 1);
  static const Color graphOrange = Color.fromRGBO(235, 128, 52, 1);
  static const Color graphViolet = Color.fromRGBO(150, 70, 224, 1);
  

  static final ThemeData lightTheme = ThemeData.light().copyWith(
      primaryColor: atopaBlue,
      textTheme: const TextTheme(
        headline6: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),
      ),
      appBarTheme: const AppBarTheme(
        color: atopaBlue,
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
          floatingLabelStyle: TextStyle(color: atopaBlue),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: atopaBlue),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: atopaBlue),
              borderRadius: BorderRadius.all(Radius.circular(10)))),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              primary: atopaBlue, shape: const StadiumBorder(), elevation: 0)),
      bottomNavigationBarTheme:
          BottomNavigationBarThemeData(selectedItemColor: atopaBlue));
}
