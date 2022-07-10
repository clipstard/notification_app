import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notification_app/localization.dart';
import 'package:notification_app/logic/bloc/auth/authentication_bloc.dart';
import 'package:notification_app/presentation/router/route_builder.dart';
import 'package:notification_app/presentation/screens/unregister_screen.dart';
import 'package:notification_app/presentation/screens/faq_screen.dart';
import 'package:notification_app/presentation/screens/privacy_policy_screen.dart';
import 'package:notification_app/presentation/screens/terms_and_conditions_screen.dart';
import 'package:notification_app/presentation/widgets/heading.dart';
import 'package:notification_app/presentation/widgets/link.dart';

class UsefullLinks extends StatelessWidget {
  UsefullLinks({
    required this.activeScreen,
    Key? key,
  }) : super(key: key);

  final Widget activeScreen;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations _translate = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Heading(
            _translate.useful_links,
            type: HeadingType.h2,
          ),
          _logout(context),
          SizedBox(height: 10),
          _buildLink(context, _translate.our_terms, TermsAndConditions()),
          SizedBox(height: 10),
          _buildLink(context, _translate.privacy_notice, PrivacyPolicy()),
          SizedBox(height: 10),
          _buildLink(context, _translate.faqs, FAQScreen()),
          SizedBox(height: 10),
          _buildLink(
              context, _translate.unregister_from_three, UnregisterScreen()),
        ],
      ),
    );
  }

  Widget _logout(BuildContext context) {
    return Link(
      AppLocalizations.of(context)!.log_out,
      onTap: () {
        context.read<AuthenticationBloc>().add(AuthenticationLogoutRequested());
      },
    );
  }

  Widget _buildLink(BuildContext context, String label, Widget nextScreen) {
    return Link(
      label,
      onTap: () {
        Navigator.of(context).push(
          RouteBuilder<dynamic>(
            active: activeScreen,
            next: nextScreen,
          ),
        );
      },
    );
  }
}
