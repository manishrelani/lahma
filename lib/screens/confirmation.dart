import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lahma/component/custom_app_bar.dart';
import 'package:lahma/styles/strings.dart';
import 'package:lahma/theme/theme.dart';
import 'package:lahma/utils/ShareManager.dart';
import 'package:lahma/utils/app_routes.dart';
import 'package:lahma/utils/app_translations.dart';
import 'package:lahma/utils/application.dart';
import 'package:lahma/utils/size_config.dart';

import 'order_details.dart';

class Confirmation extends StatefulWidget {
  final String id;
  Confirmation(this.id);
  @override
  _ConfirmationState createState() => _ConfirmationState();
}

class _ConfirmationState extends State<Confirmation> {
  AppTranslations _localization;
  static final List<String> langList = application.supportedLanguages;
  static final List<String> langCodesList = application.supportedLanguagesCodes;
  String languageName = "", languageCode = "en";

  loadLangaugeList(String setCode) {
    for (int i = 0; i < langList.length; i++) {
      String name = langList[i];
      String code = langCodesList[i];

      if (code == setCode) {
        languageName = name;
        languageCode = code;
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    ShareMananer.getUserDetails().then((value) {
      languageName = value["language"];
      print(languageName);
      loadLangaugeList(value["language"]);
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    _localization = AppTranslations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_localization.localeString("successfully_executed")),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: Image.asset(
              BACKGROUND_IMAGE,
              fit: BoxFit.fill,
            ),
          ),
          _body(context),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${_localization.localeString("order_number")} #${widget.id}",
            style: AppTheme.textStyle.fieldTitle,
          ),
          Image.asset(
            CHECKBOX_ACTIVE,
            height: SizeConfig.heightMultiplier * 8,
            fit: BoxFit.fill,
          ),
          Container(
              width: SizeConfig.widthMultiplier * 50,
              child: Text(
                _localization.localeString("request_msg"),
                style: AppTheme.textStyle.fieldText,
                textAlign: TextAlign.center,
              )),
          MaterialButton(
            minWidth: SizeConfig.widthMultiplier * 50,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            onPressed: () {
              AppRoutes.replace(context, OrderDetails(widget.id));
            },
            color: AppTheme.primaryColor,
            child: Text(
              _localization.localeString("follow_up"),
              style: TextStyle(color: Colors.white),
            ),
          ),
          Text(
            _localization.localeString("what_then"),
            style: AppTheme.textStyle.fieldTitle,
          ),
          Image.asset(
            ENVELOPE_ICON,
            height: SizeConfig.heightMultiplier * 7,
            fit: BoxFit.fill,
          ),
          Text(
            _localization.localeString("confirmation_msg"),
            style: AppTheme.textStyle.fieldTitle,
          ),
          Image.asset(
            HELP_ICON,
            height: SizeConfig.heightMultiplier * 10,
            fit: BoxFit.fill,
          ),
          Text(
            "${_localization.localeString("assistance")} 12345678",
            style: AppTheme.textStyle.fieldTitle,
          ),
        ],
      ),
    );
  }
}
