import 'package:flutter/material.dart';
import 'package:lahma/theme/theme.dart';
import 'package:lahma/utils/size_config.dart';
import 'package:meta/meta.dart';

@immutable
class AppTextStyle {
  static const TextDecoration underline = TextDecoration.underline;
  static const TextDecoration lineThrough = TextDecoration.lineThrough;

  static const String _regular = "assets/font/net_pro.ttf";

  final TextStyle heading1;
  final TextStyle alertText;
  final TextStyle alertTitle;
  final TextStyle hintText;
  final TextStyle errorStyle;
  final TextStyle lightHeading;
  final TextStyle lightText;
  final TextStyle timerTextActive;
  final TextStyle timerTextInActive;
  final TextStyle buttonText;
  final TextStyle screenTitle;
  final TextStyle screenTitleBig;
  final TextStyle labelStyle;
  final TextStyle normalStyle;
  final TextStyle fieldText;
  final TextStyle fieldTitle;
  final TextStyle navigationTitleStyle;

  AppTextStyle(
      {this.screenTitle,
      this.timerTextActive,
      this.timerTextInActive,
      this.heading1,
      this.lightHeading,
      this.alertText,
      this.alertTitle,
      this.hintText,
      this.errorStyle,
      this.lightText,
      this.buttonText,
      this.screenTitleBig,
      this.labelStyle,
      this.normalStyle,
      this.fieldText,
      this.fieldTitle,
      this.navigationTitleStyle});

  AppTextStyle.getStyle()
      : screenTitle = new TextStyle(
          fontFamily: _regular,
          fontSize: AppFontSize.s20,
          color: Colors.white,
          inherit: true,
        ),
        navigationTitleStyle = new TextStyle(
          fontFamily: _regular,
          fontSize: AppFontSize.s18,
          color: Colors.white,
          fontWeight: FontWeight.w400,
          inherit: true,
        ),
        normalStyle = new TextStyle(
          fontFamily: _regular,
          fontSize: AppFontSize.s16,
          color: Colors.white,
          inherit: true,
        ),
        labelStyle = new TextStyle(
          fontFamily: _regular,
          fontSize: AppFontSize.s16,
          color: Colors.white,
          inherit: true,
        ),
        screenTitleBig = new TextStyle(
          fontFamily: _regular,
          fontSize: AppFontSize.s28,
          color: Colors.white,
          fontWeight: FontWeight.w600,
          inherit: true,
        ),
        buttonText = TextStyle(
          fontFamily: _regular,
          fontSize: AppFontSize.s18,
          color: Colors.white,
          fontWeight: FontWeight.w600,
          inherit: false,
        ),
        timerTextActive = new TextStyle(
          fontFamily: _regular,
          fontSize: AppFontSize.s16,
          color: Colors.black,
          inherit: false,
        ),
        timerTextInActive = new TextStyle(
          fontFamily: _regular,
          fontSize: AppFontSize.s16,
          color: Colors.black,
          decoration: underline,
          inherit: false,
        ),
        lightHeading = new TextStyle(
          fontFamily: _regular,
          fontSize: AppFontSize.s20,
          color: Colors.black,
          inherit: false,
        ),
        lightText = new TextStyle(
          fontFamily: _regular,
          fontSize: AppFontSize.s16,
          color: Colors.white,
          inherit: true,
        ),
        heading1 = new TextStyle(
          fontFamily: _regular,
          fontSize: AppFontSize.s20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          inherit: false,
        ),
        alertTitle = new TextStyle(
          fontFamily: _regular,
          fontSize: AppFontSize.s18,
          fontWeight: FontWeight.bold,
          color: Colors.grey[400],
          inherit: false,
        ),
        alertText = new TextStyle(
          fontFamily: _regular,
          fontSize: AppFontSize.s16,
          color: Colors.black,
          inherit: false,
        ),
        hintText = new TextStyle(
          fontFamily: _regular,
          fontSize: AppFontSize.s16,
          color: Colors.white,
          inherit: false,
        ),
        fieldText = new TextStyle(
          fontFamily: _regular,
          fontSize: AppFontSize.s14,
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.bold,
          inherit: false,
        ),
        fieldTitle = new TextStyle(
          fontFamily: _regular,
          fontSize: AppFontSize.s13,
          color: Colors.black,
          fontWeight: FontWeight.bold,
          inherit: false,
        ),
        errorStyle = new TextStyle(
          fontFamily: _regular,
          fontSize: AppFontSize.s10,
          color: Colors.red,
          inherit: false,
        );
}
