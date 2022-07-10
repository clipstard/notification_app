import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notification_app/constants/assets.dart';
import 'package:notification_app/constants/colors.dart';

class AppCheckbox extends StatefulWidget {
  final bool isChecked;
  final ValueChanged<bool>? onChanged;
  final bool hasError;
  final double size;
  final double iconWidth;
  final double iconHeight;
  final Color selectedColor;
  final Color unSelectedColor;
  final Color unSelectedBorderColor;
  final double borderWidth;
  final Color checkMarkColor;
  final double borderRadius;

  AppCheckbox({
    this.isChecked = false,
    this.onChanged,
    this.size = 28.57,
    this.iconWidth = 13.53,
    this.iconHeight = 10.55,
    this.selectedColor = ColorPalette.liquorice,
    this.unSelectedBorderColor = ColorPalette.liquorice,
    this.borderWidth = 1.0,
    this.unSelectedColor = Colors.transparent,
    this.checkMarkColor = ColorPalette.aurora40,
    this.borderRadius = 3.0,
    this.hasError = false,
  });

  @override
  _AppCheckboxState createState() => _AppCheckboxState();
}

class _AppCheckboxState extends State<AppCheckbox> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(AppCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    _init();
  }

  void _init() {
    _isSelected = widget.isChecked;
  }

  void onTap() {
    setState(() {
      _isSelected = !_isSelected;
    });

    if (widget.onChanged != null) {
      widget.onChanged!(_isSelected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.fastLinearToSlowEaseIn,
        decoration: BoxDecoration(
          color: _isSelected ? widget.selectedColor : widget.unSelectedColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: _checkboxBorder,
        ),
        width: widget.size,
        height: widget.size,
        child: _isSelected ? _checkMark : null,
      ),
    );
  }

  SvgPicture get _checkMark {
    return SvgPicture.asset(
      Assets.checkmarkIcon,
      height: widget.iconHeight,
      width: widget.iconWidth,
      fit: BoxFit.scaleDown,
    );
  }

  Border get _checkboxBorder {
    Color color;
    if (widget.hasError) {
      color = ColorPalette.chilli;
    } else {
      if (_isSelected) {
        color = Colors.transparent;
      } else {
        color = widget.unSelectedBorderColor;
      }
    }

    return Border.all(
      color: color,
      width: widget.borderWidth,
    );
  }
}
