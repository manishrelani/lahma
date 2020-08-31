import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lahma/api/API.dart';
import 'package:lahma/api/Database.dart';
import 'package:lahma/component/custom_app_bar.dart';
import 'package:lahma/component/display_alert_widget.dart';
import 'package:lahma/screens/shopping_basket.dart';

import 'package:lahma/styles/strings.dart';
import 'package:lahma/theme/theme.dart';

import 'package:lahma/utils/ShareManager.dart';
import 'package:lahma/utils/app_routes.dart';

import 'package:lahma/utils/app_translations.dart';
import 'package:lahma/utils/application.dart';
import 'package:lahma/utils/size_config.dart';

class OfferScreen extends StatefulWidget {
  _OfferScreen createState() => _OfferScreen();
}

class _OfferScreen extends State<OfferScreen> {
  AppTranslations _localization;
  static final List<String> langList = application.supportedLanguages;
  static final List<String> langCodesList = application.supportedLanguagesCodes;
  String languageName = "", languageCode = "en";
  int counter = 0,cartTotal=0;
  String token;
  int length;
  bool isLoading = false;
  var data;

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
    loadProgress();
    ShareMananer.getUserDetails().then((value) {
      languageName = value["language"];
      token = value["access_token"];
      print(languageName);
      loadLangaugeList(value["language"]);
      API.get1(API.coupons, token).then((value) {
        loadProgress();
        data = json.decode(value.body);
        print(data);
        if (value.statusCode == 200) {
          setState(() {
            length = data.length;
          });
        }
      });
    });

    setState(() {});
  }

  getCart()async{
    cartTotal = await SQLiteDbProvider.db.getCount();
    print(cartTotal);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    _localization = AppTranslations.of(context);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    //  appSizeInit(context);
    return Scaffold(
        appBar:AppBar(
      elevation: 0,
      centerTitle: true,
      title: Text(_localization.localeString("Offers")),
      actions: [
        SizedBox(
          width: 10,
        ),
        Stack(
          children: <Widget>[
            IconButton(
              color: Colors.blue,
              iconSize: 15.0,
              icon: new Image.asset(ICON_CART, color: Colors.white),
              onPressed: () {
                AppRoutes.goto(context, ShoppingBasket());
              },
            ),

            cartTotal!=0? Positioned(
              top: 0,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                width: 20.0,
                height: 20.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0)

                ),
                child: Text(cartTotal.toString(),style: TextStyle(color: AppTheme.primaryColor,fontSize: AppFontSize.s10),textAlign: TextAlign.center,),),
            ):SizedBox(width: 0,)

          ],),
        SizedBox(
          width: 10,
        ),
      ],
    ),
        body: Stack(
          children: <Widget>[
            data == null ? Container() : _background(),
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
    return Directionality(
        textDirection:
            languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        child: ListView.builder(
            itemCount: length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: double.infinity,
                child: Stack(
                  children: [

                    CachedNetworkImage(
                      imageUrl: data[index]["image"],
                      height: SizeConfig.heightMultiplier * 20,
                      width: double.maxFinite,
                      fit: BoxFit.fill,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                      errorWidget: (context, url, error) => Icon(
                        Icons.error,
                        size: SizeConfig.heightMultiplier * 11,
                      ),
                    ),


                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        width: SizeConfig.widthMultiplier*100,
                        color: Colors.black.withOpacity(0.5),
                        height: SizeConfig.heightMultiplier*5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                data[index]["post_title"],
                                style: TextStyle(color: Colors.white,fontSize: 12),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                data[index]["date_expires"],
                                style: TextStyle(color: Colors.white,fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }));
  }

  loadProgress() {
    isLoading = !isLoading;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }
}
