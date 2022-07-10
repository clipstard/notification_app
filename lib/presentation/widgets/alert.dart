import 'package:flutter/material.dart';
import 'package:notification_app/constants/colors.dart';
import 'package:notification_app/constants/dimension.dart';
import 'package:notification_app/constants/icons.dart';
import 'package:notification_app/constants/typography.dart';

enum AlertVariant {
  info,
  warning,
}

class Alert extends StatelessWidget {
  Alert({
    required this.title,
    this.child,
    this.variant = AlertVariant.info,
    Key? key,
  }) : super(key: key);

  final String title;
  final Widget? child;
  final AlertVariant? variant;

  final Map<AlertVariant, Map<String, Object>> _styleMap =
      <AlertVariant, Map<String, Object>>{
    AlertVariant.info: <String, Object>{
      'color': ColorPalette.skyBlue,
      'icon': ThreeIcons.info_circle
    },
    AlertVariant.warning: <String, Object>{
      'color': ColorPalette.chilli,
      'icon': ThreeIcons.warning
    },
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Dimension.yAxisPadding),
      margin: const EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        border: Border.all(
          color: _styleMap[variant]!['color'] as Color,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Icon(
                  _styleMap[variant]!['icon'] as IconData,
                  color: _styleMap[variant]!['color'] as Color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: TextTypography.h4_m,
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
          Container(child: child),
        ],
      ),
    );
  }
}
