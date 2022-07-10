import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_app/constants/colors.dart';
import 'package:notification_app/constants/dimension.dart';
import 'package:notification_app/constants/easing_curves.dart';
import 'package:notification_app/constants/typography.dart';
import 'package:notification_app/data/models/custom_field.dart';
import 'package:notification_app/data/models/loyalty_program.dart';
import 'package:notification_app/localization.dart';
import 'package:notification_app/logic/bloc/auth/authentication_bloc.dart';
import 'package:notification_app/presentation/widgets/default_app_bar.dart';
import 'package:notification_app/presentation/widgets/forms/birthday_form.dart';
import 'package:notification_app/presentation/widgets/forms/county_form.dart';
import 'package:notification_app/presentation/widgets/link.dart';
import 'package:notification_app/presentation/widgets/progress_bar.dart';
import 'package:notification_app/presentation/wrappers/page_wrapper.dart';

part 'package:notification_app/presentation/screens/additional_info_screen/birthday_tab.dart';
part 'package:notification_app/presentation/screens/additional_info_screen/county_tab.dart';

enum AdditionalInfoStep {
  Birthday,
  County,
}

class AdditionalInfoScreen extends StatefulWidget {
  late final PageController _pageController;

  @override
  _AdditionalInfoScreenState createState() => _AdditionalInfoScreenState();
}

class _AdditionalInfoScreenState extends State<AdditionalInfoScreen> {
  late AppLocalizations _translate;

  AdditionalInfoStep _curStep = AdditionalInfoStep.Birthday;

  late final List<AdditionalInfoStep> _orderedSteps;

  LoyaltyProgram get loyaltyProgram {
    return BlocProvider.of<AuthenticationBloc>(context).state.loyaltyProgram;
  }

  @override
  void initState() {
    _orderedSteps = _configStepsOrder();

    _initCurStep();

    widget._pageController =
        PageController(initialPage: _orderedSteps.indexOf(_curStep));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _translate = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: DefaultAppBar(),
      body: PageWrapper(
        noPaddings: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildTabBar(),
            Expanded(
              child: PageView(
                controller: widget._pageController,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  _getWidgetForStepType(0),
                  _getWidgetForStepType(1),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _initCurStep() {
    if (!_hasBirthday) {
      _curStep = AdditionalInfoStep.Birthday;
    } else if (!_hasCounty) {
      _curStep = AdditionalInfoStep.County;
    }
  }

  Widget _getWidgetForStepType(int stepIndex) {
    switch (_orderedSteps[stepIndex]) {
      case AdditionalInfoStep.Birthday:
        return BirthdayTab(_goToNextPage);
      case AdditionalInfoStep.County:
        return CountyTab(_goToNextPage);
    }
  }

  Widget _buildTabBar() {
    double firstTabProgress = _curStep == _orderedSteps[0] ? 0.03 : 1;
    double secondTabProgress = _curStep == _orderedSteps[1] ? 0.03 : 0;

    return Padding(
      padding: EdgeInsets.only(
        left: Dimension.xAxisPadding,
        right: Dimension.xAxisPadding,
        bottom: Dimension.yAxisPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildProgressBar(firstTabProgress, true),
              _buildProgressBar(secondTabProgress, false),
            ],
          ),
          _buildStepIndicator(),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: EdgeInsets.only(top: 3),
      child: Text(
        _translate.additional_info_screen_step_indicator(
          _orderedSteps.indexOf(_curStep) + 1,
          _orderedSteps.length,
        ),
        style: TextTypography.small,
      ),
    );
  }

  Widget _buildProgressBar(double progress, bool isLeft) {
    return Expanded(
        child: Padding(
      padding: EdgeInsets.only(right: isLeft ? 8 : 0, left: !isLeft ? 8 : 0),
      child: ProgressBar(progress, ColorPalette.shepherdsDelight,
          ColorPalette.liquorice, 5, 0),
    ));
  }

  void _goToNextPage(bool hasSkipped) {
    switch (_orderedSteps.indexOf(_curStep)) {
      case 0:
        setState(() {
          _curStep = _orderedSteps[1];
        });
        break;
      case 1:
        Navigator.of(context).pop();
        break;
    }
    widget._pageController.animateToPage(
      _orderedSteps.indexOf(_curStep),
      duration: const Duration(milliseconds: 300),
      curve: EasingCurves.activated,
    );
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

  List<AdditionalInfoStep> _configStepsOrder() {
    if (!_hasBirthday && _hasCounty) {
      return <AdditionalInfoStep>[
        AdditionalInfoStep.County,
        AdditionalInfoStep.Birthday,
      ];
    } else {
      return <AdditionalInfoStep>[
        AdditionalInfoStep.Birthday,
        AdditionalInfoStep.County,
      ];
    }
  }
}
