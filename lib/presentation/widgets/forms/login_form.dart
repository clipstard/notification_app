import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_app/data/exceptions/network_exceptions.dart';
import 'package:notification_app/data/models/persistent_login.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notification_app/data/providers/otp_provider.dart';
import 'package:notification_app/logic/bloc/login/login_bloc.dart';
import 'package:notification_app/logic/bloc/otp/otp_bloc.dart';
import 'package:notification_app/logic/form_submission_status.dart';
import 'package:notification_app/presentation/widgets/labeled_checkbox.dart';
import 'package:notification_app/presentation/widgets/floating_input.dart';
import 'package:notification_app/presentation/widgets/outlined_button/outlined_button.dart';
import 'package:notification_app/services/local_storage_service.dart';
import 'package:notification_app/utils/validators_util.dart';

class LoginForm extends StatefulWidget {
  final PersistentLogin data;
  final Function(BuildContext, PersistentLogin, [bool]) onSubmitted;

  const LoginForm({
    required this.onSubmitted,
    Key? key,
    this.data = PersistentLogin.empty,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late AppLocalizations _translate;
  final LocalStorage _localStorage = LocalStorage();
  late bool _rememberMe;

  final TextEditingController _msisdnController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _msisdnFieldKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _pwdFieldKey =
      GlobalKey<FormFieldState<String>>();

  @override
  void initState() {
    _rememberMe = widget.data.rememberMe;
    super.initState();
  }

  @override
  void didUpdateWidget(_) {
    setState(() {
      _rememberMe = widget.data.rememberMe;
    });
    super.didUpdateWidget(_);
  }

  @override
  void dispose() {
    _msisdnController.dispose();
    _pwdController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _translate = AppLocalizations.of(context)!;

    return BlocListener<LoginBloc, LoginState>(
      listener: _checkForOtpRequested,
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (!widget.data.rememberMe) _textFieldMsisdn(),
            _buildTextFieldPassword(),
            if (!widget.data.rememberMe) _remembermeCheckbox(),
            _loginButton(context),
          ],
        ),
      ),
    );
  }

  Widget _textFieldMsisdn() {
    return FloatingInput(
      key: const Key('msisdnInput'),
      formFieldKey: _msisdnFieldKey,
      controller: _msisdnController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: Validators.compose(
        <String? Function(String?)>[
          Validators.required(_translate.required),
          Validators.email(),
        ],
      ),
      decoration: InputDecoration(
        labelText: 'Username (email)',
      ),
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildTextFieldPassword() {
    return FloatingInput(
      key: const Key('passwordInput'),
      formFieldKey: _pwdFieldKey,
      controller: _pwdController,
      enablePasswordFeatures: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: Validators.compose(
        <String? Function(String?)>[
          Validators.required(_translate.required),
        ],
      ),
      decoration: InputDecoration(
        labelText: _translate.login_screen_password,
      ),
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _formSubmitHandler(context),
    );
  }

  Widget _remembermeCheckbox() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 30,
      ),
      child: LabeledCheckbox(
        key: Key('rememberMeCheckbox'),
        child: Text(_translate.login_screen_remember_me),
        isChecked: _rememberMe,
        labelOffset: Offset(9, 0),
        onChanged: (bool value) {
          setState(() {
            _rememberMe = value;
          });
        },
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return SizedBox(
      child: ThreeOutlinedButton(
        key: const Key('loginBtn'),
        onPressed: () => _formSubmitHandler(context),
        child: Text(_translate.login_screen_submit),
      ),
    );
  }

  void _formSubmitHandler(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      widget.onSubmitted(
        context,
        PersistentLogin(
          firstName: widget.data.firstName,
          msisdn: widget.data.rememberMe
              ? widget.data.msisdn
              : _msisdnController.text,
          password: _pwdController.text,
          rememberMe: _rememberMe,
          isFirstLogin: false,
        ),

        /// Do not login, just ask for otp first time
        !widget.data.isFirstLogin,
      );
    }
  }

  void _checkForOtpRequested(BuildContext context, LoginState state) {
    final FormSubmissionStatus status = state.status;

    if (status is SubmissionSuccess) {
      _localStorage.formLoginsCount = _localStorage.formLoginsCount + 1;
    }

    if (status is SubmissionFailed &&
        status.exception is UnauthorizedException &&
        (status.exception as UnauthorizedException).reason ==
            UnauthorizedReason.OTP_NEEDED) {
      _requestOtp(context);
    }
  }

  void _requestOtp(BuildContext context) {
    context.read<OtpBloc>().add(
          OtpRequestedEvent(
            widget.data.rememberMe
                ? widget.data.msisdn
                : _msisdnController.text,
            otpType: OtpType.Renew,
          ),
        );
  }
}
