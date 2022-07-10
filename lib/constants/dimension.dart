import 'package:flutter/material.dart';

class Dimension {
  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  Dimension._();

  /// Spacings
  static const double spacer = 20.0;
  static const double xAxisPadding = 20;
  static const double yAxisPadding = 20;

  static const double inputHeight = 50;

  /// SplashScreen
  ///
  /// [238x51] This sizes are used for IOS LaunchScreen.storyboard
  /// Do not forget to cahnge them, in case you'r changing sizes here
  /// to avoid rezising logo effect during transition between native
  /// launch screen and flutter custom splashscreen
  static const Size splashScreenLogoSize = Size(238.0, 51.0);

  /// App bar dimensions
  static const double appBarToolbarHeight = 30;
  static const double appBarBottomHeight = 30;
  static const double appBarLogoHeight = 21;
  static const double appBarHeight = 76;
}
