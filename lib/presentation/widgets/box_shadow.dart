import 'package:flutter/material.dart';

/// A shadow cast by a box.
///
/// [BoxShadow] can cast non-rectangular shadows if the box is non-rectangular
/// (e.g., has a border radius or a circular shape).
///
/// This class is extends BoxShadow and created in order to redefine BlutStyle.
class CustomBoxShadow extends BoxShadow {
  /// Creates a box shadow.
  ///
  /// By default, the shadow is solid black with zero [offset], [blurRadius],
  /// and [spreadRadius].
  const CustomBoxShadow({
    Color color = const Color(0xFF000000),
    Offset offset = Offset.zero,
    double blurRadius = 0.0,
    this.spreadRadius = 0.0,
    this.blurStyle = BlurStyle.normal,
  }) : super(
          color: color,
          offset: offset,
          blurRadius: blurRadius,
        );

  /// The amount the box should be inflated prior to applying the blur.
  final double spreadRadius;

  /// The type of the blur BlurStyle.
  final BlurStyle blurStyle;

  /// Create the [Paint] object that corresponds to this shadow description.
  @override
  Paint toPaint() {
    final Paint result = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(this.blurStyle, blurSigma);
    assert(() {
      if (debugDisableShadows) result.maskFilter = null;
      return true;
    }());
    return result;
  }
}
