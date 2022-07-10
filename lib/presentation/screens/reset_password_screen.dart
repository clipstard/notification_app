import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_app/constants/dimension.dart';
import 'package:notification_app/data/repositories/password_repository.dart';
import 'package:notification_app/localization.dart';
import 'package:notification_app/logic/bloc/password/password_bloc.dart';
import 'package:notification_app/logic/form_submission_status.dart';
import 'package:notification_app/presentation/router/route_builder.dart';
import 'package:notification_app/presentation/screens/home_screen.dart';
import 'package:notification_app/presentation/widgets/alert.dart';
import 'package:notification_app/presentation/wrappers/scrollable_page.dart';
import 'package:notification_app/presentation/widgets/default_app_bar.dart';
import 'package:notification_app/presentation/widgets/heading.dart';
import 'package:notification_app/presentation/widgets/forms/set_password_form.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String msisdn;
  final String token;

  final PasswordRepository _passwordRepository;

  ResetPasswordScreen({
    required this.msisdn,
    required this.token,
    PasswordRepository? passwordRepository,
  }) : _passwordRepository = passwordRepository ?? PasswordRepository();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<PasswordRepository>(
      create: (_) => _passwordRepository,
      child: BlocConsumer<PasswordBloc, PasswordState>(
        listener: (BuildContext context, PasswordState state) {
          if (state.status is SubmissionSuccess) {
            _navigateHomeScreen(context);
          }
        },
        builder: (BuildContext context, PasswordState state) {
          return BlocProvider<PasswordBloc>(
            create: (_) =>
                PasswordBloc(passwordRepository: _passwordRepository),
            child: Builder(
              builder: (BuildContext builderContext) =>
                  _buildScreen(builderContext, state),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScreen(BuildContext context, PasswordState state) {
    late AppLocalizations _translate = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: DefaultAppBar(),
      body: ScrollablePage(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Heading(
              _translate.reset_password_pwd_screen_title,
              type: HeadingType.h2,
              target: HeadingTarget.desktop,
            ),
            SizedBox(height: Dimension.spacer),
            if (state.status is SubmissionFailed)
              Alert(
                title: state.status.exception.toString(),
                variant: AlertVariant.warning,
              ),
            SetPasswordForm(
              submitLabel: _translate.button_save_changes,
              onSubmit: (String password) async {
                context.read<PasswordBloc>().add(UpdateUserPassword(
                      msisdn: msisdn,
                      password: password,
                      token: token,
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateHomeScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      RouteBuilder<HomeScreen>(
        active: this,
        next: HomeScreen(),
      ),
    );
  }
}
