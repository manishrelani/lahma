import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lahma/model/language_model.dart';
import 'package:lahma/styles/strings.dart';
import 'package:lahma/theme/theme.dart';
import 'package:lahma/utils/ShareManager.dart';
import 'package:lahma/utils/app_translations.dart';
import 'package:lahma/utils/application.dart';
import 'package:lahma/utils/size_config.dart';
import 'package:share/share.dart';

class ShareScreen extends StatefulWidget {
  @override
  _ShareScreenState createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  AppTranslations _localization;
  static final List<String> langList = application.supportedLanguages;
  static final List<String> langCodesList = application.supportedLanguagesCodes;
  List<LanguageModel> listLangauge = new List();
  TextEditingController controller = TextEditingController();
  String languageName = "", languageCode = "en";

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
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    _localization = AppTranslations.of(context);
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  Widget _body() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 40,
            width: SizeConfig.widthMultiplier * 75,
            child: TextField(
              readOnly: true,
             //controller: controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                  top: AppSize.extraSmall,
                  right: AppSize.extraSmall,
                  left: AppSize.extraSmall,
                ),
               //prefixText: "I like app lahma share it now",
               hintText: _localization.localeString("i_like_app"),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
              ),
            ),
          ),
          SizedBox(
            height: AppSize.medium,
          ),
          _row(),
          SizedBox(
            height: AppSize.medium,
          ),
          MaterialButton(
              // height: SizeConfig.heightMultiplier * 3.5,
              minWidth: SizeConfig.widthMultiplier * 35,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              color: AppTheme.primaryColor,
              child: Text(_localization.localeString("share_app"),
                  style: TextStyle(color: Colors.white)),
              onPressed: () {
                Share.share(_localization.localeString("i_like_app"));
              })
        ],
      ),
    );
  }

  Widget _row() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(SHARE1),
        SizedBox(width: AppSize.small),
        Image.asset(SHARE2),
        // Image.asset(SHARE3),
      ],
    );
  }

  Widget _appBar() {
    return AppBar(
      centerTitle: true,
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
