import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notification_app/constants/colors.dart';
import 'package:notification_app/constants/dimension.dart';
import 'package:notification_app/constants/icons.dart';
import 'package:notification_app/constants/theme.dart';
import 'package:notification_app/constants/typography.dart';

class UnderlinedInput extends StatefulWidget {
  static const Key errorMessageKey = const Key('UnderlinedInputErrorText');
  static const Key errorIconKey = const Key('UnderlinedInputErrorIcon');
  static const Key underlineKey = const Key('UnderlinedInputUnderline');

  final int maxLines;
  final double maxHeight;
  final GlobalKey? formKey;
  final FocusNode? focusNode;
  final Color? textColor;
  final FormFieldValidator<String>? validator;
  final String? initialValue;
  final bool readOnly;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Color? borderColor;
  final Color? errorBorderColor;
  final String? placeholder;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldSetter<String>? onSaved;
  final double underlineHeight;
  final AutovalidateMode autovalidateMode;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final bool enabled;

  const UnderlinedInput({
    Key? key,
    this.placeholder,
    this.borderColor = ColorPalette.liquorice,
    this.errorBorderColor = ColorPalette.chilli,
    this.textColor,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
    this.maxHeight = Dimension.inputHeight,
    this.enabled = true,
    this.controller,
    this.initialValue,
    this.readOnly = false,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
    this.formKey,
    this.textInputAction,
    this.focusNode,
    this.autofocus = false,
    this.underlineHeight = 3.0,
  }) : super(key: key);

  @override
  _UnderlinedInputState createState() => _UnderlinedInputState();
}

class _UnderlinedInputState extends State<UnderlinedInput> {
  String? _error;
  late FocusNode _node;
  late FocusNode _childNode;

  @override
  void initState() {
    _childNode = widget.focusNode ?? FocusNode();
    _node = FocusNode();

    /// Add listeners here if needed
    // _node.addListener(() { });
    super.initState();
  }

  @override
  void dispose() {
    _node.dispose();
    _childNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: Dimension.yAxisPadding),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            constraints: BoxConstraints(
              maxHeight: widget.maxHeight,
            ),
            child: LayoutBuilder(
              builder: (_, BoxConstraints constraints) => SizedBox(
                height: constraints.maxHeight,
                child: Stack(
                  children: <Widget>[
                    _textField,
                    _underline(constraints),
                  ],
                ),
              ),
            ),
          ),
          _errorMessageBlock,
        ],
      ),
    );
  }

  InputDecoration get _decoration {
    return InputDecoration()
        .applyDefaults(Theme.of(context).inputDecorationTheme)
        .copyWith(
          labelStyle: TextTypography.body_copy.copyWith(
            color: ColorPalette.thunder,
            height: 1.5,
          ),
          hintText: widget.placeholder,
          border: _none,
          enabledBorder: _none,
          focusedBorder: _none,
          disabledBorder: _none,
          errorBorder: _none,
          focusedErrorBorder: _none,
        );
  }

  InputBorder get _none => InputBorder.none;

  Widget get _textField {
    return Focus(
      focusNode: _node,
      child: TextFormField(
        focusNode: _childNode,
        enabled: widget.enabled,
        maxLines: widget.maxLines,
        key: widget.formKey ?? widget.key,
        controller: widget.controller,
        autofocus: widget.autofocus,
        textInputAction: widget.textInputAction,
        keyboardType: widget.keyboardType,
        initialValue: widget.initialValue,
        readOnly: widget.readOnly,
        onEditingComplete: widget.onEditingComplete,
        autovalidateMode: widget.autovalidateMode,
        textAlign: TextAlign.left,
        decoration: _decoration,
        onChanged: widget.onChanged,
        onSaved: widget.onSaved,
        onFieldSubmitted: widget.onFieldSubmitted,
        validator: (_) {
          if (widget.validator != null && mounted) {
            final String? validationError = widget.validator!(_);

            if (widget.autovalidateMode == AutovalidateMode.disabled) {
              setState(() {
                _error = validationError;
              });
            } else {
              scheduleMicrotask(
                () => setState(() {
                  _error = validationError;
                }),
              );
            }

            // This is a hack to get rid of TextFormField validation message
            // in favor of custom error message with icon, as null value
            // considered as valid input & any string even empty as invalid.
            // Worging in couple with resetting styles for
            // inputDecorationTheme -> errorStyle -> copyWith(...) section
            // located in lib/constants/theme.dart
            return validationError == null ? null : '';
          }

          return null;
        },
      ),
    );
  }

  Widget _underline(BoxConstraints constraints) => Positioned(
        top: constraints.maxHeight - widget.underlineHeight,
        child: Container(
          key: UnderlinedInput.underlineKey,
          height: widget.underlineHeight,
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            color:
                _error != null ? widget.errorBorderColor : widget.borderColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(),
        ),
      );

  Widget get _errorMessageBlock => _error != null
      ? Container(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 5),
                child: Icon(
                  ThreeIcons.warning,
                  key: UnderlinedInput.errorIconKey,
                  color: ColorPalette.chilli,
                  size: 20,
                ),
              ),
              Expanded(
                child: Text(
                  _error!,
                  key: UnderlinedInput.errorMessageKey,
                  style: themeInputErrorTextStyle(),
                ),
              ),
            ],
          ),
        )
      : Container();
}
