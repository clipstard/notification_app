import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_app/constants/colors.dart';
import 'package:notification_app/localization.dart';
import 'package:notification_app/logic/bloc/auth/authentication_bloc.dart';
import 'package:notification_app/presentation/widgets/default_app_bar.dart';
import 'package:notification_app/presentation/widgets/heading.dart';
import 'package:notification_app/presentation/widgets/outlined_button/outlined_button.dart';
import 'package:notification_app/presentation/wrappers/scrollable_page.dart';
import 'package:notification_app/services/local_storage_service.dart';
import 'package:notification_app/services/secure_storage_service.dart';

class UnregisterConfirmationScreen extends StatelessWidget {
  UnregisterConfirmationScreen({Key? key}) : super(key: key);
  final SecureStorage _secureStorage = SecureStorage();
  final LocalStorage _localStorage = LocalStorage();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations _translate = AppLocalizations.of(context)!;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: DefaultAppBar(
        logoTheme: LogoTheme.dark,
        displayLeading: true,
        leading: _buildCloseButton(context),
      ),
      body: ScrollablePage(
        bgGradient: true,
        intrinsicHeight: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Heading(
                          _translate.unregister_confirmation_screen_title,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          _translate.unregister_confirmation_screen_content,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final AppLocalizations _translate = AppLocalizations.of(context)!;

    return Column(
      children: <Widget>[
        ThreeOutlinedButton(
          onPressed: () => _handleDeregister(context),
          margin: EdgeInsets.zero,
          text: _translate.ok,
        ),
        SizedBox(height: 40)
      ],
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return IconButton(
        color: Colors.green,
        iconSize: 20,
        icon: Icon(
          Icons.close,
          color: ColorPalette.liquorice,
        ),
        onPressed: () => _handleDeregister(context));
  }

  void _handleDeregister(BuildContext context) {
    _secureStorage.deleteAll();
    _localStorage.clear();
    context.read<AuthenticationBloc>().add(AuthenticationLogoutRequested());
  }
}
