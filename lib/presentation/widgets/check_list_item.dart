import 'package:flutter/material.dart';
import 'package:notification_app/constants/colors.dart';
import 'package:notification_app/constants/dimension.dart';
import 'package:notification_app/constants/icons.dart';
import 'package:notification_app/presentation/widgets/text_icon.dart';

class CheckListItem extends TextIcon {
  final String text;
  final bool enabled;
  final double bottom;

  CheckListItem({
    required this.text,
    this.enabled = true,
    this.bottom = Dimension.spacer,
  }) : super(
          text: text,
          icon: ThreeIcons.confirm_circle,
          bottom: bottom,
        );

  Widget _buildUncheckedIcon() {
    return Container(
      width: 20.0,
      height: 20.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 1.0,
          color: ColorPalette.cloud,
        ),
      ),
      child: const SizedBox.shrink(),
    );
  }

  Widget _buildCheckedIcon() {
    return Container(
      width: 20.0,
      height: 20.0,
      child: const Icon(
        ThreeIcons.confirm_circle,
        color: ColorPalette.cucumber,
        size: 20.0,
      ),
    );
  }

  @override
  Widget buildIcon() {
    return enabled ? _buildCheckedIcon() : _buildUncheckedIcon();
  }
}
