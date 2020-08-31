import 'package:flutter/material.dart';
import 'package:lahma/screens/confirmation.dart';
import 'package:lahma/screens/current_order.dart';
import 'package:lahma/screens/login.dart';
import 'package:lahma/screens/order_details.dart';
import 'package:lahma/screens/order_details_done.dart';
import 'package:lahma/screens/product.dart';
import 'package:lahma/screens/more.dart';
import 'package:lahma/screens/request.dart';
import 'package:lahma/styles/dimensions.dart';
import 'package:lahma/styles/strings.dart';
import 'package:lahma/theme/theme.dart';
import 'package:lahma/utils/ShareManager.dart';
import 'package:lahma/utils/app_translations.dart';
import 'package:lahma/utils/application.dart';
import 'package:lahma/utils/size_config.dart';

import 'offer.dart';

class NavigationScreen extends StatefulWidget {
  int screenGoto;

  NavigationScreen(this.screenGoto);

  @override
  State<StatefulWidget> createState() => _NavigationScreen();
}

class _NavigationScreen extends State<NavigationScreen> {
  AppTranslations _localization;
  PageController _myPage = PageController(initialPage: 0);
  bool isHome = true;
  bool isWallet = false;
  bool isProfile = false;
  bool isExpenses = false;
  static final List<String> langList = application.supportedLanguages;
  static final List<String> langCodesList = application.supportedLanguagesCodes;
  String languageName = "", languageCode = "en";

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
  Widget build(BuildContext context) {
    _localization = AppTranslations.of(context);
    return Directionality(
      textDirection:
          languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: AppTheme.primaryColor,
          child: Container(
            height: 70,
            child: Row(
              // mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  color: isHome ? Colors.white30 : Colors.transparent,
                  padding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 2,
                      right: SizeConfig.widthMultiplier * 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        color: Colors.blue,
                        iconSize: 35,
                        icon: new Image.asset(ICON_NAV_ICON_1,
                            color: Colors.white),
                        onPressed: () {
                          print(_myPage.position);
                          setState(() {
                            _myPage.jumpToPage(0);
                          });
                        },
                      ),
                      Text(
                        _localization.localeString("Product"),
                        style: TextStyle(
                            fontSize: DIMENSION_10,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            color: Colors.white // change this
                            ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: isExpenses ? Colors.white30 : Colors.transparent,
                  padding: EdgeInsets.only(left: SizeConfig.widthMultiplier * 2
                      , right: SizeConfig.widthMultiplier * 2,),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        iconSize: 35.0,
                        icon: new Image.asset(ICON_NAV_ICON_2,
                            color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _myPage.jumpToPage(1);
                          });
                        },
                      ),
                      Text(
                        _localization.localeString("Offers"),
                        style: TextStyle(
                            fontSize: DIMENSION_10,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            color: Colors.white // change this
                            ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: isWallet ? Colors.white30 : Colors.transparent,
                  padding: EdgeInsets.only(left: SizeConfig.widthMultiplier * 2,
                      right: SizeConfig.widthMultiplier * 2,),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        iconSize: 35.0,
                        icon: new Image.asset(ICON_NAV_ICON_3,
                            color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _myPage.jumpToPage(2);
                          });
                        },
                      ),
                      Text(
                        _localization.localeString("orders"),
                        style: TextStyle(
                            fontSize: DIMENSION_10,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            color: Colors.white // change this
                            ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: isProfile ? Colors.white30 : Colors.transparent,
                  padding: EdgeInsets.only(left: SizeConfig.widthMultiplier * 2,
                      right: SizeConfig.widthMultiplier * 2,),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        iconSize: 35.0,
                        icon: new Image.asset(ICON_NAV_ICON_4,
                            color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _myPage.jumpToPage(3);
                          });
                        },
                      ),
                      Text(
                        _localization.localeString("More"),
                        style: TextStyle(
                            fontSize: DIMENSION_10,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            color: Colors.white // change this
                            ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: PageView(
          controller: _myPage,
          onPageChanged: (int) {
            print('Page Changes to index $int');

            if (int == 0) {
              isHome = true;
            } else {
              isHome = false;
            }

            if (int == 1) {
              isExpenses = true;
            } else {
              isExpenses = false;
            }

            if (int == 2) {
              isWallet = true;
            } else {
              isWallet = false;
            }

            if (int == 3) {
              isProfile = true;
            } else {
              isProfile = false;
            }
            setState(() {});
          },
          children: <Widget>[
            ProductScreen(),
            OfferScreen(),
            Orders(),
            MoreScreen(),
          ],
          //  physics: NeverScrollableScrollPhysics(), // Comment this if you need to use Swipe.
        ),
      ),
    );
  }
}
