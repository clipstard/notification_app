import 'dart:async' show Timer;

import 'package:flutter/material.dart';
import 'package:notification_app/services/local_storage_service.dart';

class AppLifeCycleManager extends StatefulWidget {
  final bool observeIdleness;
  final Duration idleTimeout;
  final VoidCallback onIdle;
  final Widget? child;

  AppLifeCycleManager({
    required this.idleTimeout,
    required this.onIdle,
    this.observeIdleness = false,
    this.child,
    Key? key,
  }) : super(key: key);

  _AppLifeCycleManagerState createState() => _AppLifeCycleManagerState();
}

class _AppLifeCycleManagerState extends State<AppLifeCycleManager>
    with WidgetsBindingObserver {
  final LocalStorage _localStorage = LocalStorage();
  Timer? _timer;

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      if (!_localStorage.biometricLoginActivated)
        _timer = Timer(widget.idleTimeout, widget.onIdle);
    } else if (state == AppLifecycleState.resumed) {
      if (_timer != null) _timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? Container();
  }
}
