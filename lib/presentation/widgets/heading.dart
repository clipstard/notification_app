import 'package:flutter/material.dart';
import 'package:notification_app/constants/colors.dart';
import 'package:notification_app/constants/typography.dart';

enum HeadingType {
  h1,
  h2,
  h3,
  h4,
  hero,
}

enum HeadingTarget {
  mobile,
  desktop,
}

enum HeadingVariant {
  regular,
  light,
}

/// Widget used to draw typogrpahy heading defined by Atomic UI Toolkit.
/// https://zeroheight.com/3f32e30a7/p/0906b0-typography/t/12a7b5
class Heading extends StatelessWidget {
  final String text;
  final Color? color;
  final HeadingType? type;
  final HeadingVariant? variant;
  final HeadingTarget? target;
  final TextAlign? textAlign;

  Heading(
    this.text, {
    this.color = ColorPalette.liquorice,
    this.type = HeadingType.h1,
    this.variant = HeadingVariant.regular,
    this.target = HeadingTarget.mobile,
    this.textAlign = TextAlign.left,
  });

  final Map<HeadingType, Map<String, Map<HeadingTarget, dynamic>>> _styleMap =
      <HeadingType, Map<String, Map<HeadingTarget, dynamic>>>{
    HeadingType.h1: <String, Map<HeadingTarget, dynamic>>{
      'style': <HeadingTarget, dynamic>{
        HeadingTarget.mobile: TextTypography.h1_m,
        HeadingTarget.desktop: TextTypography.h1_d
      },
      'margin': <HeadingTarget, dynamic>{
        HeadingTarget.mobile: TextTypography.h1_m_mb,
        HeadingTarget.desktop: TextTypography.h1_d_mb
      },
    },
    HeadingType.h2: <String, Map<HeadingTarget, dynamic>>{
      'style': <HeadingTarget, dynamic>{
        HeadingTarget.mobile: TextTypography.h2_m,
        HeadingTarget.desktop: TextTypography.h2_d
      },
      'margin': <HeadingTarget, dynamic>{
        HeadingTarget.mobile: TextTypography.h2_m_mb,
        HeadingTarget.desktop: TextTypography.h2_d_mb
      },
    },
    HeadingType.h3: <String, Map<HeadingTarget, dynamic>>{
      'style': <HeadingTarget, dynamic>{
        HeadingTarget.mobile: TextTypography.h3_m,
        HeadingTarget.desktop: TextTypography.h3_d
      },
      'margin': <HeadingTarget, dynamic>{
        HeadingTarget.mobile: TextTypography.h3_m_mb,
        HeadingTarget.desktop: TextTypography.h3_d_mb
      },
    },
    HeadingType.h4: <String, Map<HeadingTarget, dynamic>>{
      'style': <HeadingTarget, dynamic>{
        HeadingTarget.mobile: TextTypography.h4_m,
        HeadingTarget.desktop: TextTypography.h4_d
      },
      'margin': <HeadingTarget, dynamic>{
        HeadingTarget.mobile: TextTypography.h4_m_mb,
        HeadingTarget.desktop: TextTypography.h4_d_mb
      },
    },
    HeadingType.hero: <String, Map<HeadingTarget, dynamic>>{
      'style': <HeadingTarget, dynamic>{
        HeadingTarget.mobile: TextTypography.hero_m,
        HeadingTarget.desktop: TextTypography.hero_d
      },
      'margin': <HeadingTarget, dynamic>{
        HeadingTarget.mobile: TextTypography.hero_m_mb,
        HeadingTarget.desktop: TextTypography.hero_d_mb
      },
    },
  };

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = _styleMap[type]!['style']![target] as TextStyle;
    double marginBottom = _styleMap[type]!['margin']![target] as double;

    return Container(
      margin: EdgeInsets.only(bottom: marginBottom),
      child: Text(
        text,
        style: textStyle.copyWith(
          color: color,
          fontWeight: variant == HeadingVariant.light
              ? FontWeight.w300
              : textStyle.fontWeight,
        ),
        textAlign: textAlign,
      ),
    );
  }
}
