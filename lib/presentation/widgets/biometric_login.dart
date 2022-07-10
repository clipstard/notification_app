import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:notification_app/logic/bloc/biometric/biometric_bloc.dart';
import 'package:notification_app/constants/icons.dart';
import 'package:notification_app/localization.dart';
import 'package:notification_app/logic/bloc/login/login_bloc.dart';
import 'package:notification_app/presentation/widgets/heading.dart';
import 'package:notification_app/presentation/widgets/link.dart';

class BiometricLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BiometricIdBloc, BiometricIdState>(
        builder: (BuildContext context, BiometricIdState state) {
      if (state is BiometricIdAvailableState) {
        return Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Divider(height: 60),
              _biometricTitle(context),
              SizedBox(height: 22),
              _buildBiometricIcon(state.biometricId, context),
              _buildUseBiomentricLink(context),
            ],
          ),
        );
      }

      return Container();
    });
  }

  Widget _biometricTitle(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Heading(
        AppLocalizations.of(context)!.login_screen_biometrics_title,
        type: HeadingType.h2,
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildBiometricIcon(BiometricType biometricId, BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () => _requestBiometricLogin(context),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: (biometricId == BiometricType.face)
              ? const Icon(ThreeIcons.face_id, size: 50)
              : const Icon(ThreeIcons.touch_id, size: 60),
        ),
        if (biometricId == BiometricType.face) const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildUseBiomentricLink(BuildContext context) {
    return Link(
      AppLocalizations.of(context)!.login_screen_use_biometrics,
      onTap: () => _requestBiometricLogin(context),
      inline: true,
    );
  }

  void _requestBiometricLogin(BuildContext context) {
    context.read<LoginBloc>().add(LoginWithBiometricRequested(
        AppLocalizations.of(context)!.login_screen_biometric_reason));
  }
}
