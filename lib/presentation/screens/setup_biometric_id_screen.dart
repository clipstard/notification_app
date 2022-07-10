import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:notification_app/constants/icons.dart';
import 'package:notification_app/constants/typography.dart';
import 'package:notification_app/localization.dart';
import 'package:notification_app/logic/bloc/biometric/biometric_bloc.dart';
import 'package:notification_app/presentation/router/route_builder.dart';
import 'package:notification_app/presentation/screens/setup_push_notifications_screen.dart';
import 'package:notification_app/presentation/wrappers/scrollable_page.dart';
import 'package:notification_app/presentation/widgets/default_app_bar.dart';
import 'package:notification_app/presentation/widgets/heading.dart';
import 'package:notification_app/presentation/widgets/outlined_button/button_theming.dart';
import 'package:notification_app/presentation/widgets/outlined_button/outlined_button.dart';

class SetupBiometricIdScreen extends StatelessWidget {
  SetupBiometricIdScreen(BiometricType this.biometricId);

  final BiometricType? biometricId;

  double _getAvailableHeight(BuildContext context) {
    return MediaQuery.of(context).size.height -
        DefaultAppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BiometricIdBloc>(
      create: (BuildContext context) => BiometricIdBloc(),
      child: BlocConsumer<BiometricIdBloc, BiometricIdState>(
        listener: (BuildContext context, BiometricIdState state) {
          if (state is BiometricIdConsentSavedState) {
            Navigator.pushReplacement(
              context,
              RouteBuilder<SetupPushNotifications>(
                active: this,
                next: SetupPushNotifications(),
              ),
            );
          }
        },
        builder: (BuildContext context, BiometricIdState state) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: DefaultAppBar(logoTheme: LogoTheme.dark),
            body: ScrollablePage(
              bgGradient: true,
              intrinsicHeight: true,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: _getAvailableHeight(context) * 0.1),
                        _buildIcon(),
                        SizedBox(height: 40),
                        _buildContent(context),
                      ],
                    ),
                  ),
                  _buildActionButtons(context, state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIcon() {
    IconData icon = this.biometricId == BiometricType.face
        ? ThreeIcons.face_id
        : ThreeIcons.touch_id;

    return Icon(
      icon,
      size: 62,
    );
  }

  Widget _buildContent(BuildContext context) {
    final AppLocalizations _translate = AppLocalizations.of(context)!;

    return Column(
      children: <Widget>[
        Heading(
          _translate.setup_biometric_screen_title,
          type: HeadingType.h2,
          target: HeadingTarget.desktop,
        ),
        Text(
          _translate.setup_biometric_screen_description,
          style: TextTypography.body_copy,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: TextTypography.body_copy_mb),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, BiometricIdState state) {
    final AppLocalizations _translate = AppLocalizations.of(context)!;

    String biometricIdLabel;

    switch (biometricId) {
      case BiometricType.face:
        biometricIdLabel = _translate.setup_biometric_screen_face_id;
        break;
      case BiometricType.fingerprint:
      default:
        biometricIdLabel = Platform.isIOS
            ? _translate.setup_biometric_screen_touch_id
            : _translate.setup_biometric_screen_fingerprint;
        break;
    }

    return Column(
      children: <Widget>[
        ThreeOutlinedButton(
          onPressed: () {
            context
                .read<BiometricIdBloc>()
                .add(BiometricIdConsentSaveEvent(value: true));
          },
          child: Text(
              _translate.setup_biometric_screen_biometric_id(biometricIdLabel)),
        ),
        ThreeOutlinedButton(
          onPressed: () {
            context
                .read<BiometricIdBloc>()
                .add(BiometricIdConsentSaveEvent(value: false));
          },
          buttonClassName: ButtonClassName.secondary,
          margin: EdgeInsets.zero,
          child: Text(_translate.setup_biometric_screen_button_skip),
        ),
      ],
    );
  }
}

class SetupBiometricIdArguments {
  final BiometricType biometricId;

  SetupBiometricIdArguments(this.biometricId);
}
