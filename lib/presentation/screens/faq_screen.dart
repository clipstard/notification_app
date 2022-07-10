import 'package:flutter/material.dart';
import 'package:notification_app/presentation/widgets/default_app_bar.dart';
import 'package:notification_app/presentation/widgets/heading.dart';
import 'package:notification_app/presentation/wrappers/scrollable_page.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: DefaultAppBar(),
      body: ScrollablePage(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Heading('FAQ.'),
            Text('This page is under construction.'),
          ],
        ),
      ),
    );
  }
}
