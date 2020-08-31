import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lahma/styles/strings.dart';
import 'package:lahma/theme/theme.dart';
import 'package:lahma/utils/app_translations.dart';
import 'package:lahma/utils/size_config.dart';

class CartWidget extends StatelessWidget {
  AppTranslations _localization;
  String image,title,price,qty;
  GestureTapCallback onAdd,onLess,onDelete;


  CartWidget({this.image, this.title, this.price, this.qty, this.onAdd,
      this.onLess, this.onDelete});

  @override
  Widget build(BuildContext context) {
    _localization = AppTranslations.of(context);
    // TODO: implement build
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          height: SizeConfig.heightMultiplier * 22,
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: AppSize.small),
                child: image == null
                    ? Container(
                    width: SizeConfig.widthMultiplier * 25,
                    child: Text("No imgae"))
                    : CachedNetworkImage(
                  imageUrl: image,
                  width: SizeConfig.widthMultiplier * 25,
                  progressIndicatorBuilder:
                      (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Icon(
                    Icons.error,
                    size: SizeConfig.widthMultiplier * 25,
                  ),
                ),
              ),
              Container(

                color: Colors.black,
                height: SizeConfig.heightMultiplier * 14,
                width: 1,
              ),
              Container(
                margin: EdgeInsets.only(left: SizeConfig.widthMultiplier*1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: SizeConfig.widthMultiplier * 45,
                      child: Text(
                        title,
                        style: AppTheme.textStyle.fieldTitle,
                        softWrap: true,
                      ),
                    ),
                    Text(
                        "(${qty} ${_localization.localeString("cartons")})",
                        style: AppTheme.textStyle.fieldTitle),
                    SizedBox(
                      height: AppSize.extraSmall,
                    ),
                    Text("${price} ${_localization.localeString("SR")}",
                        style: AppTheme.textStyle.fieldText)
                  ],
                ),
              ),
              Container(
                //margin: EdgeInsets.only(right: 5),
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                      icon: Image.asset(
                        DELETE_ICON,
                        height: AppSize.medium,
                      ),
                      onPressed: () {
                      onDelete();
                      }))
            ],
          ),
        ),
        _counter(),
      ],
    );
  }


  Widget _counter() {
    return Positioned(
      bottom: 0,
      left: SizeConfig.widthMultiplier * 35,
      right: SizeConfig.widthMultiplier * 35,
      child: Container(
        height: 40,
        width: SizeConfig.widthMultiplier * 23,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppTheme.primaryColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              child: Container(
                alignment: Alignment.center,
                height: double.infinity,
                child: Text(
                  "+",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              onTap: () {
              onAdd();
              },
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              alignment: Alignment.center,
              color: Colors.white,
              child: Text(
                qty,
                style: TextStyle(fontSize: 20),
              ),
            ),
            GestureDetector(
              child: Container(
                alignment: Alignment.center,
                height: double.infinity,
                child: Text(
                  "-",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
              onTap: () {
               onLess();
              },
            ),
          ],
        ),
      ),
    );
  }

}