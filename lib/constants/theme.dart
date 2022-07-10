import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dimension.dart';
import 'fonts.dart';
import 'colors.dart';
import 'typography.dart';

final ThemeData baseThemeData = new ThemeData(
  /// Define default color scheme.
  brightness: Brightness.light,
  primarySwatch: ColorPalette.primaryAuroraColor,
  errorColor: ColorPalette.chilli,
  accentColor: ColorPalette.liquorice,

  // Default Scaffold background color
  scaffoldBackgroundColor: ColorPalette.coconut,

  /// Define the default font family.
  fontFamily: FontFamily.defaultFontFamily,

  /// Define the default TextTheme. Use this to specify the default
  /// text styling for headlines, titles, bodies of text, and more.
  textTheme: TextTypography.defaultTextTheme,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: ColorPalette.liquorice,
    selectionColor: ColorPalette.primaryAuroraColor,
    selectionHandleColor: ColorPalette.primaryAuroraColor,
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: EdgeInsets.only(bottom: 3.0),
    enabledBorder: themeInputBorder(),
    focusedBorder: themeInputBorder(),
    errorBorder: themeInputBorder(),
    disabledBorder: themeInputBorder(),
    labelStyle: TextTypography.body_copy.copyWith(
      color: ColorPalette.thunder,
    ),
    hintStyle: TextTypography.body_copy.copyWith(
      color: ColorPalette.thunder,
    ),
    errorStyle: themeInputErrorTextStyle().copyWith(
      // This used to hide native input error message
      color: Colors.transparent,
      height: 0,
      fontSize: 0,
    ),
    alignLabelWithHint: true,
  ),

  /// Define default dividers theme.
  dividerTheme: DividerThemeData(
    color: ColorPalette.primaryDivider,
    space: Dimension.spacer * 2,
    thickness: 1,
  ),
);

UnderlineInputBorder themeInputBorder([Color? color]) {
  return UnderlineInputBorder(
    borderSide: BorderSide(
      width: 2.0,
      color: color ?? ColorPalette.liquorice,
    ),
  );
}

TextStyle themeInputErrorTextStyle() {
  return TextStyle(
    fontSize: 18.0,
    color: ColorPalette.chilli,
    height: 1.166, // 21
  );
}
