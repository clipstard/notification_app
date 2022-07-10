import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_app/presentation/widgets/heading.dart';
import 'package:notification_app/presentation/wrappers/scrollable_page.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project

    _invokeNotification();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      body: ScrollablePage(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Heading(
                'You are now subscribed to notifications',
                type: HeadingType.h4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _invokeNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
    await plugin.initialize(
        InitializationSettings(android: initializationSettingsAndroid));

    Timer(Duration(seconds: 3), () async {
      await plugin.show(
          1,
          'Task completed',
          'A student completed a task, chek out results',
          NotificationDetails(
              android: AndroidNotificationDetails('test', 'test_name')));
    });
  }
}
