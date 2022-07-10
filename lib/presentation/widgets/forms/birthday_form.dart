import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_app/constants/colors.dart';
import 'package:notification_app/constants/dimension.dart';
import 'package:notification_app/constants/icons.dart';
import 'package:notification_app/constants/theme.dart';
import 'package:notification_app/constants/typography.dart';
import 'package:notification_app/data/models/custom_field.dart';
import 'package:notification_app/data/models/loyalty_program.dart';
import 'package:notification_app/data/repositories/authentication_repository.dart';
import 'package:notification_app/data/repositories/loyalty_program_repository.dart';
import 'package:notification_app/localization.dart';
import 'package:notification_app/logic/bloc/auth/authentication_bloc.dart';
import 'package:notification_app/logic/bloc/loyalty_program/loyalty_program_bloc.dart';
import 'package:notification_app/logic/form_submission_status.dart';
import 'package:notification_app/presentation/widgets/outlined_button/outlined_button.dart';
import 'package:notification_app/utils/validators_util.dart';

import '../floating_input.dart';
import '../heading.dart';

class BirthdayForm extends StatefulWidget {
  final Function() goToNext;

  const BirthdayForm(
    this.goToNext, {
    Key? key,
  }) : super(key: key);

  @override
  _BirthdayFormState createState() => _BirthdayFormState();
}

class _BirthdayFormState extends State<BirthdayForm> {
  late AppLocalizations _translate;

  TextEditingController _ddController = TextEditingController();
  TextEditingController _mmController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _ddFieldKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _mmFieldKey =
      GlobalKey<FormFieldState<String>>();

  final FocusNode _ddFocusNode = FocusNode();
  final FocusNode _mmFocusNode = FocusNode();

  String? _dualInputError;

  @override
  void initState() {
    super.initState();

    String? dayMonth = getCustomField(
      loyaltyProgram.userInfos?.customFields ?? <CustomField>[],
      CustomField.dayMonth,
    )?.value;
    String day = '';
    if (dayMonth != null) {
      day = dayMonth.split('/').first;
    }
    day = '';
    _ddController = TextEditingController(text: day);
    String month = '';
    if (dayMonth != null) {
      month = dayMonth.split('/').last;
    }
    month = '';
    _mmController = TextEditingController(text: month);
  }

