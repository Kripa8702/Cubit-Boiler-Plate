import 'package:cubit_boiler_plate/theme/colors.dart';
import 'package:cubit_boiler_plate/utils/size_utils.dart';
import 'package:flutter/material.dart';

class Styles{
  static TextStyle titleLarge = TextStyle(
    fontSize: 20.fSize,
    fontWeight: FontWeight.w600,
    color: primaryTextColor,
  );
  static TextStyle titleMedium = TextStyle(
    fontSize: 18.fSize,
    fontWeight: FontWeight.w600,
      color: primaryTextColor,
  );
  static TextStyle titleSmall = TextStyle(
    fontSize: 16.fSize,
    fontWeight: FontWeight.w600,
      color: primaryTextColor
  );

  static TextStyle bodyLarge = TextStyle(
    fontSize: 16.fSize,
    fontWeight: FontWeight.w400,
      color: secondaryTextColor
  );
  static TextStyle bodyMedium = TextStyle(
    fontSize: 14.fSize,
    fontWeight: FontWeight.w400,
      color: secondaryTextColor
  );
  static TextStyle bodySmall = TextStyle(
    fontSize: 12.fSize,
    fontWeight: FontWeight.w400,
      color: secondaryTextColor
  );


  static TextStyle labelLarge = TextStyle(
    fontSize: 16.fSize,
    fontWeight: FontWeight.w600,
      color: primaryColor
  );
  static TextStyle labelMedium = TextStyle(
    fontSize: 14.fSize,
    fontWeight: FontWeight.w600,
      color: primaryColor
  );
  static TextStyle labelSmall = TextStyle(
    fontSize: 12.fSize,
    fontWeight: FontWeight.w600,
      color: primaryColor
  );
}