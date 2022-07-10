import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:notification_app/constants/app_config.dart';
import 'package:notification_app/constants/colors.dart';
import 'package:notification_app/constants/typography.dart';
import 'package:notification_app/data/models/custom_field.dart';
import 'package:notification_app/data/models/loyalty_program.dart';
import 'package:notification_app/data/models/consent.dart';
import 'package:notification_app/data/models/user.dart';
import 'package:notification_app/localization.dart';
import 'package:notification_app/presentation/router/route_builder.dart';
import 'package:notification_app/presentation/screens/privacy_policy_screen.dart';
import 'package:notification_app/presentation/screens/set_password_screen.dart';
import 'package:notification_app/presentation/screens/terms_and_conditions_screen.dart';
import 'package:notification_app/presentation/widgets/app_switch.dart';
import 'package:notification_app/presentation/widgets/default_app_bar.dart';
import 'package:notification_app/presentation/widgets/floating_input.dart';
import 'package:notification_app/presentation/widgets/heading.dart';
import 'package:notification_app/presentation/widgets/labeled_checkbox.dart';
import 'package:notification_app/presentation/widgets/outlined_button/outlined_button.dart';
import 'package:notification_app/presentation/wrappers/scrollable_page.dart';
import 'package:notification_app/utils/utils.dart'
    show Validators, msisdnToCustomerId;

class DetailsScreen extends StatefulWidget {
  final String msisdn;
  final String token;

