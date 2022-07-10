import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:notification_app/constants/colors.dart';
import 'package:notification_app/constants/dimension.dart';
import 'package:notification_app/constants/typography.dart';
import 'package:notification_app/presentation/widgets/builders/border_builder.dart';

enum ButtonClassName {
  primary,
  secondary,
}

class ButtonTheming extends MaterialTheming {
  static ButtonClassName primary = ButtonClassName.primary;
  static ButtonClassName secondary = ButtonClassName.secondary;

  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  ButtonTheming._();

  static MaterialStateProperty<BorderSide> _primaryBorder =
      MaterialTheming._resolve(
    BorderSide(
      color: ColorPalette.liquorice,
      width: 3,
      style: BorderStyle.solid,
    ),
  );

  static MaterialStateProperty<BorderSide> _secondaryBorder =
      MaterialTheming._resolve(
    BorderSide(
      color: ColorPalette.liquorice,
      width: 3,
      style: BorderStyle.solid,
    ),
  );

  static _Properties resolve(
    MaterialState? state, [
    ButtonClassName theme = ButtonClassName.primary,
  ]) {
    switch (theme) {
      case ButtonClassName.secondary:
        return _Properties(
          state,
          side: _secondaryBorder,
          backgroundColor: MaterialTheming._resolveInteractive(
            Colors.transparent,
            onAction: Colors.transparent,
          ),
          foregroundColor: MaterialTheming._resolveInteractive(
            ColorPalette.liquorice,
            onAction: ColorPalette.liquorice,
          ),
        );

      default:
        return _Properties(
          state,
          backgroundColor: MaterialTheming._resolve(ColorPalette.liquorice),
          foregroundColor: MaterialTheming._resolveInteractive(
            ColorPalette.shepherdsDelight,
            onAction: ColorPalette.auroraLight,
          ),
          side: _primaryBorder,
        );
    }
  }
}

abstract class MaterialTheming {
  static const Set<MaterialState> _interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };

  static MaterialStateProperty<T> _resolveInteractive<T>(
    T prop, {
    required T onAction,
  }) {
    return MaterialStateProperty.resolveWith(
      (Set<MaterialState> state) =>
          state.any(_interactiveStates.contains) ? onAction : prop,
    );
  }

  static MaterialStateProperty<T> _resolve<T>(T prop) {
    return MaterialStateProperty.resolveWith((_) => prop);
  }
}

class _Properties {
  final MaterialState? state;
  MaterialStateProperty<Color?>? _backgroundColor;
  MaterialStateProperty<Color?>? _foregroundColor;
  MaterialStateProperty<BorderSide?>? _side;

  _Properties(
    this.state, {
    MaterialStateProperty<Color?>? backgroundColor,
    MaterialStateProperty<Color?>? foregroundColor,
    MaterialStateProperty<BorderSide?>? side,
  }) {
    _backgroundColor = backgroundColor;
    _foregroundColor = foregroundColor;
    _side = side;
  }

  Set<MaterialState> get _stateSet =>
      state != null ? <MaterialState>{state!} : <MaterialState>{};

  Color? get backgroundColor => _backgroundColor?.resolve(_stateSet);

  Color? get foregroundColor => _foregroundColor?.resolve(_stateSet);

  OutlinedBorder get shape => BorderBuilder.outlinedButtonBorder;

  BoxShadow get shadow => BoxShadow(
        color: ColorPalette.liquorice.withOpacity(0.2),
        offset: Offset(0.0, 5.0),
        blurRadius: 10,
      );

  BoxShadow get boxShadow => MaterialTheming._resolveInteractive(
        shadow,
        onAction: shadow,
      ).resolve(_stateSet);

  BorderSide? get side => _side?.resolve(_stateSet);

  TextStyle get textStyle => TextTypography.h4_m;

  ButtonStyle get style => OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        onSurface: foregroundColor,
        primary: foregroundColor,
        animationDuration: Duration(milliseconds: 250),
        shape: shape,
        side: side,
        enableFeedback: false,
        alignment: Alignment.center,
        textStyle: textStyle,
        padding: EdgeInsets.fromLTRB(
          Dimension.xAxisPadding,
          6,
          Dimension.xAxisPadding,
          9,
        ),
      );
}
