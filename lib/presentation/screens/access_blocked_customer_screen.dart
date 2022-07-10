import 'package:flutter/material.dart';
import 'package:notification_app/localization.dart';
import 'package:notification_app/presentation/router/route_builder.dart';
import 'package:notification_app/presentation/screens/contact_screen.dart';
import 'package:notification_app/presentation/widgets/default_app_bar.dart';
import 'package:notification_app/presentation/widgets/heading.dart';
import 'package:notification_app/presentation/widgets/outlined_button/outlined_button.dart';
import 'package:notification_app/presentation/wrappers/scrollable_page.dart';

class AccessBlockedCustomerScreen extends StatelessWidget {
  AccessBlockedCustomerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations _translate = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: DefaultAppBar(logoTheme: LogoTheme.dark),
      body: ScrollablePage(
        bgGradient: true,
        intrinsicHeight: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Heading(
                          _translate.blocked_customer_title,
                          textAlign: TextAlign.center,
                        ),
                        Text(_translate.blocked_customer_hint),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final AppLocalizations _translate = AppLocalizations.of(context)!;

    return Column(
      children: <Widget>[
        ThreeOutlinedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              RouteBuilder<ContactScreen>(active: this, next: ContactScreen()),
            );
          },
          margin: EdgeInsets.zero,
          text: _translate.contact_us,
        ),
        SizedBox(height: 40)
      ],
    );
  }
}
