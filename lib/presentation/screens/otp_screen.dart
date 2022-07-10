import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_app/data/models/otp_data.dart';
import 'package:notification_app/data/providers/otp_provider.dart';
import 'package:notification_app/data/repositories/otp_repository.dart';
import 'package:notification_app/localization.dart';
import 'package:notification_app/logic/bloc/otp/otp_bloc.dart';
import 'package:notification_app/presentation/router/route_builder.dart';
import 'package:notification_app/presentation/screens/retry_sreen.dart';
import 'package:notification_app/presentation/wrappers/scrollable_page.dart';
import 'package:notification_app/presentation/widgets/link.dart';
import 'package:notification_app/presentation/widgets/default_app_bar.dart';
import 'package:notification_app/presentation/widgets/heading.dart';
import 'package:notification_app/presentation/widgets/outlined_button/outlined_button.dart';
import 'package:notification_app/presentation/widgets/underlined_input.dart';
import 'package:notification_app/services/snackbar_service.dart';
import 'package:notification_app/utils/utils.dart'
    show Validators, routeObserver;

class OTPScreen extends StatefulWidget {
  final OTPData otpData;
  final Function(
    BuildContext context,
    Widget widget,
    String msisdn,
    String token,
  ) onValidated;
  final Function(BuildContext, Widget) onRetry;
  final Function(BuildContext, Widget, OtpState)? onEventsChanges;
  final OtpType otpType;

  OTPScreen({
    required this.otpData,
    required this.otpType,
    required this.onValidated,
    required this.onRetry,
    this.onEventsChanges,
    Key? key,
  }) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> with RouteAware {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _otpField =
      GlobalObjectKey<FormFieldState<String>>(Object());
  final TextEditingController _otpController = TextEditingController();
  late OTPData _otpData;
  late OtpType _otpType;
  late AppLocalizations _translate;
  late OtpBloc _provider;
  String? _inputError;
  bool _otpRequested = false;
  final FocusNode _inputNode = FocusNode();

  String get otpCode => _otpController.text;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _otpData = widget.otpData;
      _otpType = widget.otpType;
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _otpController.dispose();
    super.dispose();
  }

  @override
  void didPop() {
    _provider.add(OtpInitEvent());
    super.didPop();
  }

  void _setInputError(String? error) {
    setState(() {
      _inputError = error;
    });
  }

  void _showSnackBar(String? message) {
    SnackbarService.showWarning(
      context,
      message: message ?? _translate.generic_error,
    );
  }

  void _listener(BuildContext context, OtpState state) {
    if (state is OtpRequested) {
      setState(() {
        _otpRequested = true;
        _otpData = state.otpData;
        _otpType = state.otpType;
        _inputError = null;
      });

      _otpController.text = '';
      _inputNode.requestFocus();

      _showSnackBar(_translate.otp_snackbar_text);
    } else if (state is OtpRequestErrored) {
      _showSnackBar(state.message);
    } else if (state is OtpRejected) {
      _setInputError(_translate.otp_wrong);
    } else if (state is OtpRequestNegative) {
      _showSnackBar(state.message);
    } else if (state is OtpValidated) {
      unfocus();
      widget.onValidated(
        context,
        widget,
        state.otpData.msisdn,
        state.toToken(),
      );
    } else if (state is OtpAttemptsExceeded) {
      Navigator.of(context).pushReplacement(
        RouteBuilder<RetryScreen>(
          active: widget,
          next: RetryScreen(
            lockTime: state.dueDate,
            description: AppLocalizations.of(context)!.otp_max_attempts,
            onRetry: widget.onRetry,
          ),
        ),
      );
    }
  }

  void unfocus() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    _translate = AppLocalizations.of(context)!;

    return BlocProvider<OtpBloc>(
      create: (BuildContext context) {
        _provider = OtpBloc(
          otpRepository: OtpRepository(),
        );
        return _provider;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: DefaultAppBar(),
        body: ScrollablePage(
          child: BlocListener<OtpBloc, OtpState>(
            listener: _listener,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _headerTitle(),
                _headerSubtitle(),
                Flexible(
                  flex: 1,
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _passwordField(),
                        _submitButton(),
                        _resendPasswordLink(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerTitle() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Heading(
        _translate.otp_start,
        type: HeadingType.h4,
      ),
    );
  }

  Widget _headerSubtitle() {
    return Heading(
      _translate.otp_title,
      type: HeadingType.h2,
    );
  }

  Widget _submitButton() {
    return ThreeOutlinedButton(
      onPressed: sendRequest,
      text: _translate.button_next,
    );
  }

  Widget _passwordField() {
    return UnderlinedInput(
      key: const Key('OtpInput'),
      formKey: _otpField,
      autofocus: true,
      focusNode: _inputNode,
      controller: _otpController,
      placeholder: _translate.otp_placeholder,
      onEditingComplete: sendRequest,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (String? value) {
        if (_otpRequested) {
          return null;
        }

        return Validators.required(_translate.required)(value) ?? _inputError;
      },
      keyboardType: TextInputType.phone,
    );
  }

  Widget _resendPasswordLink() {
    return Link(
      _translate.otp_link,
      onTap: () {
        unfocus();
        _setInputError(null);
        _provider.add(OtpRequestedEvent(
          _otpData.msisdn,
          otpType: _otpType,
        ));
      },
      delay: 60, // seconds
    );
  }

  Future<void> sendRequest() async {
    setState(() {
      _otpRequested = false;
      _inputError = null;
    });

    if (_otpData.requestTime.isBefore(
      DateTime.now().subtract(_otpData.validity),
    )) {
      _setInputError(_translate.otp_expired);
      _provider.add(OtpInitEvent());
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _otpData = _otpData.copyWith(
        requestTime: _otpData.requestTime..add(_otpData.validity),
      );
    });

    _provider.add(OtpValidateAttemptEvent(
      otpData: _otpData,
      otpType: _otpType,
      otpCode: otpCode,
    ));
  }
}
