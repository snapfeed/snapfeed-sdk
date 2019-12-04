import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SnapfeedTheme {
  SnapfeedTheme._();

  static const white = Color(0xFFFFFFFF);
  static const lightGrey = Color(0xFFF1F1F1);
  static const grey = Color(0xFFB4B4B4);
  static const darkGrey = Color(0xFF4D4D4D);

  static const purple = Color(0xFF7F1CF8);

  static const penColors = [
    Color(0xff483e39),
    Color(0xffdbd4d1),
    Color(0xff14e9d0),
    Color(0xffe96115),
  ];

  static const cardTitle = TextStyle(
      package: 'snapfeed',
      fontFamily: 'Poppins',
      fontSize: 16,
      fontWeight: FontWeight.w500);

  static const cardContent =
      TextStyle(package: 'snapfeed', fontFamily: 'Poppins', fontSize: 12);

  static const cardFeedback = TextStyle(
      package: 'snapfeed',
      fontFamily: 'Poppins',
      fontSize: 14,
      color: darkGrey);

  static const drawerTitle = TextStyle(
      package: 'snapfeed',
      fontFamily: 'Poppins',
      fontSize: 20,
      fontWeight: FontWeight.w500);

  static const button = TextStyle(
      package: 'snapfeed',
      fontFamily: 'Poppins',
      fontSize: 14,
      color: Colors.blue);
}
