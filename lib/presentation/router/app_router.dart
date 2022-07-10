import 'package:flutter/material.dart';
import 'package:notification_app/presentation/screens/login_screen.dart';

class AppRouter {
  static const String root = '/';
  static const String home = '/home';
  static const String login = '/login';


  MaterialPageRoute<Widget> onGenerateRoute(dynamic settings) {
    return MaterialPageRoute<LoginScreen>(
      builder: (BuildContext context) => LoginScreen(),
    );
  }
}
