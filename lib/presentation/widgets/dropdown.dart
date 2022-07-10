import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notification_app/constants/colors.dart';
import 'package:notification_app/constants/icons.dart';
import 'package:notification_app/constants/theme.dart';
import 'package:notification_app/constants/typography.dart';
import 'package:notification_app/localization.dart';

class DropDownController {
  String Function(int index)? labelRetriever = null;

  _DummyItem<dynamic>? _curItemSelected = null;

  set _newItemSelected(_DummyItem<dynamic>? item) {
    _curItemSelected = item;
    curIndexSelected = item?.index ?? null;
  }

  int? _curIndexSelected;

  set curIndexSelected(int? index) {
    _curIndexSelected = index;
  }

  int? get curIndexSelected => _curItemSelected?.index ?? null;

  DropDownController();
}

class _DummyItem<T> {
  final int index;
  final String label;

  _DummyItem(this.index, this.label);
}

class Dropdown<T> extends StatefulWidget {
  final int itemsCount;
  final String hint;
  final DropDownController controller;

  const Dropdown({
    required this.itemsCount,
    required this.hint,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  _DropdownState<T> createState() => _DropdownState<T>();
}

class _DropdownState<T> extends State<Dropdown<dynamic>> {
  late AppLocalizations _translate;
  List<_DummyItem<dynamic>> _items = <_DummyItem<dynamic>>[];
  String? _error;

  @override
  void initState() {
    _DummyItem<dynamic> item;
    for (int i = 0; i < widget.itemsCount; i++) {
      item = _DummyItem<dynamic>(
          i, widget.controller.labelRetriever?.call(i) ?? '');
      _items.add(item);
      if (widget.controller._curIndexSelected == i) {
        //We access the private value here directly, yes
        widget.controller._newItemSelected = item;
      }
    }
    if (widget.controller.curIndexSelected != null) {}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _translate = AppLocalizations.of(context)!;

    return Column(children: <Widget>[
      _buildDropDown(),
      _buildErrorMessage(),
    ]);
  }

  Widget _buildDropDown() {
    return Container(
      height: 45,
      child: DropdownButtonFormField<_DummyItem<dynamic>>(
          isExpanded: true,
          icon: Icon(
            ThreeIcons.arrow_down_circle,
            size: 20,
          ),
          iconSize: 20,
          style: TextTypography.h4_m_light.copyWith(
            color: ColorPalette.liquorice,
          ),
          value: widget.controller._curItemSelected,
          hint: Text(
            widget.hint,
            style: TextTypography.h4_m_light.copyWith(
              color: ColorPalette.thunder,
            ),
          ),
          selectedItemBuilder: (BuildContext context) {
            return _items.map<DropdownMenuItem<_DummyItem<dynamic>>>(
                (_DummyItem<dynamic> value) {
              return DropdownMenuItem<_DummyItem<dynamic>>(
                value: value,
                child: _buildSelectedItem(value),
              );
            }).toList();
          },
          items: _items.map<DropdownMenuItem<_DummyItem<dynamic>>>(
              (_DummyItem<dynamic> value) {
            return DropdownMenuItem<_DummyItem<dynamic>>(
              value: value,
              child: _buildListItem(value),
            );
          }).toList(),
          onChanged: (_DummyItem<dynamic>? newValue) {
            setState(() {
              widget.controller._newItemSelected = newValue;
            });
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (_DummyItem<dynamic>? value) {
            if (value == null && mounted) {
              final String? validationError = _translate.required;

              scheduleMicrotask(
                () => setState(() {
                  _error = validationError;
                }),
              );

              // This is a hack to get rid of TextFormField validation message
              // in favor of custom error message with icon, as null value
              // considered as valid input & any string as invalid.
              // Warning in couple with resetting styles for
              // inputDecorationTheme -> errorStyle -> copyWith(...) section
              // located in lib/constants/theme.dart
              return validationError == null ? null : '';
            }
            scheduleMicrotask(
              () => setState(() {
                _error = null;
              }),
            );
            return null;
          }),
    );
  }

  Widget _buildErrorMessage() {
    return _error != null
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
                    key: const Key('dropdownErrorIconKey'),
                    color: ColorPalette.chilli,
                    size: 20,
                  ),
                ),
                Expanded(
                  child: Text(
                    _error!,
                    key: const Key('dropdownErrorIconKey'),
                    style: themeInputErrorTextStyle(),
                  ),
                ),
              ],
            ),
          )
        : Container();
  }

  Widget _buildSelectedItem(_DummyItem<dynamic> item) {
    return Text(item.label,
        style: TextTypography.h4_m_light.copyWith(
          color: ColorPalette.liquorice,
        ));
  }

  Widget _buildListItem(_DummyItem<dynamic> item) {
    // TODO: reenable this when figure ot how to set entire background
    // if (widget.controller._curItemSelected == item) {
    //   return _buildHighlightedListItem(item);
    // } else
    return Text(item.label,
        style: TextTypography.h4_m_light.copyWith(
          color: ColorPalette.liquorice,
        ));
  }

  // ignore: unused_element
  Widget _buildHighlightedListItem(_DummyItem<dynamic> item) {
    return Container(
      color: ColorPalette.liquorice,
      child: Text(item.label,
          style: TextTypography.h4_m_light.copyWith(
            color: Colors.white,
          )),
    );
  }
}
