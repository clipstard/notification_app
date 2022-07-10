import 'package:flutter/material.dart';
import 'package:notification_app/presentation/widgets/default_app_bar.dart';
import 'package:notification_app/presentation/widgets/heading.dart';
import 'package:notification_app/presentation/wrappers/scrollable_page.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: DefaultAppBar(logoTheme: LogoTheme.dark),
      body: ScrollablePage(
        bgGradient: true,
        intrinsicHeight: true,
        child: Container(
          alignment: Alignment.center,
          child: Heading('Contact us!'),
        ),
      ),
    );
  }
}
