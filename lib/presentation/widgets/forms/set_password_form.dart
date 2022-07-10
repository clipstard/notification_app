import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_debounce_it/just_debounce_it.dart';
import 'package:notification_app/constants/dimension.dart';
import 'package:notification_app/constants/typography.dart';
import 'package:notification_app/localization.dart';
import 'package:notification_app/logic/bloc/password/password_bloc.dart';
import 'package:notification_app/presentation/widgets/check_list_item.dart';
import 'package:notification_app/presentation/widgets/floating_input.dart';
import 'package:notification_app/presentation/widgets/outlined_button/outlined_button.dart';
import 'package:notification_app/utils/utils.dart' show Validators;

class SetPasswordForm extends StatefulWidget {
  const SetPasswordForm({
    Key? key,
    this.submitLabel,
    this.passwordInputLabel,
    this.confirmPasswordInputLabel,
    this.onSubmit,
  }) : super(key: key);

  final String? submitLabel;
  final String? passwordInputLabel;
  final String? confirmPasswordInputLabel;
  final ValueChanged<String>? onSubmit;

  @override
  _SetPasswordFormState createState() => _SetPasswordFormState();
}

class _SetPasswordFormState extends State<SetPasswordForm> {
  late PasswordBloc _passwordBloc;
  late AppLocalizations _translate;
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _pwdConfirmController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _passwordBloc = BlocProvider.of<PasswordBloc>(context);
  }

  @override
  void dispose() {
    _pwdController.dispose();
    _pwdConfirmController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _translate = AppLocalizations.of(context)!;

    return BlocListener<PasswordBloc, PasswordState>(
      listener: (
        BuildContext context,
        PasswordState state,
      ) {
        if (state.passwordWasChanged && state.isValid) {
          _passwordBloc.add(PaswordSequentialValidation(
            password: _pwdController.text,
          ));
        }
      },
      child: Form(
        key: _formKey,
        child: BlocBuilder<PasswordBloc, PasswordState>(
          builder: (
            BuildContext context,
            PasswordState state,
          ) {
            return Column(
              children: <Widget>[
                _passwordInput(state),
                _passwordRulesCheckList(state),
                _passwordConfirmInput(),
                SizedBox(height: Dimension.spacer),
                SizedBox(
                  width: double.infinity,
                  child: _submitButton(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _passwordChangeHandler(String value, PasswordState state) {
    _passwordBloc.add(PasswordChanged(password: value));
  }

  Widget _passwordInput(PasswordState state) {
    return FloatingInput(
      key: const Key('passwordInput'),
      controller: _pwdController,
      enablePasswordFeatures: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (String? value) {
        if (!state.isValid || state.isGuessable || state.isPwned) {
          return _translate.set_pwd_screen_pwd_requirements;
        }

        return null;
      },
      decoration: InputDecoration(
        labelText: widget.passwordInputLabel ?? _translate.set_pwd_screen_pwd,
      ),
      onChanged: (String value) {
        Debounce.milliseconds(
          1500,
          _passwordChangeHandler,
          <dynamic>[value, state],
        );
      },
    );
  }

  Widget _passwordConfirmInput() {
    return FloatingInput(
      key: const Key('passwordConfirmInput'),
      controller: _pwdConfirmController,
      enablePasswordFeatures: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: Validators.compose(<String? Function(String?)>[
        Validators.required(),
        Validators.match(
          _pwdController.text,
          true,
          _translate.set_pwd_screen_pwd_not_match,
        ),
      ]),
      decoration: InputDecoration(
        labelText: widget.confirmPasswordInputLabel ??
            _translate.set_pwd_screen_confirm_pwd,
      ),
    );
  }

  Widget _passwordRulesCheckList(PasswordState state) {
    final bool isGuessableOrPwned = state.isGuessable || state.isPwned;

    return Column(
      children: <Widget>[
        CheckListItem(
          text: _translate.set_pwd_screen_pwd_format,
          enabled: state.isValid,
        ),
        CheckListItem(
          text: _translate.set_pwd_screen_pwd_guessable,
          enabled: !isGuessableOrPwned,
          bottom: TextTypography.body_copy_mb,
        ),
      ],
    );
  }

  Widget _submitButton() {
    return ThreeOutlinedButton(
      key: const Key('setPasswordBtn'),
      onPressed: _formSubmithandler,
      child: Text(widget.submitLabel ?? _translate.button_explore),
    );
  }

  void _formSubmithandler() {
    if (_formKey.currentState!.validate()) {
      if (widget.onSubmit != null) {
        widget.onSubmit!(_pwdController.text);
      }
    }
  }
}
