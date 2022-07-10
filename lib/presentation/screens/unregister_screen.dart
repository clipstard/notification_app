import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_app/data/models/loyalty_program.dart';
import 'package:notification_app/data/repositories/authentication_repository.dart';
import 'package:notification_app/data/repositories/loyalty_program_repository.dart';
import 'package:notification_app/localization.dart';
import 'package:notification_app/logic/bloc/auth/authentication_bloc.dart';
import 'package:notification_app/logic/bloc/loyalty_program/loyalty_program_bloc.dart';
import 'package:notification_app/logic/form_submission_status.dart';
import 'package:notification_app/presentation/router/route_builder.dart';
import 'package:notification_app/presentation/screens/unregister_confirmation_screen.dart';
import 'package:notification_app/presentation/widgets/alert.dart';
import 'package:notification_app/presentation/widgets/default_app_bar.dart';
import 'package:notification_app/presentation/widgets/heading.dart';
import 'package:notification_app/presentation/widgets/outlined_button/button_theming.dart';
import 'package:notification_app/presentation/widgets/outlined_button/outlined_button.dart';
import 'package:notification_app/presentation/wrappers/scrollable_page.dart';

class UnregisterScreen extends StatefulWidget {
  UnregisterScreen({Key? key}) : super(key: key);

  @override
  State<UnregisterScreen> createState() => _UnregisterScreenState();
}

class _UnregisterScreenState extends State<UnregisterScreen> {
  late LoyaltyProgram _loyaltyProgram;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations _translate = AppLocalizations.of(context)!;
    return BlocProvider<LoyaltyProgramBloc>(
      create: (BuildContext context) => LoyaltyProgramBloc(
        loyaltyProgramRepository: context.read<LoyaltyProgramRepository>(),
        authenticationRepository: context.read<AuthenticationRepository>(),
      ),
      child: BlocConsumer<LoyaltyProgramBloc, LoyaltyProgramState>(
        listener: (BuildContext context, LoyaltyProgramState state) {
          if (state.status is SubmissionSuccess) {
            Navigator.of(context).push(
              RouteBuilder<dynamic>(
                active: widget,
                next: UnregisterConfirmationScreen(),
              ),
            );
          }
        },
        builder: (BuildContext context, LoyaltyProgramState state) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: DefaultAppBar(logoTheme: LogoTheme.dark),
            body: ScrollablePage(
              bgGradient: true,
              intrinsicHeight: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (state.status is SubmissionFailed)
                    Alert(
                      title: state.status.exception.toString(),
                      variant: AlertVariant.warning,
                    ),
                  Expanded(
                    child: Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Heading(
                                _translate.unregister_screen_title,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                _translate.unregister_screen_content,
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
        },
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final AppLocalizations _translate = AppLocalizations.of(context)!;

    final NavigatorState _navigatorState = Navigator.of(context);
    return Column(
      children: <Widget>[
        ThreeOutlinedButton(
          onPressed: () {
            context.read<LoyaltyProgramBloc>().add(OptOutLoyaltyProgram(
                  customerId: _loyaltyProgram.customerId,
                ));
          },
          margin: EdgeInsets.zero,
          text: _translate.unregister_screen_confirm_button,
        ),
        ThreeOutlinedButton(
          onPressed: () {
            _navigatorState.pop();
          },
          buttonClassName: ButtonClassName.secondary,
          margin: EdgeInsets.only(top: 10),
          text: _translate.unregister_screen_cancel_button,
        ),
        SizedBox(height: 40)
      ],
    );
  }

  void setLoyaltyProgram() {
    _loyaltyProgram =
        BlocProvider.of<AuthenticationBloc>(context).state.loyaltyProgram;
  }

  @override
  void initState() {
    setLoyaltyProgram();
    super.initState();
  }
}
