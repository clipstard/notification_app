import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_app/constants/colors.dart';
import 'package:notification_app/constants/typography.dart';
import 'package:notification_app/localization.dart';
import 'package:notification_app/logic/bloc/otp/otp_bloc.dart';
import 'package:notification_app/presentation/router/app_router.dart';
import 'package:notification_app/presentation/router/route_builder.dart';
import 'package:notification_app/presentation/screens/otp_screen.dart';
import 'package:notification_app/presentation/screens/retry_sreen.dart';
import 'package:notification_app/presentation/widgets/alert.dart';
import 'package:notification_app/services/snackbar_service.dart';

class OtpContainer extends StatelessWidget {
  final Widget child;
  final Function(BuildContext, Widget) onRetry;
  final Function(
    BuildContext context,
    Widget widget,
    String msisdn,
    String token,
  ) onValidated;
  final Function(BuildContext, Widget, OtpState)? onEventsChanges;
  final String? wrongOtpErrorMessage;
  final Widget? wrongOtpErrorDescription;
  final Widget? ref;

  OtpContainer({
    required this.child,
    required this.onRetry,
    required this.onValidated,
    this.onEventsChanges,
    this.wrongOtpErrorMessage,
    this.wrongOtpErrorDescription,
    this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OtpBloc, OtpState>(
      listener: _listenOtpEvents,
      builder: (BuildContext context, OtpState state) => Column(
        children: <Widget>[
          _buildAlert(context, state),
          child,
        ],
      ),
    );
  }

  Widget _buildAlert(BuildContext context, OtpState state) {
    final AppLocalizations _translate = AppLocalizations.of(context)!;
    String? title = null;
    Widget? description = null;

    if (state is OtpRequestErrored) {
      title = state.message ?? _translate.register_screen_error;
      description = _defaultFAQText(context);
    }

    if (state is OtpRequestNegative) {
      title = wrongOtpErrorMessage ?? state.message ?? _translate.generic_error;
      description = wrongOtpErrorDescription ?? _defaultFAQText(context);
    }

    return (title != null)
        ? Alert(
            title: title,
            child: description,
            variant: AlertVariant.info,
          )
        : Container();
  }

  Widget _defaultFAQText(BuildContext context) {
    AppLocalizations _translate = AppLocalizations.of(context)!;
    TextStyle _defaultStyle = TextTypography.body_copy.copyWith(
      color: ColorPalette.liquorice,
    );

    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: _translate.info_block_default_error_before_faq,
            style: _defaultStyle,
          ),
          TextSpan(
            text: _translate.faq_page,
            style: TextTypography.link,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.of(context).pushNamed(AppRouter.faq);
              },
          ),
          TextSpan(
            text: _translate.info_block_default_error_after_faq,
            style: _defaultStyle,
          ),
        ],
      ),
    );
  }

  void _listenOtpEvents(BuildContext context, OtpState state) {
    final AppLocalizations _translate = AppLocalizations.of(context)!;

    /// OTP events interceptor
    if (onEventsChanges != null) {
      onEventsChanges!(context, this, state);
    }

    /// OTP events requires snackbar message
    if (state is OtpRequested) {
      _showSnackbar(context, _translate.otp_snackbar_text);
    } else if (state is OtpRequestErrored) {
      _showSnackbar(context, state.message);
    } else if (state is OtpRequestNegative) {
      _showSnackbar(context, state.message);
    } else if (state is OtpRejected) {
      _showSnackbar(context, null);
    }

    /// OTP events requires navigation
    if (state is OtpRequested) {
      Navigator.of(context).pushReplacement(
        RouteBuilder<OTPScreen>(
          active: ref!,
          next: OTPScreen(
            otpData: state.otpData,
            otpType: state.otpType,
            onValidated: onValidated,
            onRetry: onRetry,
          ),
        ),
      );
    }

    if (state is OtpAttemptsExceeded) {
      Navigator.of(context).pushReplacement(
        RouteBuilder<RetryScreen>(
          active: ref!,
          next: RetryScreen(
            lockTime: state.dueDate,
            description: AppLocalizations.of(context)!.otp_max_attempts,
            onRetry: (BuildContext context, Widget widget) {
              context.read<OtpBloc>().otpRepository.clearAttempts(state.msisdn);
              onRetry(context, widget);
            },
          ),
        ),
      );
    }
  }

  void _showSnackbar(BuildContext context, String? message) {
    SnackbarService.showWarning(
      context,
      message: message ?? AppLocalizations.of(context)!.generic_error,
    );
  }
}
