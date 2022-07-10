import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:notification_app/my_app_config.dart';
import 'package:notification_app/presentation/widgets/builders/gradient_builder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:notification_app/logic/bloc/services/services_bloc.dart';
import 'package:notification_app/presentation/screens/login_screen.dart';
import 'package:notification_app/presentation/wrappers/dismiss_keyboard.dart';
import 'package:notification_app/presentation/wrappers/global_providers_bag.dart';
import 'package:notification_app/services/local_storage_service.dart';
import 'package:notification_app/services/navigation_service.dart';
import 'package:notification_app/utils/route_observer_util.dart';

import 'constants/theme.dart';
import 'presentation/router/app_router.dart';

class MyApp extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();
  static final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static const List<Locale> supportedLocales = const <Locale>[
    Locale('en', ''),
  ];

  static const List<LocalizationsDelegate<dynamic>> delegates =
      const <LocalizationsDelegate<dynamic>>[
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  @override
  Widget build(BuildContext context) {
    final MyAppConfig config = MyAppConfig.of(context)!;
    return DismissKeyboardWrapper(
      child: MaterialApp(
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        debugShowCheckedModeBanner: config.debugTag,
        theme: baseThemeData,
        themeMode: config.themeMode,
        localizationsDelegates: delegates,
        supportedLocales: supportedLocales,
        onGenerateRoute: _appRouter.onGenerateRoute,
        navigatorObservers: <NavigatorObserver>[routeObserver],
        navigatorKey: NavigationService.navigationKey,
        home: _appHomeScreen(),
        builder: (BuildContext context, Widget? child) =>
            _appBuilder(context, child),
      ),
    );
  }

  Widget _appHomeScreen() {
    return LoginScreen();
  }

  Widget _appBuilder(BuildContext context, Widget? child) {
    return child!;
  }

  static void initSystemDefault() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
  }

  static Widget runWidget() {
    return GlobalProvidersBag(
      child: Builder(
        builder: (BuildContext context) => _buildAppWithServices(
          BlocProvider.of<ServicesBloc>(context),
        ),
      ),
    );
  }

  static Widget _buildAppWithServices(ServicesBloc servicesBloc) {
    return FutureBuilder<dynamic>(
      future: _initServices(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          servicesBloc.add(ServicesInitialized());

          return GlobalProvidersBag(
            child: MyApp(),
          );
        }

        return MaterialApp(
          home: Container(
            decoration:
                BoxDecoration(gradient: GradientBuilder.gradientBackground()),
          ),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }

  static Future<dynamic> _initServices() async {
    await Future.wait(<Future<dynamic>>[
      dotenv.load(fileName: '.env'),
      _initStorage(),
    ]);
  }

  static Future<dynamic> _initStorage() async {
    if (!kIsWeb) {
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: await getApplicationDocumentsDirectory(),
      );
      await LocalStorage().init();
    }
  }

}
