import 'package:flutter/material.dart';
import 'package:notification_app/constants/app_config.dart';
import 'package:notification_app/constants/icons.dart';
import 'package:notification_app/localization.dart';
import 'package:notification_app/presentation/widgets/heading.dart';
import 'package:url_launcher/url_launcher.dart';

class GetInTouch extends StatelessWidget {
  GetInTouch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Heading(AppLocalizations.of(context)!.get_in_touch),
          _liveChat(context),
          Divider(),
          _callUs(context),
        ],
      ),
    );
  }

  Widget _liveChat(BuildContext context) {
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            ThreeIcons.conversation,
            size: 40,
          ),
          SizedBox(width: 12),
          Heading(
            AppLocalizations.of(context)!.live_chat,
            type: HeadingType.h4,
            target: HeadingTarget.desktop,
          ),
        ],
      ),
    );
  }

  Widget _callUs(BuildContext context) {
    return InkWell(
      onTap: () => _makePhoneCall('tel:${AppConfig.contactCenterNumber}'),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            ThreeIcons.call,
            size: 40,
          ),
          SizedBox(width: 12),
          Heading(
            AppLocalizations.of(context)!.call_us,
            type: HeadingType.h4,
            target: HeadingTarget.desktop,
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
