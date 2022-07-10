import 'package:flutter/material.dart';
import 'package:notification_app/constants/colors.dart';
import 'package:notification_app/constants/dimension.dart';
import 'package:notification_app/constants/typography.dart';

class SnackbarService {
  static SnackBar buildSnackBar(
    BuildContext context,
    String message,
    Color color,
    Color accentColor,
  ) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.only(
        bottom: 47 + MediaQuery.of(context).viewInsets.bottom,
        left: Dimension.yAxisPadding,
        right: Dimension.yAxisPadding,
      ),
      backgroundColor: color,
      content: Text(
        message,
        style: TextTypography.body_copy.copyWith(
          color: accentColor,
        ),
      ),
    );
  }

  static void show(BuildContext context, SnackBar snackBar) {
    ScaffoldMessengerState _messenger = ScaffoldMessenger.of(context);
    _messenger.clearSnackBars();
    _messenger.showSnackBar(snackBar);
  }

  static void showWarning(
    BuildContext context, {
    String? message,
    SnackBar? snackBar,
  }) {
    if (snackBar != null) {
      show(context, snackBar);
    } else if (message != null) {
      show(
          context,
          buildSnackBar(
            context,
            message,
            ColorPalette.shepherdsDelight,
            ColorPalette.liquorice,
          ));
    }
  }

  static void showSuccess(
    BuildContext context, {
    String? message,
    SnackBar? snackBar,
  }) {
    if (snackBar != null) {
      show(context, snackBar);
    } else if (message != null) {
      show(
          context,
          buildSnackBar(
            context,
            message,
            ColorPalette.cucumber,
            ColorPalette.coconut,
          ));
    }
  }
}
