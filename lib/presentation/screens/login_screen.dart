import 'package:flutter/material.dart';
import 'package:notification_app/data/models/persistent_login.dart';
import 'package:notification_app/localization.dart';
import 'package:notification_app/my_app.dart';
import 'package:notification_app/presentation/router/route_builder.dart';
import 'package:notification_app/presentation/screens/empty_screen.dart';
import 'package:notification_app/presentation/widgets/heading.dart';
import 'package:notification_app/presentation/widgets/link.dart';
import 'package:notification_app/presentation/wrappers/scrollable_page.dart';
import 'package:notification_app/presentation/widgets/forms/login_form.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  PersistentLogin _persistentLoginData = PersistentLogin.empty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ScrollablePage(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildScreenTitle(context),
            const SizedBox(height: 10),
            LoginForm(
              data: _persistentLoginData,
              onSubmitted: _logIn,
            ),
            _forgotPasswordLink(context),
          ],
        ),
      ),
    );
  }

  Widget _forgotPasswordLink(BuildContext context) {
    return Link(
      AppLocalizations.of(context)!.forgot_your_password,
      onTap: () {},
    );
  }

  Widget _buildScreenTitle(BuildContext context) {
    final AppLocalizations _translate = AppLocalizations.of(context)!;

    return Heading(
      (_persistentLoginData.rememberMe &&
              _persistentLoginData.firstName != null)
          ? _translate
              .login_screen_greeting(_persistentLoginData.firstName ?? '')
          : _translate.login_screen_title,
    );
  }

  void _logIn(BuildContext context, PersistentLogin formData,
      [bool shouldLogin = true]) {
    MyApp.login = formData;
    print(formData);
    Navigator.of(context).push(
      RouteBuilder<EmptyScreen>(
        active: widget,
        next: EmptyScreen(),
      ),
    );
  }
}
