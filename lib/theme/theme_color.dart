import 'package:flutter/material.dart';

// convenience
AppColor appColors() => const AppColor.getColor();

class AppColor {
  final Color primaryActive;
  final Color primaryActiveLight;
  final Color primaryInactive;
  final Color primaryInactiveLight;
  final Color warning;
  final Color error;
  final Color blueColor;
  final Color themeDartGreen;
  final Color greenColors1;
  final Color loginGradientStart;
  final Color loginGradientEnd;
  final Color textColor;

  const AppColor({
    this.themeDartGreen,
    this.warning,
    this.error,
    this.primaryActive,
    this.primaryActiveLight,
    this.primaryInactive,
    this.primaryInactiveLight,
    this.blueColor,
    this.greenColors1,
    this.loginGradientStart,
    this.loginGradientEnd,
    this.textColor
  });

  const AppColor.getColor()
      : primaryActive = Colors.black,
        primaryActiveLight = Colors.lightBlueAccent,
        primaryInactive = Colors.blueGrey,
        primaryInactiveLight = Colors.grey,
        warning = const Color(0xFFC97100),
        error = const Color(0xFFFC3D0B),
        blueColor = const Color.fromRGBO(20, 118, 252, 1),
        themeDartGreen = const Color(0xFF2e7d32),
        greenColors1 = const Color(0xFF4CAF50),
        loginGradientStart = const  Color(0xFFfd6a15),
        loginGradientEnd = const  Color(0XFF65739d),
        textColor = const  Color(0XFF012c47);

//        lightGrey = const Color.fromRGBO(245, 245, 245, 1),
}
