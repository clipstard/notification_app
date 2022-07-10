import 'package:flutter/material.dart';
import 'package:notification_app/constants/colors.dart';

abstract class BorderBuilder {
  static OutlinedBorder get outlinedButtonBorder {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  static UnderlineInputBorder inputUnderlineColoredBorder([
    Color? color = ColorPalette.liquorice,
  ]) {
    return UnderlineInputBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(1),
        bottomRight: Radius.circular(1),
      ),
      borderSide: BorderSide(
        width: 3,
        color: color!,
        style: BorderStyle.solid,
      ),
    );
  }
}
