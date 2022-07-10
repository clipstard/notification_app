import 'package:flutter/material.dart';

class ColorPalette {
  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  ColorPalette._();

  // Other brand colours
  // https://zeroheight.com/3f32e30a7/p/09475c-colour/t/39353e

  static const Color coconut = Color(0xFFFFFFFF);
  static const Color auroraLight = Color(0xFFFDF2F0);
  static const Color liquorice = Color(0xFF000000);

  // Neutrals
  // https://zeroheight.com/3f32e30a7/p/09475c-colour/t/812c4c

  static const Color slate = Color(0xFF444444);
  static const Color thunder = Color(0xFF757575);
  static const Color smoke = Color(0xFFCDCDCD);
  static const Color cloud = Color(0xFFE2E2E2);
  static const Color pearl = Color(0xFFF1F1F1);

  // Aurora / Sunrise tints
  // https://zeroheight.com/3f32e30a7/p/09475c-colour/t/94616d

  static const Color aurora = Color(0xFFFF7B67);
  static const Color aurora90 = Color(0xFFFF8474);
  static const Color aurora80 = Color(0xFFFF8E81);
  static const Color aurora70 = Color(0xFFFF978E);
  static const Color aurora60 = Color(0xFFFFA19C);
  static const Color aurora50 = Color(0xFFFFABA9);
  static const Color aurora40 = Color(0xFFFFB5B7);
  static const Color shepherdsDelight = Color(0xFFFFBFC5);
  static const Color aurora20 = Color(0xFFFFC8D2);
  static const Color aurora10 = Color(0xFFFFD2E0);
  static const Color sunrise = Color(0xFFFFDCED);
  static const Color toggleActiveColor = Color(0xFFFEBEC4);
  // Default text links
  // https://zeroheight.com/3f32e30a7/p/09475c-colour/t/31c53d

  static const Color blueberry = Color(0xFF006EB8);
  static const Color blueberryDark = Color(0xFF002E88);
  static const Color eggplant = Color(0xFF82368C);

  // Light text links
  // https://zeroheight.com/3f32e30a7/p/09475c-colour/t/13a1c9

  static const Color skyBlue = Color(0xFF00A1FF);
  static const Color skyBlueLight = Color(0xFF99D9FF);
  static const Color eggplantLight = Color(0xFFBC70F1);

  // Alerts & notifications
  // https://zeroheight.com/3f32e30a7/p/09475c-colour/t/071de9

  static const Color cucumber = Color(0xFF00864E);
  static const Color chilli = Color(0xFFEC0026);

  // blueberry - already defined within 'Default text links' section;

  // Rating system colours
  // https://zeroheight.com/3f32e30a7/p/09475c-colour/t/56d425

  static const Color gold = Color(0xFFBF7D20);
  static const Color silver = Color(0xFF746C80);
  static const Color bronze = Color(0xFF89420E);
  static const Color platinum = Color(0xFF578D87);

  // Active 'focus state' colour
  // https://zeroheight.com/3f32e30a7/p/09475c-colour/t/36e097
  static const Color banana = Color(0xFFFFBE2C);

  // Main material color
  static const MaterialColor primaryAuroraColor = const MaterialColor(
    _auroraPrimary,
    <int, Color>{
      50: ColorPalette.sunrise,
      100: ColorPalette.aurora10,
      200: ColorPalette.aurora20,
      300: ColorPalette.shepherdsDelight,
      400: ColorPalette.aurora40,
      500: ColorPalette.aurora50,
      600: ColorPalette.aurora60,
      700: ColorPalette.aurora70,
      800: ColorPalette.aurora80,
      900: ColorPalette.aurora90,
    },
  );
  static const int _auroraPrimary = 0xFFFF7B67;

  // Divider
  // https://zeroheight.com/3f32e30a7/p/690d10-dividers
  static const Color primaryDivider = liquorice;
  static const Color secondaryDivider = Color(0xFF757575);
}
