import 'dart:convert';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lahma/api/API.dart';
import 'package:lahma/api/Database.dart';
import 'package:lahma/component/cart_widget.dart';
import 'package:lahma/component/custom_app_bar.dart';
import 'package:lahma/component/custom_radio_button.dart';
import 'package:lahma/component/display_alert_widget.dart';
import 'package:lahma/model/language_model.dart';
import 'package:lahma/model/local_product.dart';
import 'package:lahma/screens/address.dart';
import 'package:lahma/screens/bottom_navigation.dart';
import 'package:lahma/screens/confirmation.dart';
import 'package:lahma/screens/current_order.dart';
import 'package:lahma/styles/strings.dart';
import 'package:lahma/theme/theme.dart';
import 'package:lahma/utils/ShareManager.dart';
import 'package:lahma/utils/app_routes.dart';
import 'package:lahma/utils/app_translations.dart';
import 'package:lahma/utils/application.dart';
import 'package:lahma/utils/size_config.dart';

import 'address_modify.dart';
import 'order_details.dart';

class ShoppingBasket extends StatefulWidget {


  @override
  _ShoppingBasketState createState() => _ShoppingBasketState();
}

class _ShoppingBasketState extends State<ShoppingBasket> {
  AppTranslations _localization;
  static final List<String> langList = application.supportedLanguages;
  static final List<String> langCodesList = application.supportedLanguagesCodes;
  TextEditingController couponController = TextEditingController();
  List<LanguageModel> listLangauge = new List();
  bool isLoading = false;
  String languageName = "", languageCode = "en";
  // int counter = 0;
  bool isActive = true;
  String deliveryTime = "";
  String schedule = "", address = "", address_id = "";
  String token;
  double totalAmount=0.0,tax=0.0;
  List<LocalProductModel>listProduct=new List();

  getTotalPrice() {

    double tot =0.0;
    for(int i=0;i<listProduct.length;i++)
      {

        double price = listProduct[i].price;
        int qty=listProduct[i].qty;

        double subtottal = price*qty;
        tot=tot+subtottal;

       }

    totalAmount=tot;
    setState(() {

    });
    gettax(totalAmount);
  }

  gettax(double total) {

    double subTax= (total*1.19)/100;

    tax=subTax;
    setState(() {

    });
  }


  getCartData()async{

  listProduct=await  SQLiteDbProvider.db.getAllProducts();

  getTotalPrice();
   print(listProduct.length);
  }

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

