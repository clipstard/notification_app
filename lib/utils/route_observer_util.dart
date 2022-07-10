import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notification_app/presentation/router/route_builder.dart';
import 'package:notification_app/my_app.dart';

final ThreeNavigationObserver<ModalRoute<void>> routeObserver =
    ThreeNavigationObserver<ModalRoute<void>>();

final List<String> routesStack = <String>[];

class ThreeNavigationObserver<R extends Route<dynamic>>
    extends RouteObserver<R> {
  ThreeNavigationObserver() {
    navigatorObserver().listen((_) {});
  }

  List<String> get stack {
    return routesStack;
  }

  final StreamController<Route<dynamic>> _navigationSubject =
      StreamController<Route<dynamic>>();

  Stream<Route<dynamic>> navigatorObserver() async* {
    yield* _navigationSubject.stream.asyncMap((Route<dynamic> event) async {
      return event;
    });
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushStack(route);
    _navigationSubject.add(route);

    clearSnackBars();
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    routesStack.removeLast();

    clearSnackBars();
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    routesStack.removeLast();
    _navigationSubject.add(newRoute!);
    pushStack(newRoute);

    clearSnackBars();
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  void clearSnackBars() {
    ScaffoldMessengerState? _scaffoldState =
        MyApp.rootScaffoldMessengerKey.currentState;

    if (_scaffoldState != null) {
      _scaffoldState.clearSnackBars();
    }
  }

  void pushStack(Route<dynamic>? route) {
    if (route is RouteBuilder) {
      routesStack.add(route.name);
    } else {
      routesStack.add(route?.settings.name ?? 'unknown');
    }
  }
}
