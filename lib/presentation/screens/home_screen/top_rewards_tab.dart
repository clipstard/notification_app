part of 'package:notification_app/presentation/screens/home_screen.dart';

class TopRewardsTab extends StatefulWidget {
  final bool optIn;

  TopRewardsTab({Key? key, this.optIn = false}) : super(key: key);

  @override
  _TopRewardsTabState createState() => _TopRewardsTabState();
}

class _TopRewardsTabState extends State<TopRewardsTab> {
  late AppLocalizations _translate;
  final LocalStorage _localStorage = LocalStorage();
  bool _useBiometricAuth = false;

  @override
  void initState() {
    _useBiometricAuth = _localStorage.biometricLoginActivated;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _translate = AppLocalizations.of(context)!;

    return Column(
      children: <Widget>[
        ProfileCompletion(),
        Expanded(
          child: ScrollablePage(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _title(),
                Divider(),
                _biometricToggle(),
                Divider(),
                Heading(
                  'Loyalty Program:',
                  type: HeadingType.h4,
                ),
                _loyaltyProgram(context),
                Divider(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _title() {
    return Heading(
      widget.optIn
          ? _translate.top_rewards_screen_welcome
          : _translate.top_rewards_screen_title,
      type: HeadingType.h1,
    );
  }

  Widget _biometricToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Activate biometric login'),
        Container(
          child: AppSwitch(
            value: _useBiometricAuth,
            onToggle: (bool value) {
              _localStorage.biometricLoginActivated = value;

              setState(() {
                _useBiometricAuth = value;
              });
            },
          ),
        )
      ],
    );
  }

  Widget _loyaltyProgram(BuildContext context) {
    final LoyaltyProgram loyaltyProgram =
        context.select((AuthenticationBloc bloc) => bloc.state.loyaltyProgram);
    return Text(loyaltyProgram.toString());
  }
}
