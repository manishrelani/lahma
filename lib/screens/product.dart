import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lahma/api/API.dart';
import 'package:lahma/api/Database.dart';
import 'package:lahma/component/display_alert_widget.dart';
import 'package:lahma/component/product_widget.dart';
import 'package:lahma/model/language_model.dart';
import 'package:lahma/model/local_product.dart';
import 'package:lahma/model/product_model.dart';
import 'package:lahma/screens/shopping_basket.dart';
import 'package:lahma/styles/strings.dart';
import 'package:lahma/theme/theme.dart';
import 'package:lahma/utils/ShareManager.dart';
import 'package:lahma/utils/app_routes.dart';
import 'package:lahma/utils/app_translations.dart';
import 'package:lahma/utils/application.dart';
import 'package:lahma/utils/size_config.dart';

class ProductScreen extends StatefulWidget {
  _ProductScreen createState() => _ProductScreen();
}

class _ProductScreen extends State<ProductScreen> {
  AppTranslations _localization;
  int counter = 0;
  static final List<String> langList = application.supportedLanguages;
  static final List<String> langCodesList = application.supportedLanguagesCodes;
  List<LanguageModel> listLangauge = new List();
  String languageName = "", languageCode = "en";
  String token;
  int length=0;
  int cartTotal=0;
  var data;
  bool isLoading = false;
  List<ProductModel>listProduct=new List();

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

  getProduct()async{
    API.get1(API.product, token).then((value) {
      loadProgress();
      data = json.decode(value.body);
      print("product: $data");
      if (value.statusCode == 200) {

        List list = data;

        for(int i = 0;i<list.length;i++)
          {
            int ID = list[i]["ID"];
            String post_title = list[i]["post_title"];
            String image = list[i]["image"];
            double price = double.parse(list[i]["price"]);
            int qty = 0;

            listProduct.add(new ProductModel(post_title, image, qty, price, ID));



          }


        setState(() {

        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getCart();
    loadProgress();
    ShareMananer.getUserDetails().then((value) {
      languageName = value["language"];
      print(languageName);
      loadLangaugeList(value["language"]);
      token = value["access_token"];
      getProduct();
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
            _background(),
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
    return ListView(
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.28,
          child: Image.asset(
            HOME_BANNER,
            fit: BoxFit.fill,
          ),
        ),
        data == null
            ? Container(
                color: Colors.white,
              )
            : _gridView(),
        SizedBox(
          height: AppSize.small,
        )
      ],
    );
  }

  Widget _gridView() {
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: listProduct.length,
        shrinkWrap: true,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 5,
          // mainAxisSpacing: 8,
        ),
        itemBuilder: (BuildContext context, int index) {
        //  updateCart(index);

          return ProductWidget(
            title: listProduct[index].post_title,
            image: listProduct[index].image,
            price: listProduct[index].price.toString(),
            qty: listProduct[index].qty.toString(),
            id: listProduct[index].ID,

            onAdd: (){
              addProduct(index);
            },
            onLess: (){
            removeProduct(index);
            },
          );
        });
  }

  updateCart(int index)async{


    LocalProductModel lm =  await SQLiteDbProvider.db.getProductById(listProduct[index].ID);

    if(lm!=null)
    {
      listProduct[index].qty=lm.qty;
    }

  }

  addProduct(int index)async{

    int tempQty = listProduct[index].qty;

    tempQty=tempQty+1;
    listProduct[index].qty=tempQty;

    LocalProductModel lm =  await SQLiteDbProvider.db.getProductById(listProduct[index].ID);

    if(lm==null)
    {
      SQLiteDbProvider.db.insert(LocalProductModel(listProduct[index].ID,listProduct[index].post_title,
          tempQty,listProduct[index].price,listProduct[index].image));
      cartTotal++;
    }
    else{

      SQLiteDbProvider.db.update(LocalProductModel(listProduct[index].ID,listProduct[index].post_title,
          tempQty,listProduct[index].price,listProduct[index].image));

    }
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
        SQLiteDbProvider.db.delete(listProduct[index].ID);
        cartTotal--;

      }

    else
      {
        listProduct[index].qty=tempQty;

        LocalProductModel lm =  await SQLiteDbProvider.db.getProductById(listProduct[index].ID);

        if(lm==null)
        {
          SQLiteDbProvider.db.insert(LocalProductModel(listProduct[index].ID,listProduct[index].post_title,
              tempQty,listProduct[index].price,listProduct[index].image));


        }
        else{

          SQLiteDbProvider.db.update(LocalProductModel(listProduct[index].ID,listProduct[index].post_title,
              tempQty,listProduct[index].price,listProduct[index].image));

        }
      }

    setState(() {

    });

   // getCart();


  }

  Widget _appBar() {
    return AppBar(
      centerTitle: true,
      title: Text(_localization.localeString("Product")),
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
    );
  }

  loadProgress() {
    isLoading = !isLoading;
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
