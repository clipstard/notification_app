import 'dart:async' show scheduleMicrotask;

import 'package:flutter/material.dart';
import 'package:notification_app/constants/dimension.dart';
import 'package:notification_app/localization.dart';
import 'package:notification_app/presentation/widgets/labeled_checkbox.dart';
import 'package:notification_app/presentation/widgets/outlined_button/outlined_button.dart';
import 'package:notification_app/presentation/widgets/underlined_input.dart';
import 'package:notification_app/utils/utils.dart' show Validators;

class MsisdnForm extends StatefulWidget {
  final ValueChanged<String> onSubmit;
  final String? errorMessage;
  final String? buttonLabel;
  final bool displayCheckboxConfirmation;
  final bool shouldConfirm;

  MsisdnForm({
    required this.onSubmit,
    this.buttonLabel,
    this.errorMessage,
    this.displayCheckboxConfirmation = true,
    this.shouldConfirm = true,
    Key? key,
  }) : super(key: key);

  @override
  _MsisdnFormState createState() => _MsisdnFormState();
}

class _MsisdnFormState extends State<MsisdnForm> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AppLocalizations _translate;
  bool holderChecked = false;
  bool phoneValid = false;
  bool holderError = false;
  bool untouchedAndError = false;

  String get msisdn {
    return _phoneNumberController.text;
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (widget.errorMessage != null) {
        untouchedAndError = true;
        _formKey.currentState!.validate();
      }

      if (!widget.displayCheckboxConfirmation) {
        holderChecked = true;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  void validate() {
    _formKey.currentState!.validate();

    if (widget.shouldConfirm) {
      setState(() {
        holderError = !holderChecked;
      });

      if (!holderError && phoneValid) {
        widget.onSubmit(msisdn);
      }
    } else {
      widget.onSubmit(msisdn);
    }
  }

  @override
  Widget build(BuildContext context) {
    _translate = AppLocalizations.of(context)!;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _phoneField(),
          if (widget.shouldConfirm) _checkboxField(),
          if (!widget.shouldConfirm) const SizedBox(height: 10),
          _submitButton(),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return ThreeOutlinedButton(
      onPressed: validate,
      text: widget.buttonLabel ?? _translate.button_send_text,
    );
  }

  Widget _checkboxField() {
    if (!widget.displayCheckboxConfirmation) {
      return Container();
    }

    return Container(
      padding: EdgeInsets.only(
        bottom: Dimension.yAxisPadding,
      ),
      child: LabeledCheckbox(
        key: Key('accountHolderCheckbox'),
        child: Text(_translate.register_screen_account_holder_check),
        hasError: holderError,
        isChecked: holderChecked,
        onChanged: (bool value) {
          setState(() {
            holderChecked = value;
          });
        },
      ),
    );
  }

  Widget _phoneField() {
    return UnderlinedInput(
      key: const Key('phoneNumber'),
      controller: _phoneNumberController,
      placeholder: _translate.register_screen_phone_number_placeholder,
      onEditingComplete: validate,
      onChanged: (_) {
        scheduleMicrotask(() {
          setState(() {
            untouchedAndError = false;
          });
        });
      },
      validator: (_) {
        FormFieldValidator<String> composed = Validators.compose(
          <String? Function(String?)>[
            Validators.required(),
            Validators.phone(),
          ],
        );

        bool _phoneValid = composed(msisdn) == null;

        setState(() {
          phoneValid = _phoneValid;
        });

        if (untouchedAndError) {
          return widget.errorMessage;
        }

        return !_phoneValid
            ? _translate.register_screen_invalid_phone_error
            : widget.errorMessage;
      },
      keyboardType: TextInputType.phone,
    );
  }
}
