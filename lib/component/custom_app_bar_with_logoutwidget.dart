import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lahma/theme/theme.dart';
import 'package:lahma/utils/ShareManager.dart';
import 'package:lahma/utils/app_constants.dart';
import 'package:lahma/utils/app_routes.dart';
import 'package:lahma/utils/size_config.dart';

class CustomAppBarWithLogoutWidget extends StatelessWidget {
   String title,secondTitle;
   GestureTapCallback onTabSecondTitle;

  CustomAppBarWithLogoutWidget({Key key, this.title,this.secondTitle,this.onTabSecondTitle}) ;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor
      ),
      child: Container(
        padding: EdgeInsets.only(top: AppSize.medium),
        height: AppSize.s70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: AppSize.small,),
        Flexible(
          child: GestureDetector(
              onTap: (){
                onTabSecondTitle();
              },
              child: Text(secondTitle, style: AppTheme.textStyle.screenTitle.copyWith(fontWeight: FontWeight.w600, fontSize: AppFontSize.s20,color: Colors.white),)),
        ),
            Expanded(
            //  alignment: Alignment.center,
              child: Text(title.replaceAll('\n', ' '),textAlign: TextAlign.center, style: AppTheme.textStyle.screenTitle.copyWith(fontWeight: FontWeight.w600, fontSize: AppFontSize.s20,color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}