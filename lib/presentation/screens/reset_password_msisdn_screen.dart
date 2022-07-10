import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_app/constants/colors.dart';
import 'package:notification_app/constants/typography.dart';
import 'package:notification_app/data/providers/otp_provider.dart';
import 'package:notification_app/data/repositories/otp_repository.dart';
import 'package:notification_app/localization.dart';
import 'package:notification_app/logic/bloc/otp/otp_bloc.dart';
import 'package:notification_app/presentation/router/app_router.dart';
import 'package:notification_app/presentation/router/route_builder.dart';
import 'package:notification_app/presentation/screens/reset_password_screen.dart';
import 'package:notification_app/presentation/widgets/default_app_bar.dart';
import 'package:notification_app/presentation/widgets/heading.dart';
import 'package:notification_app/presentation/wrappers/otp_container.dart';
import 'package:notification_app/presentation/wrappers/scrollable_page.dart';
import 'package:notification_app/presentation/widgets/forms/msisdn_form.dart';

class ResetPasswordMsisdnScreen extends StatefulWidget {
  ResetPasswordMsisdnScreen();

  @override
  _ResetPasswordMsisdnScreen createState() => _ResetPasswordMsisdnScreen();
}

class _ResetPasswordMsisdnScreen extends State<ResetPasswordMsisdnScreen> {
  late AppLocalizations _translate = AppLocalizations.of(context)!;

  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OtpBloc>(
      create: (_) =>
          OtpBloc(otpRepository: OtpRepository())..add(OtpInitEvent()),
      child: Scaffold(
        appBar: DefaultAppBar(),
        body: ScrollablePage(
          child: OtpContainer(
            ref: widget,
            onRetry: _onRetry,
            onValidated: _onValidated,
            onEventsChanges: _onEventsChanges,
            wrongOtpErrorMessage: _translate.info_block_title,
            wrongOtpErrorDescription: _registerFAQText,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _headerTitle(),
                BlocBuilder<OtpBloc, OtpState>(
                    builder: (BuildContext context, OtpState state) {
                  return Flexible(
                    flex: 1,
                    child: MsisdnForm(
                      errorMessage: _errorMessage,
                      shouldConfirm: false,
                      buttonLabel: _translate.button_next,
                      onSubmit: (String msisdn) {
                        _setError(null);
                        context.read<OtpBloc>().add(OtpRequestedEvent(
                              msisdn,
                              otpType: OtpType.Password,
                            ));
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerTitle() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Heading(
        _translate.reset_password_title,
        type: HeadingType.h1,
      ),
    );
  }

  void _onRetry(BuildContext context, Widget widget) {
    Navigator.of(context).pushReplacement(
      RouteBuilder<ResetPasswordMsisdnScreen>(
        active: widget,
        next: ResetPasswordMsisdnScreen(),
      ),
    );
  }

  void _onValidated(
    BuildContext context,
    Widget widget,
    String msisdn,
    String token,
  ) {
    Navigator.of(context).pushReplacement(
      RouteBuilder<ResetPasswordScreen>(
        active: widget,
        next: ResetPasswordScreen(
          msisdn: msisdn,
          token: token,
        ),
      ),
    );
  }

  void _onEventsChanges(BuildContext context, Widget widget, OtpState state) {
    if (state is OtpRequestErrored) {
      _setError(state.message ?? _translate.register_screen_error);
    } else if (state is OtpRequestNegative) {
      _setError(state.message ?? _translate.generic_error);
    } else if (state is OtpRejected) {
      _setError(null);
    }
  }

  void _setError(String? error) {
    setState(() {
      _errorMessage = error;
    });
  }

  RichText get _registerFAQText {
    TextStyle _defaultStyle = TextTypography.body_copy.copyWith(
      color: ColorPalette.liquorice,
    );

    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: _translate.info_block_register_error_before_faq,
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
            text: _translate.info_block_register_error_after_faq,
            style: _defaultStyle,
          ),
        ],
      ),
    );
  }
}
