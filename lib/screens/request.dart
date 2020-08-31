import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lahma/component/language_widget.dart';
import 'package:lahma/model/language_model.dart';
import 'package:lahma/styles/strings.dart';
import 'package:lahma/theme/theme.dart';
import 'package:lahma/utils/ShareManager.dart';
import 'package:lahma/utils/app_routes.dart';
import 'package:lahma/utils/app_translations.dart';
import 'package:lahma/utils/application.dart';
import 'package:lahma/utils/size_config.dart';


class RequestScreen extends StatefulWidget {
  _RequestScreen createState() => _RequestScreen();
}

class _RequestScreen extends State<RequestScreen> {
  AppTranslations _localization;
  static final List<String> langList = application.supportedLanguages;
  static final List<String> langCodesList =application.supportedLanguagesCodes;
  String languageName="",languageCode="en";
  int counter = 0;

  loadLangaugeList(String setCode){

    for(int i =0;i<langList.length;i++)
    {
      String name = langList[i];
      String code = langCodesList[i];

      if(code==setCode)
      {
        languageName=name;
        languageCode=code;
      }

    }
    setState(() {

    });
  }
  @override
  void initState() {
    super.initState();


    ShareMananer.getUserDetails().then((value) {
      languageName=value["language"];
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
    return Scaffold(
      appBar: _appBar(),
      body: Stack(
        children: <Widget>[
          Container(
            child: Image.asset(
              BACKGROUND_IMAGE,
              fit: BoxFit.fill,
            ),
          ),
          _body(),
        ],
      ),
    );
  }

  Widget _body() {
    return Directionality(
      textDirection: languageCode == 'ar'?TextDirection.rtl : TextDirection.ltr,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[


      ],),
    );
  }

  Widget _appBar() {
    return AppBar(
      centerTitle: true,
      title: Text(_localization.localeString("Product")),
      leading: IconButton(
        color: Colors.blue,
        iconSize: 15.0,
        icon: new Image.asset(ICON_CART, color: Colors.white),
        onPressed: () {},
      ),
    );
  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }



}
