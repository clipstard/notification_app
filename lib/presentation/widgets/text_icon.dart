import 'package:flutter/material.dart';
import 'package:notification_app/constants/dimension.dart';

class TextIcon extends StatelessWidget {
  const TextIcon({
    required this.text,
    this.icon,
    this.iconOffsetTop = 4.0,
    this.bottom = Dimension.spacer,
    this.gap = Dimension.spacer / 2,
    this.textStyle,
    Key? key,
  }) : super(key: key);

  final String text;
  final dynamic icon;
  final double bottom;
  final double gap;
  final TextStyle? textStyle;
  final double iconOffsetTop;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: iconOffsetTop),
            child: buildIcon(),
          ),
          SizedBox(width: gap),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyText2!.merge(textStyle),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIcon() {
    return (icon is IconData)
        ? Icon(icon as IconData, size: 20.0)
        : icon as Widget;
  }
}
