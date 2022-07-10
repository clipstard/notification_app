import 'package:flutter/animation.dart';
import 'package:notification_app/presentation/animations/curves.dart';

class EasingCurves {
  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  EasingCurves._();

  // https://zeroheight.com/3f32e30a7/p/904db7-easing-curves
  static const Curve pressed = UIKitSpring(1, 45, 0.1);
  static const Curve activated = Cubic(0.6, 0, 1, 1);
  static const Curve reactive = Cubic(0, 0, 0.3, 1);
  static const Curve choreographed = Cubic(0.4, 0, 0.2, 1);
}
