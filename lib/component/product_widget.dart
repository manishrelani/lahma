import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lahma/api/Database.dart';
import 'package:lahma/model/local_product.dart';
import 'package:lahma/screens/shopping_basket.dart';
import 'package:lahma/theme/theme.dart';
import 'package:lahma/utils/app_routes.dart';
import 'package:lahma/utils/size_config.dart';

class ProductWidget extends StatefulWidget {

  String  title,image,price,qty;
  int id;
  GestureTapCallback onAdd,onLess;


  ProductWidget({this.title, this.image, this.price, this.qty, this.onAdd,
      this.onLess,this.id});

  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {






  Widget _product(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              borderRadius: BorderRadius.circular(8)),
          child: Container(
            margin: EdgeInsets.only(right: 10, left: 10, top: 20),
            child: GestureDetector(
              child: Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  widget.image == null
                      ? Container(
                          height: SizeConfig.heightMultiplier * 11,
                          width: double.maxFinite,
                          child: Text("No imgae"))
                      : CachedNetworkImage(
                          imageUrl: widget.image ,
                          height: SizeConfig.heightMultiplier * 11,
                          width: double.maxFinite,
                          fit: BoxFit.fill ,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) => Icon(
                            Icons.error,
                            size: SizeConfig.heightMultiplier * 11,
                          ),
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: Colors.black,
                    height: 1,
                    indent: 5,
                    endIndent: 5,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.title,
                    style: AppTheme.textStyle.fieldTitle,
                  )
                ],
              ),
              onTap: () {
               AppRoutes.goto(context, ShoppingBasket());
              },
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppTheme.primaryColor),
              margin: EdgeInsets.only(top: 20, right: 10, left: 10),
              width: 60,
              height: 20,
              child: Text(
                 widget.price+" SR",
                style: TextStyle(
                  color: Colors.white,
                ),
              )),
        ),
        _counter(context)
      ],
    );
  }

  Widget _counter(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: SizeConfig.widthMultiplier * 12,
      right: SizeConfig.widthMultiplier * 12,
      child: Container(
        height: 40,
        width: SizeConfig.widthMultiplier * 23, 
        //margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.11),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppTheme.primaryColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
          children: [
            GestureDetector(
              child: Container(             
                  alignment: Alignment.center,
                  height: 40, 
                  width: MediaQuery.of(context).size.width * 0.05,  
                  child: Text(
                    "+",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              onTap: () {
                widget.onAdd();


              },
            ),
            Container(
              height: 39,
              width: MediaQuery.of(context).size.width * 0.12,
              alignment: Alignment.center,
              color: Colors.white,
              child: Text(
                widget.qty,
                style: TextStyle(fontSize: 20),
              ),
            ),
            GestureDetector(
              child: Container(
                alignment: Alignment.center,
                height: 40,
                width: MediaQuery.of(context).size.width * 0.05,
               // width: double.maxFinite,
                child: Text(
                  "-",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
              onTap: () {
                widget.onLess();
              },
            ),
          ],
        ),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return _product(context);
  }

  @override
  void initState() {

    getQty();



  }


  getQty()async{

    LocalProductModel lm =  await SQLiteDbProvider.db.getProductById(widget.id);

    if(lm!=null)
    {
      widget.qty=lm.qty.toString();
    }
    setState(() {

    });
  }
}


