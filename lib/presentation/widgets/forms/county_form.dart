import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_app/constants/location.dart';
import 'package:notification_app/data/models/custom_field.dart';
import 'package:notification_app/data/models/loyalty_program.dart';
import 'package:notification_app/data/repositories/authentication_repository.dart';
import 'package:notification_app/data/repositories/loyalty_program_repository.dart';
import 'package:notification_app/localization.dart';
import 'package:notification_app/logic/bloc/auth/authentication_bloc.dart';
import 'package:notification_app/logic/bloc/loyalty_program/loyalty_program_bloc.dart';
import 'package:notification_app/logic/form_submission_status.dart';
import 'package:notification_app/presentation/widgets/dropdown.dart';
import 'package:notification_app/presentation/widgets/floating_input.dart';
import 'package:notification_app/presentation/widgets/heading.dart';
import 'package:notification_app/presentation/widgets/outlined_button/outlined_button.dart';

class CountyForm extends StatefulWidget {
  final Function() goToNext;

  const CountyForm(
    this.goToNext, {
    Key? key,
  }) : super(key: key);

  @override
  _CountyFormState createState() => _CountyFormState();
}

class _CountyFormState extends State<CountyForm> {
  late AppLocalizations _translate;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late DropDownController _dropdownController = DropDownController();

  @override
  void initState() {
    super.initState();

    CustomField? countyField = getCustomField(
      loyaltyProgram.userInfos?.customFields ?? <CustomField>[],
      CustomField.county,
    );

    _dropdownController.curIndexSelected = (countyField?.value != null)
        ? Location.counties.indexOf(countyField!.value!)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    _translate = AppLocalizations.of(context)!;

    _dropdownController.labelRetriever = (int value) {
      return Location.counties[value];
    };

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
                Heading(_translate.county_form_title, type: HeadingType.h4),
                SizedBox(height: 8),
                Heading(_translate.county_form_subtitle, type: HeadingType.h2),
                SizedBox(height: 10),
                _countyInput(),
                SizedBox(height: 20),
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

  CustomField? getCustomField(List<CustomField> list, String name) {
    try {
      return list.firstWhere((CustomField e) => e.name == name);
    } catch (e) {
      return null;
    }
  }

  Widget _buildSaveBtn(BuildContext context) {
    return SizedBox(
      child: ThreeOutlinedButton(
        key: const Key('saveBtn'),
        onPressed: () {
          _formSaveHandler(context);
        },
        child: Text(_translate.county_form_btn_save),
      ),
    );
  }

  Widget _countyInput() {
    return Dropdown<String>(
      itemsCount: Location.counties.length,
      hint: _translate.county_form_select_county,
      controller: _dropdownController,
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

  void _formSaveHandler(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<LoyaltyProgramBloc>().add(UpdateUserInfoCustomField(
            loyaltyProgram: loyaltyProgram,
            customField: CustomField(
              name: CustomField.county,
              value: Location.counties[_dropdownController.curIndexSelected!],
            ),
          ));
    }
  }
}
