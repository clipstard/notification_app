import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_app/constants/app_config.dart';
import 'package:notification_app/constants/colors.dart';
import 'package:notification_app/constants/typography.dart';
import 'package:notification_app/data/models/loyalty_program.dart';
import 'package:notification_app/data/repositories/loyalty_program_repository.dart';
import 'package:notification_app/localization.dart';
import 'package:notification_app/logic/bloc/auth/authentication_bloc.dart';
import 'package:notification_app/logic/bloc/push_notifications/push_notifications_bloc.dart';
import 'package:notification_app/presentation/router/route_builder.dart';
import 'package:notification_app/presentation/widgets/link.dart';
import 'package:notification_app/presentation/wrappers/scrollable_page.dart';
import 'package:notification_app/presentation/widgets/default_app_bar.dart';
import 'package:notification_app/presentation/widgets/heading.dart';
import 'package:notification_app/presentation/widgets/outlined_button/button_theming.dart';
import 'package:notification_app/presentation/widgets/outlined_button/outlined_button.dart';
import 'package:notification_app/services/push_notification_service.dart';
import 'package:notification_app/services/snackbar_service.dart';

import 'home_screen.dart';

class SetupPushNotifications extends StatelessWidget {
  final PushNotificationsService _pushNotificationsService =
      PushNotificationsService();

  late final Map<String, LoyaltyProgramRepository> __loyaltyProgramRepository =
      <String, LoyaltyProgramRepository>{};

  LoyaltyProgramRepository get _loyaltyProgramRepository {
    return __loyaltyProgramRepository['repository']!;
  }

  void set _loyaltyProgramRepository(LoyaltyProgramRepository repository) {
    __loyaltyProgramRepository['repository'] = repository;
  }

  @override
  Widget build(BuildContext context) {
    _loyaltyProgramRepository =
        RepositoryProvider.of<LoyaltyProgramRepository>(context);

    return BlocConsumer<PushNotificationsBloc, PushNotificationsState>(
      listener: (
        BuildContext listenerContext,
        PushNotificationsState state,
      ) {
        if (state is PushNotificationsEnabled) {
          _navigateHome(listenerContext, opted: true);
        } else if (state is PushNotificationsSettingsRequested) {
          _requestNotificationsSettings(listenerContext);
        } else if (state is Error) {
          SnackbarService.showWarning(
            listenerContext,
            message: state.errorMessage,
          );
        }
      },
      builder: (BuildContext builderContext, PushNotificationsState state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: DefaultAppBar(logoTheme: LogoTheme.dark),
          body: ScrollablePage(
            bgGradient: true,
            intrinsicHeight: true,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: _buildContent(builderContext),
                ),
                _buildActionButtons(builderContext),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    final AppLocalizations _translate = AppLocalizations.of(context)!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Heading(
          _translate.setup_push_notifs_screen_title,
          type: HeadingType.h2,
          target: HeadingTarget.desktop,
          textAlign: TextAlign.center,
        ),
        Text(
          _translate.setup_push_notifs_screen_description,
          style: TextTypography.body_copy,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: TextTypography.body_copy_mb),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final AppLocalizations _translate = AppLocalizations.of(context)!;
    final LoyaltyProgram loyaltyProgram =
        BlocProvider.of<AuthenticationBloc>(context).state.loyaltyProgram;

    return Column(
      children: <Widget>[
        ThreeOutlinedButton(
          onPressed: () {
            context
                .read<PushNotificationsBloc>()
                .add(PushNotificationsEnableEvent(
                  loyaltyProgram: loyaltyProgram,
                ));
          },
          child: Text(_translate.setup_push_notifs_screen_button_enable),
        ),
        ThreeOutlinedButton(
          onPressed: () => _informAboutPostpone(
            context,
            () => _navigateHome(context),
          ),
          buttonClassName: ButtonClassName.secondary,
          child: Text(_translate.setup_push_notifs_screen_button_skip),
        ),
        Link(
          _translate.setup_push_notifs_screen_button_disable,
          onTap: () {
            context
                .read<PushNotificationsBloc>()
                .add(PushNotificationsDisableEvent(
                  loyaltyProgram: loyaltyProgram,
                ));
          },
          color: ColorPalette.blueberryDark,
        ),
      ],
    );
  }

  void _navigateHome(BuildContext context, {bool opted = false}) {
    Navigator.pushReplacement(
      context,
      RouteBuilder<HomeScreen>(
        active: this,
        next: HomeScreen(optIn: opted),
      ),
    );
  }

  void _informAboutPostpone(BuildContext context, VoidCallback onConfirm) {
    final AppLocalizations _translate = AppLocalizations.of(context)!;

    if (!Platform.isIOS) {
      _storePostponeInfo();
      onConfirm();
      return;
    }

    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(
          _translate.setup_push_notifs_screen_remind_in_days(
            AppConfig.pushNotificationsDelayDays,
          ),
        ),
        actions: <CupertinoButton>[
          CupertinoButton(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: Text(
              _translate.ok,
              style: TextStyle(
                color: CupertinoColors.activeBlue,
              ),
            ),
            onPressed: () {
              _storePostponeInfo();
              onConfirm();
            },
          ),
        ],
      ),
    );
  }

  void _storePostponeInfo() async {
    String? token = await _pushNotificationsService.getPushNotificationsToken();
    if (token != null) {
      _loyaltyProgramRepository.storePostponeInfo(token);
    }
  }

  void _requestNotificationsSettings(BuildContext context) {
    final AppLocalizations _translate = AppLocalizations.of(context)!;

    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(
          _translate.setup_push_notifs_screen_no_permissions_title,
        ),
        content: Text(
          _translate.setup_push_notifs_screen_no_permissions_description(
              _translate.app_name),
        ),
        actions: <CupertinoButton>[
          CupertinoButton(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: Text(
              _translate.settings,
              style: TextStyle(
                color: CupertinoColors.activeBlue,
              ),
            ),
            onPressed: () {
              AppSettings.openNotificationSettings();
              Navigator.of(context).pop();
            },
          ),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: Text(
              _translate.cancel,
              style: TextStyle(
                color: CupertinoColors.activeBlue,
              ),
            ),
            onPressed: () {
              context
                  .read<PushNotificationsBloc>()
                  .add(PushNotificationsDisallowEvent());
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
