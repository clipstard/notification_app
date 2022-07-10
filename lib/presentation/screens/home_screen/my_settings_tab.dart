part of 'package:notification_app/presentation/screens/home_screen.dart';

class MySettingsTab extends StatefulWidget {
  const MySettingsTab({
    Key? key,
  }) : super(key: key);

  @override
  _MySettingsTabState createState() => _MySettingsTabState();
}

class _MySettingsTabState extends State<MySettingsTab> {
  late AppLocalizations _translate;
  late LoyaltyProgram _loyaltyProgram;
  Map<String, bool> preferredContacts = <String, bool>{
    Consent.emailPreferredContact: false,
    Consent.smsPreferredContact: false,
    Consent.pushPreferredContact: false,
  };

  String get phoneNumber {
    String msisdn = _loyaltyProgram.customerId;
    if (msisdn.toLowerCase().startsWith('msisdn/')) {
      return msisdn.substring('msisdn/'.length);
    }

    return msisdn;
  }

  CustomField? getCustomField(List<CustomField> list, String name) {
    try {
      return list.firstWhere((CustomField e) => e.name == name);
    } catch (e) {
      return null;
    }
  }

  bool getConsentValue(String name) {
    try {
      Consent consent =
          _loyaltyProgram.consents.firstWhere((Consent e) => e.name == name);
      return consent.value;
    } catch (e) {
      return false;
    }
  }

  void navigateTo(Widget next) {
    Navigator.of(context).push(
      RouteBuilder<Widget>(
        active: HomeScreen(
          activeTab: HomeNavbarIndex.Settings,
        ),
        next: next,
      ),
    );
  }

  void setLoyaltyProgram() {
    _loyaltyProgram =
        BlocProvider.of<AuthenticationBloc>(context).state.loyaltyProgram;
  }

  void setContacts() {
    preferredContacts[Consent.emailPreferredContact] =
        getConsentValue(Consent.emailPreferredContact);
    preferredContacts[Consent.pushPreferredContact] =
        getConsentValue(Consent.pushPreferredContact);
    preferredContacts[Consent.smsPreferredContact] =
        getConsentValue(Consent.smsPreferredContact);
  }

