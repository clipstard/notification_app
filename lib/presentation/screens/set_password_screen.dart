import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:notification_app/constants/dimension.dart';
import 'package:notification_app/data/models/loyalty_program.dart';
import 'package:notification_app/data/models/user.dart';
import 'package:notification_app/data/repositories/authentication_repository.dart';
import 'package:notification_app/data/repositories/loyalty_program_repository.dart';
import 'package:notification_app/data/repositories/password_repository.dart';
import 'package:notification_app/localization.dart';
import 'package:notification_app/logic/bloc/biometric/biometric_bloc.dart';
import 'package:notification_app/logic/bloc/loyalty_program/loyalty_program_bloc.dart';
import 'package:notification_app/logic/bloc/password/password_bloc.dart';
import 'package:notification_app/logic/form_submission_status.dart';
import 'package:notification_app/presentation/router/route_builder.dart';
import 'package:notification_app/presentation/screens/setup_biometric_id_screen.dart';
import 'package:notification_app/presentation/screens/setup_push_notifications_screen.dart';
import 'package:notification_app/presentation/widgets/alert.dart';
import 'package:notification_app/presentation/wrappers/scrollable_page.dart';
import 'package:notification_app/presentation/widgets/default_app_bar.dart';
import 'package:notification_app/presentation/widgets/heading.dart';
import 'package:notification_app/presentation/widgets/forms/set_password_form.dart';

class SetPasswordScreen extends StatelessWidget {
  final LoyaltyProgram loyaltyProgram;
  final String token;

  SetPasswordScreen({
    required this.loyaltyProgram,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    final PasswordRepository _passwordRepository = PasswordRepository();

    return RepositoryProvider<PasswordRepository>(
      create: (_) => _passwordRepository,
      child: MultiBlocProvider(
        // ignore: always_specify_types
        providers: [
          BlocProvider<PasswordBloc>(
            create: (_) => PasswordBloc(
              passwordRepository: _passwordRepository,
            ),
          ),
          BlocProvider<BiometricIdBloc>(
            create: (_) => BiometricIdBloc(),
          ),
          BlocProvider<LoyaltyProgramBloc>(
            create: (_) => LoyaltyProgramBloc(
              loyaltyProgramRepository:
                  context.read<LoyaltyProgramRepository>(),
              authenticationRepository:
                  context.read<AuthenticationRepository>(),
            ),
          ),
        ],
        child: MultiBlocListener(
          // ignore: always_specify_types
          listeners: [
            BlocListener<LoyaltyProgramBloc, LoyaltyProgramState>(
              listener: (BuildContext context, LoyaltyProgramState state) {
                if (state.status is SubmissionSuccess) {
                  context
                      .read<BiometricIdBloc>()
                      .add(BiometricIdCheckAvailabilityEvent());
                }
              },
            ),
            BlocListener<BiometricIdBloc, BiometricIdState>(
              listener: (BuildContext context, BiometricIdState state) {
                if (state is BiometricIdAvailableState) {
                  _navigateSetupBiometricScreen(
                    context,
                    state.biometricId,
                  );
                } else if (state is BiometricIdUnavailableState) {
                  _navigatePushNotificationsScreen(context);
                }
              },
            ),
          ],
          child: BlocBuilder<LoyaltyProgramBloc, LoyaltyProgramState>(
            builder: (BuildContext context, LoyaltyProgramState state) =>
                _buildScreen(context, state),
          ),
        ),
      ),
    );
  }

  Widget _buildScreen(BuildContext context, LoyaltyProgramState state) {
    late AppLocalizations _translate = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: DefaultAppBar(),
      body: ScrollablePage(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (state.status is SubmissionFailed)
              Alert(
                title: state.status.exception.toString(),
                variant: AlertVariant.warning,
              ),
            Heading(
              _translate.set_pwd_screen_title,
              type: HeadingType.h2,
              target: HeadingTarget.desktop,
            ),
            SizedBox(height: Dimension.spacer),
            SetPasswordForm(
              onSubmit: (String password) {
                if (password.isNotEmpty) {
                  final User user =
                      loyaltyProgram.userInfos!.copyWith(password: password);
                  final LoyaltyProgram _loyaltyProgram =
                      loyaltyProgram.copyWith(userInfos: user);

                  context.read<LoyaltyProgramBloc>().add(OptInLoyaltyProgram(
                        loyaltyProgram: _loyaltyProgram,
                        token: token,
                      ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateSetupBiometricScreen(
    BuildContext context,
    BiometricType biometricId,
  ) {
    Navigator.pushReplacement(
      context,
      RouteBuilder<SetupBiometricIdScreen>(
        active: this,
        next: SetupBiometricIdScreen(biometricId),
      ),
    );
  }

  void _navigatePushNotificationsScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      RouteBuilder<SetupPushNotifications>(
        active: this,
        next: SetupPushNotifications(),
      ),
    );
  }
}
