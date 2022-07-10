import 'package:flutter/material.dart';
import 'package:notification_app/constants/colors.dart';

abstract class GradientBuilder {
  static LinearGradient gradientBackground() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: <double>[0, 0.26, 0.66, 1],
      colors: <Color>[
        ColorPalette.aurora,
        ColorPalette.aurora90,
        ColorPalette.aurora50,
        ColorPalette.sunrise,
      ],
    );
  }
}