  @override
  Widget build(BuildContext context) {
    _translate = AppLocalizations.of(context)!;

    _ddFocusNode.addListener(() {
      if (!_ddFocusNode.hasFocus) {
        _mmFocusNode.requestFocus();
      }
    });
    _mmFocusNode.addListener(() {
      if (!_mmFocusNode.hasFocus) {
        _validateEntireDate();
      }
    });

    return BlocProvider<LoyaltyProgramBloc>(
      create: (BuildContext context) => LoyaltyProgramBloc(
        loyaltyProgramRepository: context.read<LoyaltyProgramRepository>(),
        authenticationRepository: context.read<AuthenticationRepository>(),
      ),
      child: BlocConsumer<LoyaltyProgramBloc, LoyaltyProgramState>(
        listener: _blocListener,
        builder: (BuildContext context, LoyaltyProgramState state) {
          return Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                Heading(_translate.birthday_form_title, type: HeadingType.h4),
                SizedBox(height: 8),
                Heading(_translate.birthday_form_subtitle,
                    type: HeadingType.h2),
                Text(
                    '${_translate.birthday_form_dd}/${_translate.birthday_form_mm}',
                    style: TextTypography.h4_m_light),
                _birthdayRow(),
                SizedBox(height: 10),
                _buildSaveBtn(context),
              ],
            ),
          );
        },
      ),
    );
  }

  void _blocListener(BuildContext context, LoyaltyProgramState state) {
    if (state.status is SubmissionSuccess) {
      widget.goToNext();
    }
  }

  LoyaltyProgram get loyaltyProgram {
    return BlocProvider.of<AuthenticationBloc>(context).state.loyaltyProgram;
  }

  Widget _birthdayRow() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 4,
                child: _dayInput(),
                margin: EdgeInsets.only(right: 10),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 4,
                child: _monthInput(),
              ),
            ],
          ),
          _buildErrorMessage(),
          SizedBox(height: Dimension.yAxisPadding),
        ],
      ),
    );
  }

  CustomField? getCustomField(List<CustomField> list, String name) {
    try {
      return list.firstWhere((CustomField e) => e.name == name);
    } catch (e) {
      return null;
    }
  }

  Widget _dayInput() {
    return buildInput(
      label: _translate.birthday_form_dd,
      formFieldKey: _ddFieldKey,
      dateFormat: 'dd',
      focusNode: _ddFocusNode,
      textInputAction: TextInputAction.next,
      textEditingController: _ddController,
    );
  }

  Widget _monthInput() {
    return buildInput(
      label: _translate.birthday_form_mm,
      formFieldKey: _mmFieldKey,
      dateFormat: 'MM',
      focusNode: _mmFocusNode,
      textInputAction: TextInputAction.done,
      textEditingController: _mmController,
    );
  }

  Widget buildInput({
    required String label,
    required GlobalKey<FormFieldState<dynamic>>? formFieldKey,
    required String dateFormat,
    required FocusNode focusNode,
    required TextInputAction textInputAction,
    required TextEditingController textEditingController,
  }) {
    return FloatingInput(
      textInputAction: textInputAction,
      formFieldKey: formFieldKey,
      validateOnFocusOut: true,
      focusNode: focusNode,
      controller: textEditingController,
      onEditingComplete: () {
        FocusScope.of(context).nextFocus();
      },
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      inputFormatters: <TextInputFormatter>[
        new LengthLimitingTextInputFormatter(2),
      ],
      keyboardType: TextInputType.number,
      validator: Validators.compose(
        <String? Function(String?)>[
          Validators.minLength(2, _translate.birthday_form_validator_invalid),
          Validators.required(_translate.birthday_form_validator_invalid),
          Validators.calendarDate(
              dateFormat, _translate.birthday_form_validator_invalid),
        ],
      ),
      noBottomPadding: true,
      externalizeErrorMsg: (String? errorMsg) {
        setState(() {
          _dualInputError = errorMsg;
        });
      },
    );
  }

  Widget _buildErrorMessage() {
    return _dualInputError != null
        ? Container(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Icon(
                    ThreeIcons.warning,
                    key: const Key('rowBirthdayErrorIconKey'),
                    color: ColorPalette.chilli,
                    size: 20,
                  ),
                ),
                Expanded(
                  child: Text(
                    _dualInputError!,
                    key: const Key('rowBirthdayErrorIconKey'),
                    style: themeInputErrorTextStyle(),
                  ),
                ),
              ],
            ),
          )
        : Container();
  }

  Widget _buildSaveBtn(BuildContext context) {
    return SizedBox(
      child: ThreeOutlinedButton(
        key: const Key('saveBtn'),
        onPressed: () {
          _formSaveHandler(context);
        },
        child: Text(_translate.birthday_form_btn_save),
      ),
    );
  }

  void _formSaveHandler(BuildContext context) {
    if (_formKey.currentState!.validate() && _validateEntireDate()) {
      context.read<LoyaltyProgramBloc>().add(UpdateUserInfoCustomField(
            loyaltyProgram: loyaltyProgram,
            customField: CustomField(
                name: CustomField.dayMonth,
                value: '${_ddController.text}/${_mmController.text}'),
          ));
    }
  }

  bool _validateEntireDate() {
    /// If day and moth are filled, validate entire date
    /// just to be sure the day exists in that month
    String day = _ddController.text;
    String month = _mmController.text;
    if (day.isNotEmpty && month.isNotEmpty) {
      String? error = Validators.calendarDate(
              'dd-MM', _translate.birthday_form_validator_invalid_date)
          .call('${day}-${month}');
      if (error != null) {
        setState(() {
          _dualInputError = error;
        });
        return false;
      }
    }
    return true;
  }
}
