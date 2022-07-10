import 'package:flutter/material.dart';

class MyAppConfig extends InheritedWidget {
  const MyAppConfig({
    required this.appName,
    required this.debugTag,
    required this.flavorName,
    required this.initialRoute,
    required Widget child,
    this.themeMode = ThemeMode.light,
  }) : super(child: child);

  final String appName;
  final String flavorName;
  final String initialRoute;
  final ThemeMode themeMode;

  final bool debugTag;

  static MyAppConfig? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }
}
