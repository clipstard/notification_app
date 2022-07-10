import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_app/constants/colors.dart';
import 'package:notification_app/constants/icons.dart';
import 'package:notification_app/constants/typography.dart';
import 'package:notification_app/data/models/custom_field.dart';
import 'package:notification_app/data/models/loyalty_program.dart';
import 'package:notification_app/localization.dart';
import 'package:notification_app/logic/bloc/auth/authentication_bloc.dart';
import 'package:notification_app/presentation/router/route_builder.dart';
import 'package:notification_app/presentation/screens/additional_info_screen.dart';
import 'package:notification_app/presentation/screens/home_screen.dart';
import 'package:notification_app/presentation/widgets/link.dart';
import 'package:notification_app/presentation/widgets/progress_bar.dart';
import 'package:notification_app/services/local_storage_service.dart';

enum Completion {
  NA, //Not available. Default value.
  NOTHING,
  PARTIAL,
  ALL
}

extension _CompletionExtension on Completion {
  double getProgress() {
    switch (this) {
      case Completion.NOTHING:
        return 0.75;
      case Completion.PARTIAL:
        return 0.9;
      case Completion.ALL:
        return 1;
      default:
        return 0;
    }
  }
}

class ProfileCompletion extends StatefulWidget {
  static const double _HORIZ_PADDING = 43;

  @override
  _ProfileCompletionState createState() => _ProfileCompletionState();
}

class _ProfileCompletionState extends State<ProfileCompletion> {
  late AppLocalizations _translate;

  Completion _curCompletionType = Completion.NA;

  final LocalStorage _localStorage = LocalStorage();

  @override
  Widget build(BuildContext context) {
    _translate = AppLocalizations.of(context)!;

    _configCompletionType();

    if (!_shouldDisplay()) {
      return Container();
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Container(
        color: ColorPalette.auroraLight,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: <Widget>[
              _buildTopPortion(),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ProfileCompletion._HORIZ_PADDING),
                child: ProgressBar(
                  _curCompletionType.getProgress(),
                  Colors.black,
                  ColorPalette.shepherdsDelight,
                  20,
                  2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    //If it's 100% already and we're disposing ourselves,
    //then it means we've already shown ourselves
    //the user, so we can no long show us
    if (_curCompletionType == Completion.ALL) {
      _localStorage.closedProfileCompletion = true;
    }
    super.dispose();
  }

  bool _shouldDisplay() {
    int loginCounts = _localStorage.formLoginsCount;
    if (loginCounts >= 2) {
      _localStorage.closedProfileCompletion = true;
    }
    //Just in case of infinite loop incrementing or ...
    if (loginCounts == 9007199254740990) {
      _localStorage.formLoginsCount = 10;
    }

    bool manuallyClosed = _localStorage.closedProfileCompletion;
    return !manuallyClosed;
  }

  /// Builds everything above the progress bar
  Widget _buildTopPortion() {
    double rightPadding = _curCompletionType == Completion.ALL
        ? 10
        : ProfileCompletion._HORIZ_PADDING;

    return Padding(
      padding: EdgeInsets.only(
          bottom: 5,
          left: ProfileCompletion._HORIZ_PADDING,
          right: rightPadding),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildPercentageLabel(),
            if (_curCompletionType == Completion.ALL) _buildCloseBtn(),
            if (_curCompletionType != Completion.ALL) _buildCompleteLink(),
          ],
        ),
      ),
    );
  }

  Widget _buildPercentageLabel() {
    int percentage = (_curCompletionType.getProgress() * 100).toInt();
    String label = _curCompletionType == Completion.ALL
        ? _translate.profile_completion_full
        : _translate.profile_completion_partial(percentage);
    return Text(label, style: TextTypography.h4_m);
  }

  Widget _buildCompleteLink() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Link(
            _translate.profile_completion_complete_profile,
            inline: true,
            onTap: _openAdditionalInfoScreen,
          ),
          Padding(
            padding: EdgeInsets.only(left: 3),
            child: Icon(
              ThreeIcons.arrow_right_circle,
              size: 18.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloseBtn() {
    /// Make the X's parent container bigger so the user has more changes
    /// of hitting it
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Container(
          alignment: Alignment.centerRight,
          height: 24,
          child: Container(
            width: 24,
            child: Icon(
              ThreeIcons.close,
              size: 16.0,
            ),
          ),
        ),
        onTap: () {
          setState(() {
            _localStorage.closedProfileCompletion = true;
          });
        },
      ),
    );
  }

  void _openAdditionalInfoScreen() {
    Navigator.of(context).push(
      RouteBuilder<Widget>(
        active: HomeScreen(
          activeTab: HomeNavbarIndex.TopRewards,
        ),
        next: AdditionalInfoScreen(),
      ),
    );
  }

  void _configCompletionType() {
    if (_hasBirthday && _hasCounty) {
      _curCompletionType = Completion.ALL;
    } else if (_hasBirthday || _hasCounty) {
      _curCompletionType = Completion.PARTIAL;
    } else {
      _curCompletionType = Completion.NOTHING;
    }
  }

  bool get _hasBirthday {
    String? birthday = getCustomField(
      loyaltyProgram.userInfos?.customFields ?? <CustomField>[],
      CustomField.dayMonth,
    )?.value;
    return birthday?.isNotEmpty ?? false;
  }

  bool get _hasCounty {
    String? county = getCustomField(
      loyaltyProgram.userInfos?.customFields ?? <CustomField>[],
      CustomField.county,
    )?.value;
    return county?.isNotEmpty ?? false;
  }

  CustomField? getCustomField(List<CustomField> list, String name) {
    try {
      return list.firstWhere((CustomField e) => e.name == name);
    } catch (e) {
      return null;
    }
  }

  LoyaltyProgram get loyaltyProgram {
    return BlocProvider.of<AuthenticationBloc>(context).state.loyaltyProgram;
  }
}
