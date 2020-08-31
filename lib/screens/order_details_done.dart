import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lahma/api/API.dart';
import 'package:lahma/api/Database.dart';
import 'package:lahma/component/custom_app_bar.dart';
import 'package:lahma/component/display_alert_widget.dart';
import 'package:lahma/model/language_model.dart';
import 'package:lahma/model/local_product.dart';
import 'package:lahma/model/product_model.dart';
import 'package:lahma/screens/bottom_navigation.dart';
import 'package:lahma/screens/shopping_basket.dart';
import 'package:lahma/styles/strings.dart';
import 'package:lahma/theme/theme.dart';
import 'package:lahma/utils/ShareManager.dart';
import 'package:lahma/utils/app_routes.dart';
import 'package:lahma/utils/app_translations.dart';
import 'package:lahma/utils/application.dart';
import 'package:lahma/utils/size_config.dart';

class OrderDetailsDone extends StatefulWidget {
  final String id;
  final List products_ids;
  OrderDetailsDone(this.id, this.products_ids);
  @override
  _OrderDetailsDoneState createState() => _OrderDetailsDoneState();
}

class _OrderDetailsDoneState extends State<OrderDetailsDone> {
  AppTranslations _localization;
  static final List<String> langList = application.supportedLanguages;
  static final List<String> langCodesList = application.supportedLanguagesCodes;
  List<LanguageModel> listLangauge = new List();
  List<ProductModel> listProduct = new List();
  String languageName = "", languageCode = "en";
  double product = 1;
  double delegate = 1;
  double delivery = 1;
  int cartTotal = 1;
  String token;
  bool isLoading = false;
  // List<String> products_ids = List();

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
      print(languageName);
      print("product id:${widget.products_ids}");
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
        appBar: _appBar(),
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
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
        child: Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                  "${_localization.localeString("order_number")} #${widget.id}",
                  style: AppTheme.textStyle.fieldTitle),
              GestureDetector(
                child: Text("${_localization.localeString("re_order")}",
                    style: AppTheme.textStyle.fieldTitle),
                onTap: reoder,
              ),
            ],
          ),
          SizedBox(
            height: AppSize.small,
          ),
          _logos(),
          SizedBox(
            height: AppSize.small,
          ),
          Text(
            _localization.localeString("evaluate_your_request"),
            style: AppTheme.textStyle.fieldTitle,
          ),
          SizedBox(
            height: AppSize.small,
          ),
          Container(alignment: Alignment.center, child: _ratingBox()),
        ],
      ),
    ));
  }

  Widget _ratingBox() {
    return Column(
      children: [
        _ratingContainer("product_quality", (rating) {
          product = rating;
          print(product);
        }),
        SizedBox(
          height: AppSize.extraSmall,
        ),
        _ratingContainer("delegate_evaluation", (rating) {
          delegate = rating;
          print(delegate);
        }),
        SizedBox(
          height: AppSize.extraSmall,
        ),
        _ratingContainer("delivery_time", (rating) {
          delivery = rating;
          print(delivery);
        }),
        SizedBox(
          height: AppSize.small,
        ),
        MaterialButton(
            height: SizeConfig.heightMultiplier * 3.5,
            minWidth: SizeConfig.widthMultiplier * 35,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            color: AppTheme.primaryColor,
            child: Text(_localization.localeString("send"),
                style: TextStyle(color: Colors.white)),
            onPressed: () {
              rating();
            })
      ],
    );
  }

  Widget _logos() {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          child: Image.asset(
            ICON_LOGO,
            height: SizeConfig.heightMultiplier * 7,
          ),
        ),
        SizedBox(
          height: AppSize.medium,
        ),
        Stack(
          children: <Widget>[
            Container(
              height: SizeConfig.heightMultiplier * 11,
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: SizeConfig.heightMultiplier * 1.2),
              child: Image.asset(
                Layer4Red,
                height: SizeConfig.heightMultiplier * 8,
              ),
            ),
            Container(
              height: SizeConfig.heightMultiplier * 13,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.primaryColor),
              ),
            ),
          ],
        ),
        SizedBox(
          height: AppSize.small,
        ),
        Container(
            width: SizeConfig.widthMultiplier * 25,
            child: Text(
              _localization.localeString("order_delivered"),
              style: AppTheme.textStyle.fieldTitle,
              textAlign: TextAlign.center,
            ))
      ],
    );
  }

  Widget _ratingContainer(String name, Function rating) {
    return Container(
      height: SizeConfig.heightMultiplier * 3,
      width: SizeConfig.widthMultiplier * 65,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: AppTheme.primaryColor),
      //color: AppTheme.primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _localization.localeString(name),
            style: TextStyle(color: Colors.white),
          ),
          _ratingBar(rating)
        ],
      ),
    );
  }

  Widget _ratingBar(Function rating) {
    return RatingBar(
        itemSize: SizeConfig.heightMultiplier * 2.5,
        initialRating: 1,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: false,
        itemCount: 5,
        itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
        itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.yellow,
            ),
        //   tapOnlyMode: false,
        unratedColor: Colors.white,
        onRatingUpdate: rating);
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
            _localization.localeString("order_confirm"), true),
        Expanded(
            child: Container(
          margin: EdgeInsets.only(bottom: SizeConfig.heightMultiplier * 5.5),
          height: 1,
          color: Colors.black,
        )),
        _circleContainer(Layer3, Layer3Red,
            _localization.localeString("order_shipped"), true),
        Expanded(
            child: Container(
          margin: EdgeInsets.only(bottom: SizeConfig.heightMultiplier * 5.5),
          height: 1,
          color: Colors.black,
        )),
        _circleContainer(Layer4, Layer4Red,
            _localization.localeString("receipt_request"), true)
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
      title: Text(_localization.localeString("order_details")),
    );
  }

  reoder() {
    loadProgress();
    API.get1(API.product, token).then((value) {
      loadProgress();
      final data = json.decode(value.body);
      print(data);
      if (value.statusCode == 200) {
        List list = data;

        for (int i = 0; i < list.length; i++) {
          int ID = list[i]["ID"];
          String post_title = list[i]["post_title"];
          String image = list[i]["image"];
          double price = double.parse(list[i]["price"]);
          int qty = 0;

          listProduct.add(new ProductModel(post_title, image, qty, price, ID));
        }

        setState(() {});
        for (int i = 0; i < listProduct.length; i++) {
          // print("list product $i" +listProduct[i].ID.toString());
          for (int j = 0; j < widget.products_ids.length; j++) {
            print(
                "${widget.products_ids[j].toString()} ${listProduct[i].ID.toString()}");
            if (widget.products_ids[j].toString() ==
                listProduct[i].ID.toString()) {
              print("ok");
              addProduct(i);
            }
          }
          AppRoutes.goto(context, ShoppingBasket());
        }
      }
    });
  }

  addProduct(int index) async {
    int tempQty = 1;

    LocalProductModel lm =
        await SQLiteDbProvider.db.getProductById(listProduct[index].ID);

    if (lm == null) {
      SQLiteDbProvider.db.insert(LocalProductModel(
          listProduct[index].ID,
          listProduct[index].post_title,
          tempQty,
          listProduct[index].price,
          listProduct[index].image));
      cartTotal++;
    } else {
      SQLiteDbProvider.db.update(LocalProductModel(
          listProduct[index].ID,
          listProduct[index].post_title,
          tempQty,
          listProduct[index].price,
          listProduct[index].image));
    }
    setState(() {});

    // getCart();
  }

  getCart() async {
    cartTotal = await SQLiteDbProvider.db.getCount();
    print(cartTotal);
    setState(() {});
  }

  rating() {
    loadProgress();
    print("id ${widget.id}");
    print("p ${product.toString()}");
    print("d ${delegate.toString()}");
    print("de ${delivery.toString()}");
    String api =
        "https://lahma-sa.com/site//wp-json/lahma/v1/order/${widget.id}/rate";
    Map<String, String> args = Map<String, String>();
    args["product"] = product.toString();
    args["delegate"] = delegate.toString();
    args["delivery"] = delivery.toString();

    API.post1(api, args, token).then((value) {
      loadProgress();
      final data = json.decode(value.body);
      print(data);
      if (value.statusCode == 200) {
        if (data["success"] == true) {
          showDisplayAllert(
              context: context,
              isSucces: true,
              message: _localization.localeString("reviewMsg"));
          Future.delayed(Duration(seconds: 2), () {
            AppRoutes.makeFirst(context, NavigationScreen(0));
          });
        } else {
          showDisplayAllert(
              context: context, isSucces: false, message: data["message"]);
        }
      }
    });
  }

  loadProgress() {
    isLoading = !isLoading;
    setState(() {});
  }
}
