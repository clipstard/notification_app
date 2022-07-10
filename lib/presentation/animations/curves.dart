import 'package:flutter/animation.dart';
import 'package:flutter/physics.dart';

class UIKitSpring extends Curve {
  /// The arguments [mass], [stiffness] and [damping] must not be null.
  const UIKitSpring(
    this.mass,
    this.stiffness,
    this.damping,
  );

  final double mass;
  final double stiffness;
  final double damping;

  @override
  double transformInternal(double t) {
    final SpringSimulation simulateSpring = SpringSimulation(
      SpringDescription(
        mass: mass,
        stiffness: stiffness,
        damping: damping,
      ),
      0.0, // start
      1.0, // end
      0.0, // velocity
    );

    return simulateSpring.x(t) + t * (1 - simulateSpring.x(1.0));
  }
}
