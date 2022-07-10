import 'package:flutter/material.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => navigationKey.currentState!;

  Future<dynamic> pushNamed(String routeName, Object? arguments) {
    return _navigator.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(
          String routeName, Object? arguments) async =>
      _navigator.pushReplacementNamed(
        routeName,
        arguments: arguments,
      );

  Future<dynamic> pushNamedAndRemoveUntil(
    String routeName, {
    Object? arguments,
    bool keepPreviousPages = false,
  }) async =>
      _navigator.pushNamedAndRemoveUntil(
        routeName,
        (Route<dynamic> route) => keepPreviousPages,
        arguments: arguments,
      );
}
