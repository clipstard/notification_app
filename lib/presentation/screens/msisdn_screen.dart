import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_app/constants/colors.dart';
import 'package:notification_app/constants/dimension.dart';
import 'package:notification_app/constants/typography.dart';
import 'package:notification_app/data/providers/otp_provider.dart';
import 'package:notification_app/data/repositories/otp_repository.dart';
import 'package:notification_app/localization.dart';
import 'package:notification_app/logic/bloc/otp/otp_bloc.dart';
import 'package:notification_app/presentation/router/app_router.dart';
import 'package:notification_app/presentation/router/route_builder.dart';
import 'package:notification_app/presentation/screens/details_screen.dart';
import 'package:notification_app/presentation/screens/login_screen.dart';
import 'package:notification_app/presentation/widgets/default_app_bar.dart';
import 'package:notification_app/presentation/widgets/heading.dart';
import 'package:notification_app/presentation/widgets/link.dart';
import 'package:notification_app/presentation/wrappers/otp_container.dart';
import 'package:notification_app/presentation/wrappers/scrollable_page.dart';
import 'package:notification_app/presentation/widgets/forms/msisdn_form.dart';

class MsisdnScreen extends StatefulWidget {
  MsisdnScreen();

  @override
  _MsisdnScreenState createState() => _MsisdnScreenState();
}

class _MsisdnScreenState extends State<MsisdnScreen> {
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
                _headerSubtitle(),
                _conditionText(),
                BlocBuilder<OtpBloc, OtpState>(
                    builder: (BuildContext context, OtpState state) {
                  return MsisdnForm(
                    errorMessage: _errorMessage,
                    onSubmit: (String msisdn) {
                      _setError(null);
                      context.read<OtpBloc>().add(OtpRequestedEvent(
                            msisdn,
                            otpType: OtpType.Register,
                          ));
                    },
                  );
                }),
                _loginLink(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginLink(BuildContext context) {
    return Link(
      AppLocalizations.of(context)!.login_if_have_account,
      onTap: () {
        Navigator.of(context).pushReplacement(
          RouteBuilder<LoginScreen>(
            active: widget,
            next: LoginScreen(),
          ),
        );
      },
    );
  }

  Widget _headerTitle() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Heading(
        _translate.register_screen_start,
        type: HeadingType.h4,
      ),
    );
  }

  Widget _headerSubtitle() {
    return Heading(
      _translate.register_screen_phone_number_title,
      type: HeadingType.h2,
    );
  }

  Widget _conditionText() {
    return Container(
      padding: EdgeInsets.only(bottom: Dimension.yAxisPadding),
      child: Text(_translate.register_screen_condition),
    );
  }

  void _onRetry(BuildContext context, Widget widget) {
    Navigator.of(context).pushReplacement(
      RouteBuilder<MsisdnScreen>(
        active: widget,
        next: MsisdnScreen(),
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
      RouteBuilder<DetailsScreen>(
        active: widget,
        next: DetailsScreen(
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
