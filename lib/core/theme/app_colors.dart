import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFFF24E1E);
  static const Color secondary = Color(0xFFFFFFFF);

  // Bg

  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF000000);
  static const Color neutral800 = Color(0xFF252931);
  static const Color greyEEE = Color(0xFFEEEEEE);

  // border
  static final Color border = Color(0xFFBABDBF);

  // text
  static const Color textLabelBlack = Color(0xFF242E37);
  static const Color textBlack = Color(0xFF000000);
  static const Color textErrorRed = Color(0xFFFF0000);
  static const Color textWhite = Color(0xFFFFFFFF);

  //textField
  static const Color textFieldBlack = Color(0xFF33414E);
  static const Color textFieldHint = Color(0xFf5C6771);
  static const Color textFieldPrimaryBorder = Color(0xFfEBECED);
  static const Color textFieldFocusBorder = Color(0xFFF24E1E);
  static const Color textFieldErrorBorder = Color(0xFFF24E1E);
  static const Color textFieldDisabledBorder = Color(0xFFEBECED);

  // button
  static const Color buttonBGRed = Color(0xFFF24E1E);
  static const Color buttonBGGreen = Color(0xFF04AA02);

  static Color? get textRed => null;
}
