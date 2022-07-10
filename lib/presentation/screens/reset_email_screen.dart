import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_app/data/models/custom_field.dart';
import 'package:notification_app/data/models/loyalty_program.dart';
import 'package:notification_app/data/repositories/authentication_repository.dart';
import 'package:notification_app/data/repositories/loyalty_program_repository.dart';
import 'package:notification_app/localization.dart';
import 'package:notification_app/logic/bloc/auth/authentication_bloc.dart';
import 'package:notification_app/logic/bloc/loyalty_program/loyalty_program_bloc.dart';
import 'package:notification_app/logic/form_submission_status.dart';
import 'package:notification_app/presentation/router/route_builder.dart';
import 'package:notification_app/presentation/screens/home_screen.dart';
import 'package:notification_app/presentation/widgets/alert.dart';
import 'package:notification_app/presentation/widgets/default_app_bar.dart';
import 'package:notification_app/presentation/widgets/floating_input.dart';
import 'package:notification_app/presentation/widgets/heading.dart';
import 'package:notification_app/presentation/widgets/outlined_button/outlined_button.dart';
import 'package:notification_app/presentation/wrappers/scrollable_page.dart';
import 'package:notification_app/utils/utils.dart';

class ResetEmailScreen extends StatefulWidget {
  ResetEmailScreen({
    LoyaltyProgramRepository? loyaltyProgramRepository,
    Key? key,
  }) : super(key: key);

  @override
  _ResetEmailScreenState createState() => _ResetEmailScreenState();
}

class _ResetEmailScreenState extends State<ResetEmailScreen> {
  late AppLocalizations _translate;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _emailFieldKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _confirmEmailFieldKey =
      GlobalKey<FormFieldState<String>>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmEmailContoller = TextEditingController();
  String _email = '';

  LoyaltyProgram get loyaltyProgram {
    return BlocProvider.of<AuthenticationBloc>(context).state.loyaltyProgram;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _confirmEmailContoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _translate = AppLocalizations.of(context)!;

    return BlocProvider<LoyaltyProgramBloc>(
      create: (BuildContext context) => LoyaltyProgramBloc(
        loyaltyProgramRepository: context.read<LoyaltyProgramRepository>(),
        authenticationRepository: context.read<AuthenticationRepository>(),
      ),
      child: Scaffold(
        appBar: DefaultAppBar(),
        body: ScrollablePage(
          child: BlocConsumer<LoyaltyProgramBloc, LoyaltyProgramState>(
            listener: (BuildContext context, LoyaltyProgramState state) {
              if (state.status is SubmissionSuccess) {
                _navigateBackWithStateReload(context);
              }
            },
            builder: (BuildContext context, LoyaltyProgramState state) {
              return Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (state.status is SubmissionFailed)
                      Alert(
                        title: state.status.exception.toString(),
                        variant: AlertVariant.warning,
                      ),
                    Heading(_translate.reset_email_screen_title),
                    const SizedBox(height: 10),
                    _emailInput(),
                    _confirmEmailInput(),
                    const SizedBox(height: 10),
                    _saveButton(context),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _navigateBackWithStateReload(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      RouteBuilder<Widget>(
        active: widget,
        next: HomeScreen(
          activeTab: HomeNavbarIndex.Settings,
        ),
      ),
      (Route<dynamic> route) => false,
    );
  }

  void _formSubmitHandler(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<LoyaltyProgramBloc>().add(UpdateUserInfoCustomField(
            loyaltyProgram: loyaltyProgram,
            customField: CustomField(
              name: CustomField.email,
              value: _email.trim(),
            ),
          ));
    }
  }

  Widget _emailInput() {
    return Container(
      key: const Key('emailInput'),
      child: FloatingInput(
        formFieldKey: _emailFieldKey,
        validateOnFocusOut: true,
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        validator: Validators.compose(
          <String? Function(String?)>[
            Validators.required(_translate.required),
            Validators.email(),
          ],
        ),
        decoration: InputDecoration(
          labelText: _translate.reset_email_screen_email,
        ),
        onChanged: (String value) {
          setState(() {
            _email = value;
          });
        },
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget _confirmEmailInput() {
    return Container(
      key: const Key('confirmEmailInput'),
      child: FloatingInput(
        formFieldKey: _confirmEmailFieldKey,
        validateOnFocusOut: true,
        controller: _confirmEmailContoller,
        keyboardType: TextInputType.emailAddress,
        validator: Validators.compose(
          <String? Function(String?)>[
            Validators.required(_translate.required),
            Validators.email(),
            Validators.match(_email, false),
          ],
        ),
        decoration: InputDecoration(
          labelText: _translate.reset_email_screen_email_confirm,
        ),
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (_) => _formSubmitHandler(context),
      ),
    );
  }

  Widget _saveButton(BuildContext context) {
    return SizedBox(
      child: ThreeOutlinedButton(
        key: const Key('saveButton'),
        onPressed: () => _formSubmitHandler(context),
        child: Text(_translate.button_save_changes),
      ),
    );
  }
}
