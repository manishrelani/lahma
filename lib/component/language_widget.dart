import 'package:flutter/material.dart';
import 'package:lahma/styles/colors.dart';
import 'package:lahma/utils/size_config.dart';

class LangaugeWidget extends StatelessWidget {
  String name;
  bool isSelected;
  GestureTapCallback onTab;
  LangaugeWidget({this.name, this.isSelected,this.onTab});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: (){
        onTab();
      },
      child: Container(
       // width: double.maxFinite,
          child: Column(
            children: <Widget>[
              Container(
                width: double.maxFinite,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                  Expanded(child: Text(name)),
                 isSelected? Flexible(child: Icon(Icons.check,color: COLOR_BLUE,size: AppSize.medium,),):SizedBox(width: 0.0,)
                ],),
              ),
              Divider(height: 20.0,thickness: 1.0,)
            ],
          )


      ),
    );

  }

}