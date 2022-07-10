import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_app/localization.dart';
import 'package:notification_app/logic/bloc/push_notifications/push_notifications_bloc.dart';
import 'package:notification_app/presentation/router/route_builder.dart';
import 'package:notification_app/presentation/screens/login_screen.dart';
import 'package:notification_app/presentation/screens/msisdn_screen.dart';
import 'package:notification_app/presentation/wrappers/scrollable_page.dart';
import 'package:notification_app/presentation/widgets/app_carousel.dart';
import 'package:notification_app/presentation/widgets/default_app_bar.dart';
import 'package:notification_app/presentation/widgets/outlined_button/button_theming.dart';
import 'package:notification_app/presentation/widgets/outlined_button/outlined_button.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppLocalizations _translate = AppLocalizations.of(context)!;

    List<Widget> carouselItems = List<Widget>.generate(
      3,
      (int index) => AppCarouselSlider.carouselSlide(
        context,
        mainText: _translate.intro_screen_enjoy_offers,
        descriptionText: _translate.intro_screen_welcome_loyalty,
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: DefaultAppBar(logoTheme: LogoTheme.dark),
      body: BlocListener<PushNotificationsBloc, PushNotificationsState>(
        listener: (_, __) {},
        child: ScrollablePage(
          bgGradient: true,
          intrinsicHeight: true,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: AppCarouselSlider(items: carouselItems),
                ),
              ),
              _buttonsRow(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonsRow(BuildContext context) {
    final AppLocalizations _translate = AppLocalizations.of(context)!;

    return Column(
      children: <Widget>[
        ThreeOutlinedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              RouteBuilder<MsisdnScreen>(
                active: this,
                next: MsisdnScreen(),
              ),
            );
          },
          text: _translate.sign_up,
        ),
        ThreeOutlinedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              RouteBuilder<LoginScreen>(active: this, next: LoginScreen()),
            );
          },
          buttonClassName: ButtonClassName.secondary,
          text: _translate.log_in,
          margin: EdgeInsets.zero,
        ),
      ],
    );
  }
}
