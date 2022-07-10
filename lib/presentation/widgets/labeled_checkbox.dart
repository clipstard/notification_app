import 'package:flutter/material.dart';
import 'package:notification_app/presentation/widgets/app_checkbox.dart';

class LabeledCheckbox extends StatelessWidget {
  final Widget child;
  final bool isChecked;
  final ValueChanged<bool>? onChanged;
  final bool hasError;
  final bool labelTappable;
  final Offset labelOffset;

  LabeledCheckbox({
    required this.child,
    this.isChecked = false,
    Key? key,
    this.onChanged,
    this.hasError = false,
    this.labelTappable = true,
    this.labelOffset = const Offset(10, 5),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: labelOffset.dy,
            right: labelOffset.dx,
          ),
          child: Container(
            child: AppCheckbox(
              isChecked: isChecked,
              hasError: hasError,
              onChanged: onChanged,
            ),
          ),
        ),
        Expanded(
          child: (this.labelTappable && this.onChanged != null)
              ? InkWell(
                  onTap: () => this.onChanged!(!isChecked),
                  child: child,
                )
              : child,
        ),
      ],
    );
  }
}
