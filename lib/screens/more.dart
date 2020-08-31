import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:lahma/component/custom_app_bar_with_logoutwidget.dart';
import 'package:lahma/component/display_alert_widget.dart';
import 'package:lahma/component/language_widget.dart';
import 'package:lahma/model/language_model.dart';
import 'package:lahma/screens/address.dart';
import 'package:lahma/screens/personal_info.dart';
import 'package:lahma/screens/share.dart';
import 'package:lahma/styles/strings.dart';
import 'package:lahma/theme/theme.dart';
import 'package:lahma/utils/ShareManager.dart';
import 'package:lahma/utils/app_routes.dart';
import 'package:lahma/utils/app_translations.dart';
import 'package:lahma/utils/application.dart';
import 'package:lahma/utils/size_config.dart';

class MoreScreen extends StatefulWidget {
  _MoreScreen createState() => _MoreScreen();
}

class _MoreScreen extends State<MoreScreen> {
  AppTranslations _localization;
  static final List<String> langList = application.supportedLanguages;
  static final List<String> langCodesList = application.supportedLanguagesCodes;
  List<LanguageModel> listLangauge = new List();
  String languageName = "", languageCode = "en";

  int counter = 0;

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
      print(languageName);
      loadLangaugeList(value["language"]);
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _localization = AppTranslations.of(context);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    //  appSizeInit(context);
    return Directionality(
      textDirection:
          languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppSize.xxL),
          child: CustomAppBarWithLogoutWidget(
            title: _localization.localeString("More"),
            secondTitle: _localization.localeString("logout"),
            onTabSecondTitle: (){
              _logout();
              ShareMananer.logOut(context);
            },
          ),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              child: Image.asset(
                BACKGROUND_IMAGE,
                 width: double.maxFinite,
                fit: BoxFit.fill,
              ),
            ),
            _body(),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    /// Method to Logout the `FirebaseUser` (`_firebaseUser`)
    try {
      print("sadasd");
      // signout code
      await FirebaseAuth.instance.signOut();

    } catch (e) {

      print(e.toString());
    }
  }

  Widget _body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: AppSize.extraSmall,
        ),
        moreOption(_localization.localeString("PersonalInformation"), () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => PersonalInfo()));
        }),
        moreOption(_localization.localeString("Address"), () {
          AppRoutes.goto(context, AddressScreen());
        }),
        moreOption(_localization.localeString(languageName), () {
          languagePopup(context);
        }),
        moreOption(_localization.localeString("Share"), () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ShareScreen()));
        }),

      ],
    );
  }

  Widget moreOption(String title, GestureTapCallback onTab) {
    return GestureDetector(
      onTap: () {
        onTab();
      },
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(
            top: AppSize.extraSmall,
            left: AppSize.extraSmall,
            right: AppSize.extraSmall),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                width: double.maxFinite,
                child: Text(
                  title,
                  style: AppTheme.textStyle.lightText
                      .copyWith(color: AppTheme.primaryColor),
                )),
            SizedBox(
              height: AppSize.extraSmall,
            ),
            Divider(color: AppTheme.diverColor, thickness: 1.0)
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<bool> languagePopup(BuildContext context) {
    print(listLangauge.length);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Directionality(
            textDirection:
                languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
            child: StatefulBuilder(
              builder: (context, setState) {
                {
                  return AlertDialog(
                    title: Text(_localization.localeString("selectLanguage")),
                    content: Container(
                      width: double.maxFinite,
                      //height: 200.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: listLangauge.length,
                            itemBuilder: (BuildContext context, int index) {
                              return LangaugeWidget(
                                name: listLangauge[index].name,
                                isSelected:
                                    listLangauge[index].name == languageName
                                        ? true
                                        : false,
                                onTab: () {
                                  application.onLocaleChanged(
                                      Locale(listLangauge[index].code));
                                  ShareMananer.setLanguageSetting(
                                      listLangauge[index].code);
                                  languageName = listLangauge[index].name;
                                  languageCode = listLangauge[index].code;

                                  setState(() {});

                                  AppRoutes.dismiss(context);
                                  Phoenix.rebirth(context);
                                },
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          );
        });
  }
}
