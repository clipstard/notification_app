import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notification_app/constants/dimension.dart';
import 'package:notification_app/presentation/widgets/outlined_button/button_theming.dart';

/// [ThreeOutlinedButton] requires one of [child] or [text] parameters
/// to be provided to be used as inner content else [Error] will be thrown
class ThreeOutlinedButton extends StatefulWidget {
  final Key? key;
  final Text? child;
  final String? text;
  final Color? textColor;
  final void Function()? onPressed;
  final ButtonStyle? style;
  final ButtonClassName buttonClassName;
  final EdgeInsets? margin;

  ThreeOutlinedButton({
    this.key,
    this.child,
    this.text,
    this.textColor,
    this.onPressed,
    this.style,
    this.buttonClassName = ButtonClassName.primary,
    this.margin,
  }) : super(key: key) {
    assert(() {
      if (this.child == null && this.text == null) {
        throw FlutterError('Outlined button should have at least one'
            ' ancestor given in text or child.');
      }
      return true;
    }());
  }

  @override
  _ThreeOutlinedButtonState createState() => _ThreeOutlinedButtonState();
}

class _ThreeOutlinedButtonState extends State<ThreeOutlinedButton> {
  MaterialState? _materialState;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? EdgeInsets.only(bottom: Dimension.spacer / 2),
      height: 40.0,
      width: MediaQuery.of(context).size.width,
      decoration: _buildBoxDecoration(widget.buttonClassName),
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            _materialState = MaterialState.pressed;
            _timer = Timer(Duration(milliseconds: 450), () {
              setState(() {
                _materialState = null;
              });
            });
          });

          if (widget.onPressed != null) {
            widget.onPressed!();
          }
        },
        style: _buildButtonStyle(widget.buttonClassName),
        child: _innerContent,
      ),
    );
  }

  ButtonStyle _buildButtonStyle(ButtonClassName buttonClassName) {
    return ButtonTheming.resolve(
      _materialState,
      widget.buttonClassName,
    ).style;
  }

  BoxDecoration _buildBoxDecoration(ButtonClassName buttonClassName) {
    if (buttonClassName == ButtonClassName.secondary) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      );
    }

    return BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      boxShadow: <BoxShadow>[
        ButtonTheming.resolve(
          _materialState,
          buttonClassName,
        ).boxShadow,
      ],
    );
  }

  Text get _innerContent {
    if (widget.child != null) {
      return Text(
        widget.child!.data!,
        textAlign: widget.child!.textAlign,
        softWrap: widget.child!.softWrap,
        style: widget.child!.style,
        overflow: TextOverflow.visible,
        maxLines: 1,
      );
    }

    return Text(
      widget.text!,
      textAlign: TextAlign.center,
      overflow: TextOverflow.visible,
      maxLines: 1,
    );
  }
}
