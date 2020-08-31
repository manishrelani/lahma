import 'dart:convert';

import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:lahma/api/API.dart';
import 'package:lahma/component/custom_radio_button.dart';
import 'package:lahma/component/display_alert_widget.dart';
import 'package:lahma/model/language_model.dart';
import 'package:lahma/styles/strings.dart';
import 'package:lahma/theme/theme.dart';
import 'package:lahma/utils/ShareManager.dart';
import 'package:lahma/utils/app_translations.dart';
import 'package:lahma/utils/application.dart';
import 'package:lahma/utils/size_config.dart';

class OrderDetails extends StatefulWidget {
  String id;
  OrderDetails(this.id);
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  AppTranslations _localization;
  static final List<String> langList = application.supportedLanguages;
  static final List<String> langCodesList = application.supportedLanguagesCodes;
  List<LanguageModel> listLangauge = new List();
  var data;
  String token;
  int index;
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
      token = value["access_token"];
      print("id ${widget.id}");
      API.get1(API.oreder + "current", token).then((res) {
        //   loadProgress();
        data = json.decode(res.body);
        print("current $data");
        if (res.statusCode == 200) {
          for (int i = 0; i < data.length; i++) {
            print("Ohk");
            if (data[i]["ID"].toString() == widget.id.toString()) {
              setState(() {
                index = i;
                print("ok $index");
              });
              break;
            } else {
              print(
                  "error ${data[i]["ID"].toString()}  ${widget.id.toString()}");
            }
          }
        } else {
          showDisplayAllert(
              context: context, isSucces: false, message: "error");
        }
      });
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
          appBar: _appBar(),
          body: data == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : _body(),
        ));
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Container(
        width: SizeConfig.widthMultiplier * 100,
        margin: EdgeInsets.symmetric(horizontal: AppSize.small),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: AppSize.small,
            ),
            _topRow(),
            SizedBox(
              height: AppSize.medium,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "${_localization.localeString("order_number")} #" +
                        widget.id,
                    style: AppTheme.textStyle.fieldText),
                SizedBox(
                  height: AppSize.extraSmall,
                ),
                data[index]["address"] == null
                    ? Text("no data", style: AppTheme.textStyle.fieldTitle)
                    : Text(
                        "${data[index]["address"]["address"]},${data[index]["address"]["area"]},${data[index]["address"]["area"]}",
                        style: AppTheme.textStyle.fieldTitle),
              ],
            ),
            SizedBox(
              height: AppSize.medium,
            ),
            _topText(_localization.localeString("delivery_time")),
            CustomRadio(
                "morning", "evening", "anytime", data[index]["delivery_time"],
                onchanged: null),
            SizedBox(
              height: AppSize.small,
            ),
            _topText(_localization.localeString("schedule")),
            CustomRadio("onetime", "every2weeks", "monthly",
                data[index]["schedule_order"],
                onchanged: null),
            SizedBox(
              height: AppSize.small,
            ),
            Text(_localization.localeString("discount_code"),
                style: AppTheme.textStyle.fieldText),
            Container(
              height: 30,
              width: SizeConfig.widthMultiplier * 90,
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                      top: AppSize.extraSmall,
                      right: AppSize.extraSmall,
                      left: AppSize.extraSmall,
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    hintText: _localization.localeString("discount_code"),
                    suffixIcon: Icon(
                      Icons.add,
                      color: AppTheme.primaryColor,
                    )),
              ),
            ),
            SizedBox(
              height: AppSize.small,
            ),
            Container(
              width: SizeConfig.widthMultiplier * 90,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: AppSize.small,
                  ),
                  _row("total_order_without_tax",
                      data[index]["total"].toString()),
                  _row("VAT", "0"),
                  _row("total_order", data[index]["total"].toString()),
                  SizedBox(
                    height: AppSize.small,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _row(String first, String last) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _localization.localeString(first),
          style: AppTheme.textStyle.fieldTitle,
        ),
        Expanded(
          child: Container(),
        ),
        Text(
          "$last ${_localization.localeString("SR")}",
          style: AppTheme.textStyle.fieldText,
        ),
        SizedBox(
          width: SizeConfig.widthMultiplier * 20,
        ),
      ],
    );
  }

  /* Widget _radio(String title, String first, String second, String third,
      Function tap, int value) {
    return Column(
      children: [
        _topText(title),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            IconButton(
              icon: Image.asset(
                  value == 0 ? CHECKBOX_ACTIVE : CHECKBOX_NOT_ACTIVE,
                  height: AppSize.smallMedium),
              onPressed: () {
                setState(() {
                  value = 0;
                });
              },
            ),
            Text(
              first,
              style: AppTheme.textStyle.fieldTitle,
            ),
            Radio(
              value: 1,
              groupValue: value,
              onChanged: tap,
            ),
            Text(
              second,
              style: AppTheme.textStyle.fieldTitle,
            ),
            Radio(
              value: 2,
              groupValue: value,
              onChanged: tap,
            ),
            Text(
              third,
              style: AppTheme.textStyle.fieldTitle,
            ),
          ],
        ),
      ],
    );
  } */

  Widget _topText(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTheme.textStyle.fieldText),
        SizedBox(
          height: AppSize.extraSmall,
        ),
        Divider(
          thickness: 1,
          height: 1,
          color: Colors.black,
        ),
        /* SizedBox(
          height: AppSize.extraSmall,
        ), */
      ],
    );
  }

  Widget _topRow() {
    return Row(
      children: [
        _circleContainer(
            Layer1, Layer1, _localization.localeString("request_create"), true),
        Expanded(
            child: Container(
          margin: EdgeInsets.only(bottom: SizeConfig.heightMultiplier * 5.5),
          height: 1,
          color: Colors.black,
        )),
        _circleContainer(Layer2, Layer2Red,
            _localization.localeString("order_confirm"), false),
        Expanded(
            child: Container(
          margin: EdgeInsets.only(bottom: SizeConfig.heightMultiplier * 5.5),
          height: 1,
          color: Colors.black,
        )),
        _circleContainer(Layer3, Layer3Red,
            _localization.localeString("order_shipped"), false),
        Expanded(
            child: Container(
          margin: EdgeInsets.only(bottom: SizeConfig.heightMultiplier * 5.5),
          height: 1,
          color: Colors.black,
        )),
        _circleContainer(Layer4, Layer4Red,
            _localization.localeString("receipt_request"), false)
      ],
    );
  }

  Widget _circleContainer(
      String image, String image2, String name, bool isCheck) {
    return Container(
      width: SizeConfig.widthMultiplier * 18,
      height: SizeConfig.heightMultiplier * 16,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: SizeConfig.heightMultiplier * 7,
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: SizeConfig.heightMultiplier * 1.2),
                child: Image.asset(
                  isCheck ? image2 : image,
                  height: SizeConfig.heightMultiplier * 5,
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: AppSize.extraSmall),
                  child: Text(name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color:
                              isCheck ? AppTheme.primaryColor : Colors.black)))
            ],
          ),
          Container(
            height: SizeConfig.heightMultiplier * 9.5,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: isCheck ? AppTheme.primaryColor : Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      centerTitle: true,
      title: Text(_localization.localeString("Request")),
    );
  }
}