  DetailsScreen({
    required this.msisdn,
    required this.token,
  });
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late AppLocalizations _translate;
  final TextEditingController _firstnameCtrl = TextEditingController();
  final TextEditingController _lastnameCtrl = TextEditingController();
  String _email = '';
  bool isNotificationEmailEnabled = false;
  bool isNotificationTextEnabled = false;
  bool _isTermsConfirmed = false;
  bool _isTermsHasError = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _firstNameFieldKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _lastNameFieldKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _emailFieldKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _confirmEmailFieldKey =
      GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    _translate = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: DefaultAppBar(),
      body: ScrollablePage(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _mainTitle(),
              _mainSubtitle(),
              _firstNameInput(),
              _lastNameInput(),
              _emailInput(),
              _confirmEmailInput(),
              _marketingTitle(),
              const Divider(thickness: 2, height: 0),
              const SizedBox(height: 20),
              _notificationEmailSection(),
              const Divider(),
              _notificationTextSection(),
              const Divider(thickness: 2),
              const SizedBox(height: 10),
              _termsTitle(),
              _acceptTermsCheckbox(),
              const SizedBox(height: 40),
              _submitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mainTitle() {
    return Padding(
      padding: EdgeInsets.zero,
      child: Heading(
        _translate.personal_details_screen_title,
        type: HeadingType.h1,
      ),
    );
  }

  Widget _mainSubtitle() {
    return Padding(
      padding: EdgeInsets.zero,
      child: Text(
        _translate.personal_details_screen_subtitle,
        style: TextTypography.body_copy,
      ),
    );
  }

  Widget _firstNameInput() {
    return Container(
      key: const Key('personalDetailsFirstName'),
      child: FloatingInput(
        formFieldKey: _firstNameFieldKey,
        validateOnFocusOut: true,
        controller: _firstnameCtrl,
        decoration: InputDecoration(
          labelText: _translate.personal_details_screen_first_name,
        ),
        validator: Validators.required(_translate.required),
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget _lastNameInput() {
    return Container(
      key: const Key('personalDetailsLastName'),
      child: FloatingInput(
        formFieldKey: _lastNameFieldKey,
        validateOnFocusOut: true,
        controller: _lastnameCtrl,
        validator: Validators.required(_translate.required),
        decoration: InputDecoration(
          labelText: _translate.personal_details_screen_last_name,
        ),
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget _emailInput() {
    return Container(
      key: const Key('personalDetailsEmail'),
      child: FloatingInput(
        formFieldKey: _emailFieldKey,
        validateOnFocusOut: true,
        keyboardType: TextInputType.emailAddress,
        validator: Validators.compose(
          <String? Function(String?)>[
            Validators.required(_translate.required),
            Validators.email(),
          ],
        ),
        decoration: InputDecoration(
          labelText: _translate.personal_details_screen_email_address,
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
      key: const Key('personalDetailsConfirmEmail'),
      child: FloatingInput(
        formFieldKey: _confirmEmailFieldKey,
        validateOnFocusOut: true,
        keyboardType: TextInputType.emailAddress,
        validator: Validators.compose(
          <String? Function(String?)>[
            Validators.required(_translate.required),
            Validators.email(),
            Validators.match(_email, false),
          ],
        ),
        decoration: InputDecoration(
          labelText: _translate.personal_details_screen_confirm_email_address,
        ),
        textInputAction: TextInputAction.done,
      ),
    );
  }

  Widget _marketingTitle() {
    return Padding(
      padding: EdgeInsets.only(
        top: TextTypography.h4_m_mb,
        bottom: TextTypography.body_copy_mb,
      ),
      child: Column(
        key: const Key('marketingTitle'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Heading(
            _translate.personal_details_screen_marketing_title,
            type: HeadingType.h2,
          ),
          Text(
            _translate.personal_details_screen_marketing_subtitle,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  Widget _notificationEmailSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(_translate.personal_details_screen_reward_notification_email),
        Container(
          key: Key('personalDetailsNotificationEmail'),
          child: AppSwitch(
            value: isNotificationEmailEnabled,
            onToggle: (bool val) {
              setState(() {
                isNotificationEmailEnabled = val;
              });
            },
          ),
        )
      ],
    );
  }

  Widget _notificationTextSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(_translate.personal_details_screen_reward_notification_text),
        Container(
          key: Key('personalDetailsNotificationText'),
          child: AppSwitch(
            value: isNotificationTextEnabled,
            onToggle: (bool val) {
              setState(() {
                isNotificationTextEnabled = val;
              });
            },
          ),
        )
      ],
    );
  }

  Widget _termsTitle() {
    return Container(
      child: Heading(
        _translate.personal_details_screen_terms_title,
        type: HeadingType.h2,
      ),
    );
  }

  Widget _acceptTermsCheckbox() {
    return LabeledCheckbox(
      key: Key('personalDetailsAcceptTerms'),
      isChecked: _isTermsConfirmed,
      hasError: _isTermsHasError,
      labelTappable: false,
      onChanged: (bool? value) {
        if (value == null) {
          value = false;
        }

        setState(() {
          _isTermsConfirmed = value!;
          _isTermsHasError = !value;
        });
      },
      child: RichText(
        key: const Key('termsCheckboxLabel'),
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: _translate.personal_details_screen_terms_first,
              style: TextTypography.body_copy.copyWith(
                color: ColorPalette.liquorice,
              ),
            ),
            TextSpan(
              text: _translate.personal_details_screen_terms_second,
              style: TextTypography.link,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.of(context).push(
                    RouteBuilder<TermsAndConditions>(
                      active: widget,
                      next: TermsAndConditions(),
                    ),
                  );
                },
            ),
            TextSpan(
              text: _translate.personal_details_screen_terms_third,
              style: TextTypography.body_copy.copyWith(
                color: ColorPalette.liquorice,
              ),
            ),
            TextSpan(
              text: _translate.personal_details_screen_terms_fourth,
              style: TextTypography.link,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.of(context).push(
                    RouteBuilder<PrivacyPolicy>(
                      active: widget,
                      next: PrivacyPolicy(),
                    ),
                  );
                },
            ),
            TextSpan(
              text: _translate.personal_details_screen_terms_fifth,
              style: TextTypography.body_copy.copyWith(
                color: ColorPalette.liquorice,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      key: Key('personalDetailsSubmit'),
      child: ThreeOutlinedButton(
        margin: EdgeInsets.zero,
        text: _translate.button_next,
        onPressed: () {
          if (!_isTermsConfirmed) {
            setState(() {
              _isTermsHasError = true;
            });
          }
          if (_formKey.currentState!.validate() && _isTermsConfirmed) {
            LoyaltyProgram _loyaltyProgram = LoyaltyProgram(
              customerId: msisdnToCustomerId(widget.msisdn),
              programName: AppConfig.loyaltyProgramName,
              userInfos: User(
                firstName: _firstnameCtrl.text.trim(),
                lastName: _lastnameCtrl.text.trim(),
                customFields: <CustomField>[
                  CustomField(
                    name: CustomField.email,
                    value: _email.trim(),
                  ),
                ],
              ),
              consents: <Consent>[
                Consent(
                    name: Consent.emailPreferredContact,
                    value: isNotificationEmailEnabled),
                Consent(
                  name: Consent.smsPreferredContact,
                  value: isNotificationTextEnabled,
                ),
              ],
            );

            Navigator.of(context).pushReplacement(
              RouteBuilder<SetPasswordScreen>(
                active: widget,
                next: SetPasswordScreen(
                  loyaltyProgram: _loyaltyProgram,
                  token: widget.token,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
