import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_app/my_app_config.dart';
import 'package:notification_app/presentation/router/app_router.dart';
import 'package:notification_app/my_app.dart';

import 'logic/bloc_observer.dart';

Future<dynamic> main() async {
  MyApp.initSystemDefault();
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();

  runApp(
    MyAppConfig(
      appName: 'Notifications app',
      debugTag: false,
      flavorName: 'prod',
      initialRoute: AppRouter.home,
      child: MyApp.runWidget(),
    ),
  );
}
