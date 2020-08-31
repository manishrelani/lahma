import 'dart:convert';

import "package:flutter/material.dart";

import 'package:lahma/api/API.dart';

import 'package:lahma/model/language_model.dart';
import 'package:lahma/model/order_model.dart';

import 'package:lahma/screens/order_details.dart';
import 'package:lahma/screens/order_details_done.dart';
import 'package:lahma/theme/theme.dart';
import 'package:lahma/utils/ShareManager.dart';
import 'package:lahma/utils/app_routes.dart';
import 'package:lahma/utils/app_translations.dart';
import 'package:lahma/utils/application.dart';
import 'package:lahma/utils/size_config.dart';

class OrderPage extends StatefulWidget {
  final String name;
  OrderPage(this.name);
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  AppTranslations _localization;
  static final List<String> langList = application.supportedLanguages;
  static final List<String> langCodesList = application.supportedLanguagesCodes;
  List<LanguageModel> listLangauge = new List();
  String languageName = "", languageCode = "en";
  String token = "";
  // var data;
  List<OrderModel> listOrder = new List();
  bool isLoading = false;
  int length;

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
    loadProgress();
    ShareMananer.getUserDetails().then((value) {
      languageName = value["language"];
      token = value["access_token"];
      print(languageName);
      loadLangaugeList(value["language"]);
      getOrder();
    });

    setState(() {});
  }

  getOrder() {
    API.get1(API.oreder + widget.name, token).then((res) {
      loadProgress();
      final data = json.decode(res.body);
      print("current $data");
      if (res.statusCode == 200) {
        List list = data;

        if (listOrder.isNotEmpty) {
          listOrder.clear();
        }

        for (int i = 0; i < list.length; i++) {
          String ID = list[i]["ID"].toString();
          String post_author = list[i]["post_author"].toString();
          String post_date = list[i]["post_date"].toString();
          String post_date_gmt = list[i]["post_date_gmt"].toString();
          String post_content = list[i]["post_content"].toString();
          String post_title = list[i]["post_title"].toString();
          String post_excerpt = list[i]["post_excerpt"].toString();
          String post_status = list[i]["post_status"].toString();
          String comment_status = list[i]["comment_status"].toString();
          String ping_status = list[i]["ping_status"].toString();
          String post_name = list[i]["post_name"].toString();
          String to_ping = list[i]["to_ping"].toString();
          String pinged = list[i]["pinged"].toString();
          String post_modified = list[i]["post_modified"].toString();
          String post_modified_gmt = list[i]["post_modified_gmt"].toString();
          String post_content_filtered =
              list[i]["post_content_filtered"].toString();
          String post_parent = list[i]["post_parent"].toString();
          String guid = list[i]["guid"].toString();
          String menu_order = list[i]["menu_order"].toString();
          String post_type = list[i]["post_type"].toString();
          String post_mime_type = list[i]["post_mime_type"].toString();
          String comment_count = list[i]["comment_count"].toString();
          String filter = list[i]["filter"].toString();
          String total = list[i]["total"].toString();
          String status = list[i]["status"].toString();
          String status_code = list[i]["status_code"].toString();
          String status_text = list[i]["status_text"].toString();
          String schedule_order = list[i]["schedule_order"].toString();
          String delivery_time = list[i]["delivery_time"].toString();
          String address_id = list[i]["address"]["id"].toString();
          String lat = list[i]["address"]["lat"].toString();
          String long = list[i]["address"]["long"].toString();
          String city = list[i]["address"]["city"].toString();
          String area = list[i]["address"]["area"].toString();
          String address = list[i]["address"]["address"].toString();
          String is_favorite = list[i]["is_favorite"].toString();
          List<dynamic> products_ids = list[i]["products_ids"];

          listOrder.add(new OrderModel(
              ID,
              post_author,
              post_date,
              post_date_gmt,
              post_content,
              post_title,
              post_excerpt,
              post_status,
              comment_status,
              ping_status,
              post_name,
              to_ping,
              pinged,
              post_modified,
              post_modified_gmt,
              post_content_filtered,
              post_parent,
              guid,
              menu_order,
              post_type,
              post_mime_type,
              comment_count,
              filter,
              total,
              status,
              status_code,
              status_text,
              schedule_order,
              delivery_time,
              address_id,
              lat,
              long,
              city,
              area,
              address,
              is_favorite,
              products_ids));
        }

        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _localization = AppTranslations.of(context);
    return Directionality(
      textDirection:
          languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Stack(
        children: <Widget>[
          listOrder.length == 0
              ? Container(
                  color: Colors.white,
                )
              : _body(),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox(
                  height: 0.0,
                ),
        ],
      ),
    );
  }

  Widget _body() {
    return _listView();
  }

  Widget _listView() {
    return ListView.builder(
      itemCount: listOrder.length,
      itemBuilder: (context, index) {
        return _topContainer(index);
      },
    );
  }

  Widget _topContainer(int index) {
    return GestureDetector(
      onTap: () {
        if (listOrder[index].status_code == "4") {
          AppRoutes.goto(context, OrderDetailsDone("${listOrder[index].ID}",listOrder[index].products_ids));
        } else {
          AppRoutes.goto(context, OrderDetails("${listOrder[index].ID}"));
        }

        setState(() {});
      },
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
        height: SizeConfig.heightMultiplier * 20,
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black),
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: AppSize.small,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${listOrder[index].total} ${_localization.localeString("SR")}",
                  style: AppTheme.textStyle.fieldText,
                ),
                MaterialButton(
                    height: 25,
                    minWidth: SizeConfig.widthMultiplier * 10,
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.black)),
                    child: Text(
                      _localization.localeString("created"),
                      style: AppTheme.textStyle.fieldTitle,
                    ),
                    onPressed: () {})
              ],
            ),

            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.widthMultiplier * 2.5),
              color: Colors.black,
              height: SizeConfig.heightMultiplier * 14,
              width: 1,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  listOrder[index].post_date,
                  style: AppTheme.textStyle.fieldText,
                ),
                Text(
                    "${_localization.localeString("order_number")}#: ${listOrder[index].ID}",
                    style: AppTheme.textStyle.fieldTitle),
              ],
            ),
            //  Expanded(child: Container()),
            Container(
              //margin: EdgeInsets.only(right: 5),
              alignment: Alignment.bottomRight,
              child: widget.name == "favorite"
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        loadProgress();
                        API
                            .delete1(
                                "https://lahma-sa.com/site/wp-json/lahma/v1/order/${listOrder[index].ID}/favorite",
                                token)
                            .then((value) {
                          loadProgress();
                          if (value.statusCode == 200) {
                            listOrder.removeAt(index);
                            setState(() {});
                          }
                          /* AppRoutes.replace(context, Orders());  */
                        });
                      })
                  : IconButton(
                      icon: listOrder[index].is_favorite == "true"
                          ? Icon(
                              Icons.favorite,
                              color: AppTheme.primaryColor,
                            )
                          : Icon(Icons.favorite_border),
                      onPressed: () {
                        loadProgress();

                        API
                            .post2(
                                "https://lahma-sa.com/site/wp-json/lahma/v1/order/${listOrder[index].ID}/favorite",
                                token)
                            .then((value) {
                          loadProgress();
                          if (value.statusCode == 200) {
                            listOrder[index].is_favorite = "true";
                            print(listOrder[index].is_favorite);
                            setState(() {});
                          }
                          //   AppRoutes.replace(context, Orders());
                        });
                      }),
            )
          ],
        ),
      ),
    );
  }

  loadProgress() {
    isLoading = !isLoading;
    setState(() {});
  }
}
