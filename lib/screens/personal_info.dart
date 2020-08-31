import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lahma/api/API.dart';
import 'package:lahma/component/custom_app_bar.dart';
import 'package:lahma/component/display_alert_widget.dart';
import 'package:lahma/model/language_model.dart';
import 'package:lahma/styles/strings.dart';
import 'package:lahma/theme/theme.dart';
import 'package:lahma/utils/ShareManager.dart';
import 'package:lahma/utils/app_routes.dart';
import 'package:lahma/utils/app_translations.dart';
import 'package:lahma/utils/application.dart';
import 'package:lahma/utils/size_config.dart';

class PersonalInfo extends StatefulWidget {
  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  AppTranslations _localization;
  static final List<String> langList = application.supportedLanguages;
  static final List<String> langCodesList = application.supportedLanguagesCodes;
  List<LanguageModel> listLangauge = new List();
  TextEditingController controller = TextEditingController();
  String languageName = "", languageCode = "en";
  bool isLoading = false;
  String token;

  loadLangaugeList(String setCode) {
    for (int i = 0; i < langList.length; i++) {
      String name = langList[i];
      String code = langCodesList[i];

      if (code == setCode) {
        languageName = name;
        languageCode = code;
      }

      listLangauge.add(new LanguageModel(name, code));
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    ShareMananer.getUserDetails().then((value) {
      languageName = value["language"];
      token = value["access_token"];
      controller.text=value["name"];
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
        appBar: _appBar(),
        body: Stack(
          children: <Widget>[
            _background(),
            isLoading
                ? showProgress(context)
                : SizedBox(
                    height: 0.0,
                  ),
          ],
        ));
  }

  Widget _background() {
    return Stack(
      children: <Widget>[
        Container(
          child: Image.asset(
            BACKGROUND_IMAGE,
            fit: BoxFit.fill,
          ),
        ),
        _body(),
      ],
    );
  }

  Widget _body() {
    return Container(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: AppSize.large,
          ),
          Text(
            _localization.localeString("enter_full_name"),
            style: AppTheme.textStyle.fieldText,
          ),
          SizedBox(
            height: AppSize.medium,
          ),
          Container(
            height: 35,
            width: SizeConfig.widthMultiplier * 75,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                  top: AppSize.extraSmall,
                  right: AppSize.extraSmall,
                  left: AppSize.extraSmall,
                ),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
              ),
            ),
          ),
          SizedBox(
            height: AppSize.medium,
          ),
          MaterialButton(
              height: SizeConfig.heightMultiplier * 3.5,
              minWidth: SizeConfig.widthMultiplier * 35,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              color: AppTheme.primaryColor,
              child: Text(_localization.localeString("send"),
                  style: TextStyle(color: Colors.white)),
              onPressed: updateDetails)
        ],
      ),
    );
  }

  updateDetails() {
    loadProgress();
    Map<String, String> args = Map<String, String>();
    args["name"] = controller.text.trim();
    API.post1(API.profile, args, token).then((value) {
      loadProgress();
      final data = json.decode(value.body);
      print(data);
      if (value.statusCode == 200) {
        ShareMananer.setUserName(controller.text.trim());
        AppRoutes.dismiss(context);
      }
    });
  }

  loadProgress() {
    isLoading = !isLoading;
    setState(() {});
  }

  Widget _appBar() {
    return AppBar(
      centerTitle: true,
      title: Text(_localization.localeString("personal_info")),
      leading: IconButton(
        icon: Image.asset(
          CLOSE_ICON,
          height: 20,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
