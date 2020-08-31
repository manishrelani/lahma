import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:lahma/theme/theme_color.dart';
import 'package:lahma/theme/theme_text_style.dart';

//class Colors {
//
//  const Colors();
//
//  static const Color loginGradientStart = const Color(0xFFfbab66);
//  static const Color loginGradientEnd = const Color(0xFFf7418c);
//
//  static const primaryGradient = const LinearGradient(
//    colors: const [loginGradientStart, loginGradientEnd],
//    stops: const [0.0, 1.0],
//    begin: Alignment.topCenter,
//    end: Alignment.bottomCenter,
//  );
//}

class AppTheme {
  static const Color primaryColor = const Color(0XFFb62c2f);
    static const Color accentColor = const Color(0XFFb62c2f);
  static const Color diverColor = const Color(0XFFc7c7c7);
  static AppColor get colors {
    return new AppColor.getColor();
  }

  static AppTextStyle get textStyle {
    return new AppTextStyle.getStyle();
  }
}
