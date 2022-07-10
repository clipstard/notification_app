import 'package:flutter/material.dart';
import 'package:notification_app/constants/colors.dart';
import 'fonts.dart';

class TextTypography {
  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  TextTypography._();

  // Headline 1
  // https://zeroheight.com/3f32e30a7/p/0906b0-typography/t/60c727
  // Mobile
  static final TextStyle h1_m = TextStyle(
    fontFamily: FontFamily.headlineFontFamily,
    fontSize: 36.0,
    fontWeight: FontWeight.w700,
    height: 1.111, // 40
  );

  static final TextStyle h1_m_light = TextTypography.h1_m.copyWith(
    fontWeight: FontWeight.w300,
  );

  static const double h1_m_mb = 20.0;

  // Desktop
  static final TextStyle h1_d = TextStyle(
    fontFamily: FontFamily.headlineFontFamily,
    fontSize: 61.0,
    fontWeight: FontWeight.w700,
    height: 1.065573770491803, // 65
    letterSpacing: -1,
  );

  static final TextStyle h1_d_light = TextTypography.h1_d.copyWith(
    fontWeight: FontWeight.w300,
  );

  static const double h1_d_mb = 25.0;

  // Headline 2
  // https://zeroheight.com/3f32e30a7/p/0906b0-typography/t/3585f6
  // Mobile
  static final TextStyle h2_m = TextStyle(
    fontFamily: FontFamily.headlineFontFamily,
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    height: 1.25, // 30
  );

  static final TextStyle h2_m_light = TextTypography.h2_m.copyWith(
    fontWeight: FontWeight.w300,
  );

  static const double h2_m_mb = 15.0;

  // Desktop
  static final TextStyle h2_d = TextStyle(
    fontFamily: FontFamily.headlineFontFamily,
    fontSize: 37.0,
    fontWeight: FontWeight.w700,
    height: 1.216216216216216, // 45
  );

  static final TextStyle h2_d_light = TextTypography.h2_d.copyWith(
    fontWeight: FontWeight.w300,
  );

  static const double h2_d_mb = 15.0;

  // Headline 3
  // https://zeroheight.com/3f32e30a7/p/0906b0-typography/t/75a71f
  // Mobile
  static final TextStyle h3_m = TextStyle(
    fontFamily: FontFamily.headlineFontFamily,
    fontSize: 20.0,
    fontWeight: FontWeight.w700,
    height: 1.25, // 25
  );

  static final TextStyle h3_m_light = TextTypography.h3_m.copyWith(
    fontWeight: FontWeight.w300,
  );

  static const double h3_m_mb = 10.0;

  // Desktop
  static final TextStyle h3_d = TextStyle(
    fontFamily: FontFamily.headlineFontFamily,
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    height: 1.25, // 30
  );

  static final TextStyle h3_d_light = TextTypography.h3_d.copyWith(
    fontWeight: FontWeight.w300,
  );

  static const double h3_d_mb = 10.0;

  // Headline 4
  // https://zeroheight.com/3f32e30a7/p/0906b0-typography/t/456996
  // Mobile
  static final TextStyle h4_m = TextStyle(
    fontFamily: FontFamily.headlineFontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
    height: 1.5625, // 25
  );

  static final TextStyle h4_m_light = TextTypography.h4_m.copyWith(
    fontWeight: FontWeight.w300,
  );

  static const double h4_m_mb = 5.0;

  // Desktop
  static final TextStyle h4_d = TextStyle(
    fontFamily: FontFamily.headlineFontFamily,
    fontSize: 18.0,
    fontWeight: FontWeight.w700,
    height: 1.38, // 25
  );

  static final TextStyle h4_d_light = TextTypography.h4_d.copyWith(
    fontWeight: FontWeight.w300,
  );

  static const double h4_d_mb = 10.0;

  // Hero
  // https://zeroheight.com/3f32e30a7/p/0906b0-typography/t/63b2e2
  // Mobile
  static final TextStyle hero_m = TextStyle(
    fontFamily: FontFamily.heroFontFamily,
    fontSize: 46.0,
    fontWeight: FontWeight.w700,
    height: 1.08695652173913, // 50
    letterSpacing: -1,
  );

  static final TextStyle hero_m_light = TextTypography.hero_m.copyWith(
    fontWeight: FontWeight.w300,
  );

  static const double hero_m_mb = 25.0;

  // Desktop
  static final TextStyle hero_d = TextStyle(
    fontFamily: FontFamily.heroFontFamily,
    fontSize: 80.0,
    fontWeight: FontWeight.w700,
    height: 1.0625, // 85
    letterSpacing: -1,
  );

  static final TextStyle hero_d_light = TextTypography.hero_d.copyWith(
    fontWeight: FontWeight.w300,
  );

