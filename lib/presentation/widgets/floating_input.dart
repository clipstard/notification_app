import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notification_app/constants/colors.dart';
import 'package:notification_app/constants/dimension.dart';
import 'package:notification_app/constants/icons.dart';
import 'package:notification_app/constants/theme.dart';
import 'package:notification_app/constants/typography.dart';
import 'package:notification_app/localization.dart';

class FloatingInput extends StatefulWidget {
  const FloatingInput({
    Key? key,
    this.initialValue,
    this.controller,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.onTap,
    this.focusNode,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.autovalidateMode,
    this.enabled,
    this.readOnly = false,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
    this.maxLength,
    this.decoration = const InputDecoration(),
    this.enablePasswordFeatures,
    this.textInputAction,
    this.formFieldKey = null,
    this.inputFormatters = null,
    this.externalizeErrorMsg = null,
    this.noBottomPadding = false,

    ///If true require formFieldKey
    this.validateOnFocusOut = false,
  }) : super(key: key);

  /// Regular TextFormField properties
  final TextEditingController? controller;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final GestureTapCallback? onTap;
  final FocusNode? focusNode;
  final bool enableSuggestions;
  final bool autocorrect;
  final AutovalidateMode? autovalidateMode;
  final bool? enabled;
  final bool readOnly;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldSetter<String>? onSaved;
  final int? maxLength;
  final InputDecoration decoration;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String?>? externalizeErrorMsg;
  final bool noBottomPadding;

  /// Custom properties
  final bool? enablePasswordFeatures;
  final GlobalKey<FormFieldState<dynamic>>? formFieldKey;
  final bool validateOnFocusOut;

  @override
  _FloatingInputState createState() => _FloatingInputState();
}

class _FloatingInputState extends State<FloatingInput> {
  late FocusNode _node;
  bool _hasValue = false;
  bool _hasFocus = false;
  bool _showPassword = false;
  String? _error;

  void _onChangeHandler(String value) {
    setState(() {
      _hasValue = value.isNotEmpty;
    });

    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  bool get isPasswordField => widget.enablePasswordFeatures ?? false;

  bool get isLabelFloated => _hasValue || _hasFocus;

  TextInputType get keyboardType {
    if (widget.keyboardType == TextInputType.text &&
        isPasswordField &&
        _showPassword) {
      /// Recommended to use [TextInputType.visiblePassword] for passwords
      /// that are visible to used
      return TextInputType.visiblePassword;
    }

    return widget.keyboardType ?? TextInputType.text;
  }

  @override
  void initState() {
    _node = widget.focusNode ?? FocusNode();
    _node.addListener(() {
      setState(() {
        _hasFocus = _node.hasFocus;
        _hasValue = (widget.controller != null &&
                widget.controller!.text.isNotEmpty) ||
            (widget.initialValue != null && widget.initialValue!.isNotEmpty);
      });

      if (!_hasFocus &&
          widget.validateOnFocusOut &&
          widget.formFieldKey != null) {
        widget.formFieldKey!.currentState!.validate();
      }
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      _hasFocus = _node.hasFocus;
      _hasValue =
          (widget.controller != null && widget.controller!.text.isNotEmpty) ||
              (widget.initialValue != null && widget.initialValue!.isNotEmpty);
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          bottom: widget.noBottomPadding ? 0 : Dimension.yAxisPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildTextField(),
          _buildErrorMessage(),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(BuildContext context) {
    final Widget? customSuffixIcon =
        isPasswordField ? _buildPasswordToggle() : null;

    return widget.decoration
        .applyDefaults(Theme.of(context).inputDecorationTheme)
        .copyWith(
          labelStyle: TextTypography.body_copy.copyWith(
            color:
                isLabelFloated ? ColorPalette.liquorice : ColorPalette.thunder,
            fontWeight: isLabelFloated ? FontWeight.bold : FontWeight.w400,
            fontSize: isLabelFloated ? 19 : 16.0,
            height: 1.5,
          ),
          disabledBorder: widget.decoration.disabledBorder,
          suffixIcon: widget.decoration.suffixIcon ?? customSuffixIcon,
          errorMaxLines: widget.decoration.errorMaxLines ?? 5,
          floatingLabelBehavior: widget.decoration.floatingLabelBehavior ??
              FloatingLabelBehavior.auto,
        );
  }

  Widget _buildTextField() {
    return TextFormField(
      key: widget.key ?? widget.formFieldKey,
      focusNode: _node,
      initialValue: widget.initialValue,
      controller: widget.controller,
      keyboardType: keyboardType,
      obscureText: widget.obscureText || isPasswordField && !_showPassword,
      enableSuggestions: !isPasswordField && widget.enableSuggestions,
      autocorrect: !isPasswordField && widget.autocorrect,
      autovalidateMode: widget.autovalidateMode,
      textAlign: TextAlign.left,
      onChanged: _onChangeHandler,
      onTap: widget.onTap,
      enabled: widget.enabled ?? true,
      readOnly: widget.readOnly,
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.onFieldSubmitted,
      onSaved: widget.onSaved,
      maxLength: widget.maxLength,
      decoration: _buildInputDecoration(context),
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      validator: (_) {
        if (widget.validator != null && mounted) {
          final String? validationError = widget.validator!(_);

          if (widget.autovalidateMode == AutovalidateMode.disabled) {
            setState(() {
              _showError(validationError);
            });
          } else {
            scheduleMicrotask(
              () => setState(() {
                _showError(validationError);
              }),
            );
          }

          // This is a hack to get rid of TextFormField validation message
          // in favor of custom error message with icon, as null value
          // considered as valid input & any string as invalid.
          // Warning in couple with resetting styles for
          // inputDecorationTheme -> errorStyle -> copyWith(...) section
          // located in lib/constants/theme.dart
          return validationError == null ? null : '';
        }

        return null;
      },
    );
  }

  void _showError(String? validationError) {
    if (widget.externalizeErrorMsg != null) {
      widget.externalizeErrorMsg!(validationError);
    } else {
      _error = validationError;
    }
  }

  Widget _buildErrorMessage() {
    return _error != null
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
                    key: const Key('floatingInputErrorIconKey'),
                    color: ColorPalette.chilli,
                    size: 20,
                  ),
                ),
                Expanded(
                  child: Text(
                    _error!,
                    key: const Key('floatingInputErrorTextKey'),
                    style: themeInputErrorTextStyle(),
                  ),
                ),
              ],
            ),
          )
        : Container();
  }

  Widget _buildPasswordToggle() {
    final AppLocalizations _translate = AppLocalizations.of(context)!;

    return InkWell(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            _showPassword ? _translate.pwd_hide : _translate.pwd_show,
            style: TextTypography.body_copy.copyWith(
              color: ColorPalette.blueberry,
              decoration: TextDecoration.underline,
            ),
          ),
          SizedBox(height: 3),
        ],
      ),
      onTap: _togglePasswordVisibility,
    );
  }
}
