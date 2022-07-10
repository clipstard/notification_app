import 'package:flutter/material.dart';
import 'package:notification_app/presentation/screens/access_blocked_customer_screen.dart';
import 'package:notification_app/presentation/screens/contact_screen.dart';
import 'package:notification_app/presentation/screens/faq_screen.dart';
import 'package:notification_app/presentation/screens/home_screen.dart';
import 'package:notification_app/presentation/screens/intro_screen.dart';
import 'package:notification_app/presentation/screens/login_screen.dart';
import 'package:notification_app/presentation/screens/msisdn_screen.dart';
import 'package:notification_app/presentation/screens/privacy_policy_screen.dart';
import 'package:notification_app/presentation/screens/reset_password_msisdn_screen.dart';
import 'package:notification_app/presentation/screens/setup_biometric_id_screen.dart';
import 'package:notification_app/presentation/screens/setup_push_notifications_screen.dart';
import 'package:notification_app/presentation/screens/splash_screen.dart';
import 'package:notification_app/presentation/screens/terms_and_conditions_screen.dart';

class AppRouter {
  static const String root = '/';
  static const String home = '/home';
  static const String splashScreen = '/splash';
  static const String login = '/login';
  static const String msisdn = '/signup/msisdn';
  static const String otp = '/signup/otp';
  static const String terms = '/signup/terms';
  static const String privacyPolicy = '/signup/privacyPolicy';
  static const String details = '/signup/details';
  static const String faq = '/faq';
  static const String contact = '/contact';
  static const String resetPasswordMsisdn = '/resetPasswordMsisdn';
  static const String setupBiometricId = '/setupBiometricId';
  static const String setupPushNotifications = '/setupPushNotifications';
  static const String loyaltyUnreachable = '/loyaltyUnreachable';

  MaterialPageRoute<Widget> onGenerateRoute(dynamic settings) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute<SplashScreen>(
          builder: (BuildContext context) => SplashScreen(),
        );

      case msisdn:
        return MaterialPageRoute<MsisdnScreen>(
          builder: (BuildContext context) => MsisdnScreen(),
        );

      case terms:
        return MaterialPageRoute<TermsAndConditions>(
          builder: (BuildContext context) => TermsAndConditions(),
        );

      case privacyPolicy:
        return MaterialPageRoute<PrivacyPolicy>(
          builder: (BuildContext context) => PrivacyPolicy(),
        );

      case resetPasswordMsisdn:
        return MaterialPageRoute<ResetPasswordMsisdnScreen>(
          builder: (BuildContext context) => ResetPasswordMsisdnScreen(),
        );

      case setupBiometricId:
        final SetupBiometricIdArguments args =
            settings.arguments as SetupBiometricIdArguments;

        return MaterialPageRoute<SetupBiometricIdScreen>(
          builder: (BuildContext context) =>
              SetupBiometricIdScreen(args.biometricId),
        );

      case setupPushNotifications:
        return MaterialPageRoute<SetupPushNotifications>(
          builder: (BuildContext context) => SetupPushNotifications(),
        );

      case login:
        return MaterialPageRoute<LoginScreen>(
          builder: (BuildContext context) => LoginScreen(),
        );

      case faq:
        return MaterialPageRoute<FAQScreen>(
          builder: (BuildContext context) => FAQScreen(),
        );

      case contact:
        return MaterialPageRoute<ContactScreen>(
          builder: (BuildContext context) => ContactScreen(),
        );

      case root:
      case home:
        return MaterialPageRoute<HomeScreen>(
          builder: (BuildContext context) => HomeScreen(),
        );

      case loyaltyUnreachable:
        return MaterialPageRoute<AccessBlockedCustomerScreen>(
          builder: (BuildContext context) => AccessBlockedCustomerScreen(),
        );

      default:
        return MaterialPageRoute<IntroScreen>(
          builder: (BuildContext context) => IntroScreen(),
        );
    }
  }
}
