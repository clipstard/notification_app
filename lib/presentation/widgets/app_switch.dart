import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:notification_app/constants/colors.dart';

class AppSwitch extends StatefulWidget {
  const AppSwitch({
    required this.value,
    required this.onToggle,
    Key? key,
    this.activeColor = ColorPalette.liquorice,
    this.inactiveColor = ColorPalette.smoke,
    this.activeTextColor = Colors.white70,
    this.inactiveTextColor = Colors.white70,
    this.toggleColor = Colors.white,
    this.activeToggleColor = ColorPalette.toggleActiveColor,
    this.inactiveToggleColor = ColorPalette.coconut,
    this.width = 70,
    this.height = 30,
    this.toggleSize = 22,
    this.valueFontSize = 16.0,
    this.borderRadius = 30.0,
    this.padding = 4,
    this.showOnOff = false,
    this.activeText,
    this.inactiveText,
    this.activeTextFontWeight,
    this.inactiveTextFontWeight,
    this.switchBorder,
    this.activeSwitchBorder,
    this.inactiveSwitchBorder,
    this.toggleBorder,
    this.activeToggleBorder,
    this.inactiveToggleBorder,
    this.activeIcon,
    this.inactiveIcon,
    this.duration = const Duration(milliseconds: 200),
    this.disabled = false,
  }) : super(key: key);

  final bool value;
  final ValueChanged<bool> onToggle;
  final Color activeColor;
  final Color inactiveColor;
  final Color activeTextColor;
  final Color inactiveTextColor;
  final Color toggleColor;
  final Color? activeToggleColor;
  final Color? inactiveToggleColor;
  final double width;
  final double height;
  final double toggleSize;
  final double valueFontSize;
  final double borderRadius;
  final double padding;
  final bool showOnOff;
  final String? activeText;
  final String? inactiveText;
  final FontWeight? activeTextFontWeight;
  final FontWeight? inactiveTextFontWeight;
  final BoxBorder? switchBorder;
  final BoxBorder? activeSwitchBorder;
  final BoxBorder? inactiveSwitchBorder;
  final BoxBorder? toggleBorder;
  final BoxBorder? activeToggleBorder;
  final BoxBorder? inactiveToggleBorder;
  final Widget? activeIcon;
  final Widget? inactiveIcon;
  final Duration duration;
  final bool disabled;

  @override
  _AppSwitchState createState() => _AppSwitchState();
}

class _AppSwitchState extends State<AppSwitch> {
  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      key: widget.key,
      value: widget.value,
      onToggle: widget.onToggle,
      activeColor: widget.activeColor,
      inactiveColor: widget.inactiveColor,
      activeTextColor: widget.activeTextColor,
      inactiveTextColor: widget.inactiveTextColor,
      toggleColor: widget.toggleColor,
      activeToggleColor: widget.activeToggleColor,
      inactiveToggleColor: widget.inactiveToggleColor,
      width: widget.width,
      height: widget.height,
      toggleSize: widget.toggleSize,
      valueFontSize: widget.valueFontSize,
      borderRadius: widget.borderRadius,
      padding: widget.padding,
      showOnOff: widget.showOnOff,
      activeText: widget.activeText,
      inactiveText: widget.inactiveText,
      activeTextFontWeight: widget.activeTextFontWeight,
      inactiveTextFontWeight: widget.inactiveTextFontWeight,
      switchBorder: widget.switchBorder,
      activeSwitchBorder: widget.activeSwitchBorder,
      inactiveSwitchBorder: widget.inactiveSwitchBorder,
      toggleBorder: widget.toggleBorder,
      activeToggleBorder: widget.activeToggleBorder,
      inactiveToggleBorder: widget.inactiveToggleBorder,
      activeIcon: widget.activeIcon,
      inactiveIcon: widget.inactiveIcon,
      duration: widget.duration,
      disabled: widget.disabled,
    );
  }
}