  static const double hero_d_mb = 50.0;

  // Emphasis
  // https://zeroheight.com/3f32e30a7/p/0906b0-typography/t/134ace
  // Mobile
  static final TextStyle emphasis_m = TextStyle(
    fontFamily: FontFamily.emphasisFontFamily,
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    height: 1.25, // 30
  );

  static final TextStyle emphasis_m_light = TextTypography.emphasis_m.copyWith(
    fontWeight: FontWeight.w300,
  );

  static const double emphasis_m_mb = 15.0;

  // Desktop
  static final TextStyle emphasis_d = TextStyle(
    fontFamily: FontFamily.emphasisFontFamily,
    fontSize: 37.0,
    fontWeight: FontWeight.w700,
    height: 1.216216216216216, // 45
  );

  static final TextStyle emphasis_d_light = TextTypography.emphasis_d.copyWith(
    fontWeight: FontWeight.w300,
  );

  static const double emphasis_d_mb = 15.0;

  // Emphasis Small
  // https://zeroheight.com/3f32e30a7/p/0906b0-typography/t/92ccbc
  // Mobile
  static final TextStyle emphasis_m_sm = TextStyle(
    fontFamily: FontFamily.emphasisFontFamily,
    fontSize: 20.0,
    fontWeight: FontWeight.w700,
    height: 1.25, // 25
  );

  static final TextStyle emphasis_m_sm_light =
      TextTypography.emphasis_m_sm.copyWith(
    fontWeight: FontWeight.w300,
  );

  static const double emphasis_m_sm_mb = 10.0;

  // Desktop
  static final TextStyle emphasis_d_sm = TextStyle(
    fontFamily: FontFamily.emphasisFontFamily,
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    height: 1.25, // 30
  );

  static final TextStyle emphasis_d_sm_light =
      TextTypography.emphasis_d_sm.copyWith(
    fontWeight: FontWeight.w300,
  );

  static const double emphasis_d_sm_mb = 10.0;

  // Body copy (bodyText2)
  // https://zeroheight.com/3f32e30a7/p/0906b0-typography/t/45c84c
  static final TextStyle body_copy = TextTypography.intro_copy_m;

  static const double body_copy_mb = intro_copy_m_mb;

  // Introduction copy (bodyText1)
  // https://zeroheight.com/3f32e30a7/p/0906b0-typography/t/37c89e
  // Mobile
  static final TextStyle intro_copy_m = TextStyle(
    fontFamily: FontFamily.defaultFontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    height: 1.5625, // 25
  );

  static const double intro_copy_m_mb = 35.0;

  // Desktop
  static final TextStyle intro_copy_d = TextStyle(
    fontFamily: FontFamily.defaultFontFamily,
    fontSize: 18.0,
    fontWeight: FontWeight.w400,
    height: 1.6666, // 30
  );

  static const double intro_copy_d_mb = 40.0;

  // Small
  // https://zeroheight.com/3f32e30a7/p/0906b0-typography/t/734dc9
  static final TextStyle small = TextTypography.body_copy.copyWith(
    fontSize: 14.0,
    height: 1.428571428571429, // 20
  );

  // Extra small
  // https://zeroheight.com/3f32e30a7/p/0906b0-typography/t/00abda
  static final TextStyle small_xs = TextTypography.small.copyWith(
    fontSize: 12.0,
    height: 1.25, // 15
  );

  // Label
  // https://zeroheight.com/3f32e30a7/p/0906b0-typography/t/38d62d
  static final TextStyle label = TextTypography.body_copy.copyWith(
    fontWeight: FontWeight.bold,
  );

  // Buttons
  // https://zeroheight.com/3f32e30a7/p/972f0f-buttons/i/39624050
  static final TextStyle button = TextStyle(
    fontFamily: FontFamily.defaultFontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
    height: 1.5625, // 25
  );

  static final TextStyle link = TextTypography.body_copy.copyWith(
    color: ColorPalette.blueberry,
    decoration: TextDecoration.underline,
    fontSize: 16.0,
  );

  /// Default text theme.
  ///
  /// This [TextTheme] provides geometry and not colors.
  static final TextTheme defaultTextTheme = TextTheme(
    headline1: TextTypography.h1_m,
    headline2: TextTypography.h2_m,
    headline3: TextTypography.h3_m,
    headline4: TextTypography.h4_m,
    headline5: TextTypography.small,
    headline6: TextTypography.small_xs,
    bodyText1: TextTypography.intro_copy_m,
    bodyText2: TextTypography.body_copy,
    subtitle1: TextTypography.intro_copy_m,
    subtitle2: TextTypography.body_copy,
    caption: TextTypography.small,
    overline: TextTypography.hero_m,
    button: TextTypography.button,
  );
}
