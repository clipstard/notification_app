import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notification_app/constants/colors.dart';
import 'package:notification_app/constants/typography.dart';

class Link extends StatefulWidget {
  final VoidCallback? onTap;
  final String text;
  final Color? color;
  final int delay;
  final bool inline;

  const Link(
    this.text, {
    this.onTap,
    this.delay = 0,
    this.color,
    this.inline = false,
    Key? key,
  }) : super(key: key);

  @override
  _LinkState createState() => _LinkState();
}

class _LinkState extends State<Link> {
  Timer? _timer;
  late int secondsLeft;
  bool showTimer = false;
  _LinkState();

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      secondsLeft = widget.delay;
      setTimer();
    });

    super.initState();
  }

  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: _contained(
        Text(
          _linkText,
          textAlign: TextAlign.start,
          style: TextTypography.link.copyWith(
            color: showTimer
                ? ColorPalette.slate
                : widget.color ?? ColorPalette.blueberry,
          ),
        ),
      ),
      onTap: () async {
        if (!showTimer && secondsLeft > 0) {
          setState(() {
            showTimer = true;
          });
        }

        if (secondsLeft > 0) {
          return;
        }

        setTimer();

        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
    );
  }

  String get _linkText {
    if (!showTimer) {
      return widget.text;
    }

    return '${widget.text} ($secondsLeft)';
  }

  Widget _contained(Text text) {
    return widget.inline
        ? text
        : Container(
            child: text,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerLeft,
          );
  }

  void setTimer() {
    if (_timer != null || widget.delay < 1) {
      return;
    }

    setState(() {
      secondsLeft = widget.delay;
      _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
        if (secondsLeft > 1) {
          setState(() {
            secondsLeft -= 1;
          });
        } else {
          _timer!.cancel();
          setState(() {
            _timer = null;
            showTimer = false;
            secondsLeft = 0;
          });
        }
      });
    });
  }
}
