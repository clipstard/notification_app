import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notification_app/constants/colors.dart';
import 'package:notification_app/constants/typography.dart';
import 'package:notification_app/localization.dart';
import 'package:notification_app/presentation/router/route_builder.dart';
import 'package:notification_app/presentation/screens/reset_password_msisdn_screen.dart';
import 'package:notification_app/presentation/widgets/link.dart';
import 'package:notification_app/presentation/widgets/heading.dart';
import 'package:notification_app/presentation/widgets/outlined_button/outlined_button.dart';
import 'package:notification_app/extensions/extensions.dart'
    show DurationFormatter;
import 'package:notification_app/presentation/wrappers/scrollable_page.dart';
import 'package:notification_app/presentation/widgets/default_app_bar.dart';

class RetryScreen extends StatefulWidget {
  final DateTime lockTime;
  final Function(BuildContext, Widget) onRetry;
  final String? description;

  const RetryScreen({
    required this.lockTime,
    required this.onRetry,
    this.description = '',
    Key? key,
  }) : super(key: key);

  @override
  _RetryScreenState createState() => _RetryScreenState();
}

class _RetryScreenState extends State<RetryScreen> {
  Timer? _timer;
  Duration? _retryDelay;

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }

    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _updateTimerState();
      _setTimer();
    });
    super.initState();
  }

  void _updateTimerState() {
    setState(() {
      _retryDelay = widget.lockTime.difference(DateTime.now());
    });
  }

  void _setTimer() {
    if (_timer != null) {
      return;
    }

    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      _updateTimerState();
    });
  }

  Duration? get _diff {
    if (_retryDelay == null || _retryDelay!.inSeconds <= 0) {
      return null;
    }

    return _retryDelay;
  }

  String get _time {
    if (_diff == null) return AppLocalizations.of(context)!.now;

    return AppLocalizations.of(context)!.retry_screen_retry_countdown(
      _diff!.minuteTimerFormat(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(),
      body: ScrollablePage(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _title(context),
            _description(context),
            const SizedBox(height: 20),
            if (_diff == null) _tryAgainButton(context),
            Flexible(
              flex: 1,
              child: _forgotPasswordLink(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title(BuildContext context) {
    return Heading(
      AppLocalizations.of(context)!.retry_screen_title,
      type: HeadingType.h1,
    );
  }

  Widget _description(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: widget.description,
        style: TextTypography.body_copy.copyWith(
          color: ColorPalette.liquorice,
        ),
        children: <TextSpan>[
          TextSpan(
            text: AppLocalizations.of(context)!.retry_screen_delayed_try(_time),
            style: TextTypography.body_copy.copyWith(
              color: ColorPalette.liquorice,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tryAgainButton(BuildContext context) {
    return ThreeOutlinedButton(
      text: AppLocalizations.of(context)!.retry_screen_retry_button,
      onPressed: () => widget.onRetry(context, widget),
    );
  }

  Widget _forgotPasswordLink(BuildContext context) {
    return Link(
      AppLocalizations.of(context)!.forgot_your_password,
      onTap: () {
        Navigator.of(context).pushReplacement(
          RouteBuilder<ResetPasswordMsisdnScreen>(
            active: widget,
            next: ResetPasswordMsisdnScreen(),
          ),
        );
      },
    );
  }
}
