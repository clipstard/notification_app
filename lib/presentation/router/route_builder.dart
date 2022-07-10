import 'package:flutter/material.dart';
import 'package:notification_app/constants/colors.dart';
import 'package:notification_app/constants/easing_curves.dart';

/// Default app animation for PageRouteBuilder
///
/// [active] current active screen
/// [next] next navigation screen
class RouteBuilder<T> extends PageRouteBuilder<T> {
  final Widget active;
  final Widget next;
  final String name;

  RouteBuilder({
    required this.active,
    required this.next,
    RouteSettings? settings,
  })  : this.name = T.toString(),
        super(
          settings: settings,
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              active,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              Stack(
            children: <Widget>[
              Underlay(),
              SlideTransition(
                position: new Tween<Offset>(
                  begin: Offset.zero,
                  end: const Offset(-1.0, 0.0),
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: EasingCurves.activated,
                )),
                child: active,
              ),
              SlideTransition(
                position: new Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Interval(
                    0.5,
                    1,
                    curve: EasingCurves.reactive,
                  ),
                )),
                child: next,
              )
            ],
          ),
        );

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  Duration get reverseTransitionDuration => Duration(milliseconds: 300);
}

class Underlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          color: ColorPalette.coconut,
        ),
        child: null,
      ),
    );
  }
}