  @override
  void initState() {
    setLoyaltyProgram();
    setContacts();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      setLoyaltyProgram();
      setContacts();
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _translate = AppLocalizations.of(context)!;

    return MultiBlocProvider(
      providers: <BlocProvider<Object?>>[
        _configureLoyaltyProgramBloc(),
        _configureOtpBloc(),
      ],
      child: BlocConsumer<LoyaltyProgramBloc, LoyaltyProgramState>(
        listener: (BuildContext context, LoyaltyProgramState state) {
          if (state.status is SubmissionSuccess) {
            setLoyaltyProgram();
          }
        },
        builder: (BuildContext context, LoyaltyProgramState state) {
          return ScrollablePage(
            child: OtpContainer(
              ref: widget,
              onRetry: _onRetry,
              onValidated: _onValidated,
              wrongOtpErrorMessage: _translate.info_block_title,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (state.status is SubmissionFailed)
                    Alert(
                      title: state.status.exception.toString(),
                      variant: AlertVariant.warning,
                    ),
                  Heading(_translate.settings_screen_title),
                  _phoneLabel(),
                  SizedBox(height: 40),
                  _nameInput(),
                  _passwordInput(),
                  _emailInput(),
                  Text(
                    _translate.settings_birthday,
                    style: TextTypography.body_copy.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _dobRow(),
                  _countyInput(),
                  SizedBox(height: 20),
                  Heading(
                    _translate.settings_marketing_preferences,
                    type: HeadingType.h3,
                    target: HeadingTarget.desktop,
                  ),
                  Text(
                    _translate.settings_marketing_description,
                    style: TextTypography.body_copy,
                  ),
                  SizedBox(height: 20),
                  Divider(thickness: 2),
                  _notificationByEmail(context),
                  Divider(),
                  _notificationByText(context),
                  Divider(),
                  _notificationByPush(context),
                  Divider(thickness: 2),
                  SizedBox(height: 20),
                  UsefullLinks(
                    activeScreen: HomeScreen(
                      activeTab: HomeNavbarIndex.Settings,
                    ),
                  ),
                  GetInTouch(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _phoneLabel() {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: '${_translate.settings_phone_number}: ',
            style: TextTypography.body_copy.copyWith(
              fontWeight: FontWeight.bold,
              color: ColorPalette.liquorice,
            ),
          ),
          TextSpan(
            text: phoneNumber,
            style: TextTypography.body_copy.copyWith(
              color: ColorPalette.liquorice,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInput({
    required VoidCallback onTap,
    String? initialValue,
    String? label,
    bool obscureText = false,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: FloatingInput(
        enabled: false,
        initialValue: initialValue,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }

  Widget _nameInput() {
    return buildInput(
      initialValue: _loyaltyProgram.userInfos!.firstName +
          ' ' +
          _loyaltyProgram.userInfos!.lastName,
      label: _translate.settings_name,
      onTap: () => navigateTo(EmptyScreen()), // replace with Name screen
    );
  }

  Widget _passwordInput() {
    return BlocBuilder<OtpBloc, OtpState>(
      builder: (BuildContext context, OtpState state) {
        return buildInput(
          initialValue: '*' * 8,
          label: _translate.settings_password,
          obscureText: true,
          onTap: () {
            context.read<OtpBloc>().add(OtpRequestedEvent(
                  _loyaltyProgram.customerId,
                  otpType: OtpType.Renew,
                ));
          },
        );
      },
    );
  }

  Widget _emailInput() {
    CustomField? field = getCustomField(
      _loyaltyProgram.userInfos!.customFields,
      CustomField.email,
    );
    return buildInput(
      initialValue: field?.value ?? '',
      label: _translate.settings_email,
      onTap: () => navigateTo(ResetEmailScreen()),
    );
  }

  Widget _dayInput() {
    String? dayMonth = getCustomField(
      _loyaltyProgram.userInfos!.customFields,
      CustomField.dayMonth,
    )?.value;
    String day = '';
    if (dayMonth != null) {
      day = dayMonth.split('/').first;
    }

    return buildInput(
      initialValue: day,
      label: day.isEmpty ? _translate.day : '',
      onTap: () => navigateTo(EmptyScreen()), // replace with Password screen
    );
  }

  Widget _monthInput() {
    String? dayMonth = getCustomField(
      _loyaltyProgram.userInfos!.customFields,
      CustomField.dayMonth,
    )?.value;
    String month = '';
    if (dayMonth != null) {
      month = dayMonth.split('/').last;
    }

    return buildInput(
      initialValue: month,
      label: month.isEmpty ? _translate.month : '',
      onTap: () => navigateTo(EmptyScreen()), // replace with Password screen
    );
  }

  Widget _dobRow() {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: 80,
            child: _dayInput(),
            margin: EdgeInsets.only(right: 10),
          ),
          Container(
            width: 80,
            child: _monthInput(),
          ),
        ],
      ), // replace with DoB screen
    );
  }

  Widget _countyInput() {
    CustomField? countyField = getCustomField(
      _loyaltyProgram.userInfos!.customFields,
      CustomField.county,
    );
    return buildInput(
      initialValue: countyField?.value ?? '',
      label: _translate.settings_county,
      onTap: () => navigateTo(EmptyScreen()), // replace with county screen
    );
  }

  Widget buildSwitch(BuildContext context, String label, String preference) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(label, style: TextTypography.body_copy),
        Container(
          key: Key(preference),
          child: AppSwitch(
            value: preferredContacts[preference]!,
            onToggle: (bool val) {
              setState(() {
                preferredContacts[preference] = val;
              });

              context.read<LoyaltyProgramBloc>().add(UpdateMarketingPreference(
                    loyaltyProgram: _loyaltyProgram,
                    marketingPreference: Consent(
                      name: preference,
                      value: val,
                    ),
                  ));
            },
          ),
        )
      ],
    );
  }

  Widget _notificationByEmail(BuildContext context) {
    return buildSwitch(
      context,
      _translate.personal_details_screen_reward_notification_email,
      Consent.emailPreferredContact,
    );
  }

  Widget _notificationByText(BuildContext context) {
    return buildSwitch(
      context,
      _translate.personal_details_screen_reward_notification_text,
      Consent.smsPreferredContact,
    );
  }

  Widget _notificationByPush(BuildContext context) {
    return buildSwitch(
      context,
      _translate.subscription_push_notification,
      Consent.pushPreferredContact,
    );
  }

  void _onRetry(BuildContext context, Widget widget) {
    Navigator.of(context).pop();
  }

  void _onValidated(
    BuildContext context,
    Widget widget,
    String msisdn,
    String token,
  ) {
    Navigator.of(context).pushReplacement(
      RouteBuilder<ChangePasswordScreen>(
        active: widget,
        next: ChangePasswordScreen(
          msisdn: msisdn,
          token: token,
        ),
      ),
    );
  }

  BlocProvider<OtpBloc> _configureOtpBloc() {
    return BlocProvider<OtpBloc>(
      create: (BuildContext context) =>
          OtpBloc(otpRepository: OtpRepository())..add(OtpInitEvent()),
    );
  }

  BlocProvider<LoyaltyProgramBloc> _configureLoyaltyProgramBloc() {
    return BlocProvider<LoyaltyProgramBloc>(
      create: (BuildContext context) => LoyaltyProgramBloc(
        loyaltyProgramRepository: context.read<LoyaltyProgramRepository>(),
        authenticationRepository: context.read<AuthenticationRepository>(),
      ),
    );
  }
}