  bool myInterceptor(bool stopDefaultButtonEvent) {
    AppRoutes.makeFirst(
        context, NavigationScreen(0));

    return true;
  }

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
    getCartData();
    try {
      getAddress();
    } catch (e) {
      print("error $e");
    }
    ShareMananer.getUserDetails().then((value) {
      languageName = value["language"];
      token = value["access_token"];
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
          appBar: CustomAppBar(
            title: _localization.localeString("orders"),
            callback: () {

            },
            icon: ICON_CART,
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
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


          Flexible(child:Container(
           // height: 200,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: listProduct.length,
              shrinkWrap: true,
              itemBuilder: (context,int index){
                return CartWidget(
                  qty: listProduct[index].qty.toString(),
                  price: listProduct[index].price.toString(),
                  title: listProduct[index].name,
                  image: listProduct[index].image,
                  onAdd: (){
                addProduct(index);
                  },

                  onLess: (){
                    removeProduct(index);
                  },

                  onDelete: (){
                    SQLiteDbProvider.db.delete(listProduct[index].id);
                    listProduct.removeAt(index);
                    getTotalPrice();
                    setState(() {

                    });
                  },
                );
              },
            ),
          ) ,),

            SizedBox(
              height: AppSize.small,
            ),
            _button("add_a_product", () {
            AppRoutes.makeFirst(context, NavigationScreen(0));
            }),
            SizedBox(
              height: AppSize.medium,
            ),
            _text(
              _localization.localeString("payment_method"),
              _localization.localeString("modification"),
              _localization.localeString("cash_money"),
            ),
            SizedBox(
              height: AppSize.medium,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(_localization.localeString("delivery_address"),
                        style: AppTheme.textStyle.fieldText),
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: GestureDetector(
                          onTap: () {
                            AppRoutes.replace(
                                context,
                                AddressModifyScreen());
                          },
                          child: Text(
                              _localization.localeString("modification"),
                              style: AppTheme.textStyle.fieldText)),
                    ),
                  ],
                ),
                SizedBox(
                  height: AppSize.extraSmall,
                ),
                Divider(
                  thickness: 1,
                  height: 1,
                  color: Colors.black,
                ),
                SizedBox(
                  height: AppSize.extraSmall,
                ),
                Text(address, style: AppTheme.textStyle.fieldTitle),
              ],
            ),
            SizedBox(
              height: AppSize.medium,
            ),
            _topText(_localization.localeString("delivery_time"), ""),
            CustomRadio(
              "morning",
              "evening",
              "anytime",
              "",
              onchanged: (value) {
                deliveryTime = value;
                print(deliveryTime);
              },
            ),
            SizedBox(
              height: AppSize.small,
            ),
            _topText(_localization.localeString("schedule"), ""),
            CustomRadio(
              "onetime",
              "every2weeks",
              "monthly",
              "",
              onchanged: (value) {
                schedule = value;
                print(schedule);
              },
            ),
            SizedBox(
              height: AppSize.small,
            ),
            Text(_localization.localeString("discount_code"),
                style: AppTheme.textStyle.fieldText),
            Container(
              height: 30,
              width: SizeConfig.widthMultiplier * 90,
              child: TextField(
                controller: couponController,
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
                  _row("total_order_without_tax", "${totalAmount.toStringAsFixed(2)}"),
                  _row("VAT", "${tax.toStringAsFixed(2)}"),
                  _row(
                      "total_order", "${(totalAmount+tax).toStringAsFixed(2)}"),
                ],
              ),
            ),
            SizedBox(
              height: AppSize.mediumLarge,
            ),
            _button("executing_the_request", () {
              if (listProduct.isNotEmpty && deliveryTime.isNotEmpty && schedule.isNotEmpty)
                checkout();
            }),
          ],
        ),
      ),
    );
  }


  addProduct(int index)async{

    int tempQty = listProduct[index].qty;

    tempQty=tempQty+1;
    listProduct[index].qty=tempQty;

    LocalProductModel lm =  await SQLiteDbProvider.db.getProductById(listProduct[index].id);

    if(lm==null)
    {
      SQLiteDbProvider.db.insert(LocalProductModel(listProduct[index].id,listProduct[index].name,
          tempQty,listProduct[index].price,listProduct[index].image));
    }
    else{

      SQLiteDbProvider.db.update(LocalProductModel(listProduct[index].id,listProduct[index].name,
          tempQty,listProduct[index].price,listProduct[index].image));

    }
    getTotalPrice();
    setState(() {

    });

    // getCart();


  }

  removeProduct(int index)async{

    int tempQty = listProduct[index].qty;

    tempQty=tempQty-1;

    if(tempQty<=0)
    {

      tempQty=0;
      listProduct[index].qty=tempQty;
      SQLiteDbProvider.db.delete(listProduct[index].id);

    }

    else
    {
      listProduct[index].qty=tempQty;

      LocalProductModel lm =  await SQLiteDbProvider.db.getProductById(listProduct[index].id);

      if(lm==null)
      {
        SQLiteDbProvider.db.insert(LocalProductModel(listProduct[index].id,listProduct[index].name,
            tempQty,listProduct[index].price,listProduct[index].image));


      }
      else{

        SQLiteDbProvider.db.update(LocalProductModel(listProduct[index].id,listProduct[index].name,
            tempQty,listProduct[index].price,listProduct[index].image));

      }
    }

    getTotalPrice();
    setState(() {

    });

    // getCart();


  }

  getAddress() async {
    await ShareMananer.getDefaultAddress().then((onValue) {
      if (onValue["address"] == null) {
       // AppRoutes.replace(context, AddressModifyScreen());
      } else {
        address =
            onValue["address"] + "," + onValue["area"] + "," + onValue["city"];

        address_id = onValue["id"];
        setState(() {});
      }
    });
  }

  Widget _row(String title, String amount) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _localization.localeString(title),
          style: AppTheme.textStyle.fieldTitle,
        ),
        Expanded(
          child: Container(),
        ),
        Text(
          "$amount ${_localization.localeString("SR")}",
          style: AppTheme.textStyle.fieldText,
        ),
        SizedBox(
          width: SizeConfig.widthMultiplier * 20,
        ),
      ],
    );
  }

  Widget _topText(String title, String traling) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title, style: AppTheme.textStyle.fieldText),
            Container(
              margin: EdgeInsets.only(left: 15),
              child: Text(traling, style: AppTheme.textStyle.fieldText),
            ),
          ],
        ),
        SizedBox(
          height: AppSize.extraSmall,
        ),
        Divider(
          thickness: 1,
          height: 1,
          color: Colors.black,
        ),
        SizedBox(
          height: AppSize.extraSmall,
        ),
      ],
    );
  }

  Widget _text(String title, String traling, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _topText(title, traling),
        Text(subtitle, style: AppTheme.textStyle.fieldTitle),
      ],
    );
  }

  Widget _button(String name, Function function) {
    return Container(
      alignment: Alignment.center,
      child: MaterialButton(
          minWidth: SizeConfig.widthMultiplier * 50,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          color: AppTheme.primaryColor,
          child: Text(_localization.localeString(name),
              style: AppTheme.textStyle.lightText),
          onPressed: function),
    );
  }




  loadProgress() {
    isLoading = !isLoading;
    setState(() {});
  }

  checkout() {
    loadProgress();

    Map<String, String> args = Map<String, String>();

    for(int i =0 ;i<listProduct.length;i++)
      {
        args["products[${i}][product_id]"] =listProduct[i].id.toString();
        args["products[${i}][qty]"] = listProduct[i].qty.toString();
      }


    args["payment_method"] = "cod";
    args["delivery_time"] = deliveryTime;
    args["schedule_order"] = schedule;
    args["address_id"] = address_id;
    args["coupon"] = couponController.text;
    API.post1(API.checkout, args, token).then((value) {
      loadProgress();
      final data = json.decode(value.body);
      print("checkout $data");
      if (value.statusCode == 200) {
        if (data["message"] == "success") {
          SQLiteDbProvider.db.deleteAll();
          AppRoutes.replace(
              context, Confirmation(data["order"]["ID"].toString()));
        } else {
          showDisplayAllert(
              context: context, isSucces: false, message: data["message"]);
        }
      } else {
        showDisplayAllert(
            context: context,
            isSucces: false,
            message: data["data"]["message"]);
      }
    });
  }
}
