import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:lahma/api/Database.dart';

import 'package:lahma/component/custom_app_bar.dart';
import 'package:lahma/component/display_alert_widget.dart';
import 'package:lahma/model/language_model.dart';

import 'package:lahma/screens/order_page.dart';
import 'package:lahma/screens/shopping_basket.dart';
import 'package:lahma/styles/strings.dart';
import 'package:lahma/theme/theme.dart';
import 'package:lahma/utils/ShareManager.dart';
import 'package:lahma/utils/app_routes.dart';
import 'package:lahma/utils/app_translations.dart';
import 'package:lahma/utils/application.dart';
import 'package:lahma/utils/size_config.dart';

class Orders extends StatefulWidget {
//  final String name;
  // final int index;
//  Orders(this.name);
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  AppTranslations _localization;
  static final List<String> langList = application.supportedLanguages;
  static final List<String> langCodesList = application.supportedLanguagesCodes;
  List<LanguageModel> listLangauge = new List();
  PageController _myPage = PageController(initialPage: 0);
  String languageName = "", languageCode = "en";
  int cartTotal=0;
  //String token = "";
  var data;
  bool isLoading = false;
  int length;
  bool isCurrent = true;
  bool isPrevious = false;
  bool isFavorite = false;
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

  getCart()async{
    cartTotal = await SQLiteDbProvider.db.getCount();
    print(cartTotal);
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    getCart();
    // loadProgress();
    ShareMananer.getUserDetails().then((value) {
      languageName = value["language"];
      // token = value["access_token"];
      print(languageName);
      loadLangaugeList(value["language"]);
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    _localization = AppTranslations.of(context);
    return Directionality(
        textDirection:
            languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          appBar:AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text(_localization.localeString("orders")),
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
              _body(),
              isLoading
                  ? showProgress(context)
                  : SizedBox(
                      height: 0.0,
                    ),
            ],
          ),
        ));
  }

  Widget _body() {
    return Column(
      children: [_row(), Expanded(child: _pageView())],
    );
  }

  Widget _pageView() {
    return PageView(
      controller: _myPage,
      onPageChanged: (int) {
        print('Page Changes to index $int');
        if (int == 0) {
          isCurrent = true;
        } else {
          isCurrent = false;
        }

        if (int == 1) {
          isPrevious = true;
        } else {
          isPrevious = false;
        }

        if (int == 2) {
          isFavorite = true;
        } else {
          isFavorite = false;
        }
        setState(() {});
      },
      children: [
        OrderPage("current"),
        OrderPage("previous"),
        OrderPage("favorite")
      ],
    );
  }

  Widget _row() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: _text(isCurrent, "current_req", () {
            setState(() {
              _myPage.jumpToPage(0);
            });
          }),
        ),
        Expanded(
          child: _text(isPrevious, "previous_req", () {
            setState(() {
              _myPage.jumpToPage(1);
            });
          }),
        ),

        Expanded(
          child: _text(isFavorite, "favorite_req", () {
            setState(() {
              _myPage.jumpToPage(2);
            });
          }),
        ),
      ],
    );
  }

  Widget _text(bool isCheck, String name, Function function) {
    return GestureDetector(
      child: Container(
        height: SizeConfig.heightMultiplier*5,
        alignment: Alignment.center,
        color: isCheck?Colors.transparent:AppTheme.primaryColor,
        child: Text(_localization.localeString(name),
            softWrap: true,
            style: isCheck
                ? AppTheme.textStyle.fieldText.copyWith(fontSize: AppFontSize.s18)
                : AppTheme.textStyle.fieldTitle.copyWith(fontSize: AppFontSize.s18).copyWith(color: Colors.white)),
      ),
      onTap: function,
    );
  }

  loadProgress() {
    isLoading = !isLoading;
    setState(() {});
  }
}
