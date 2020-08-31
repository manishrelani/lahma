import 'package:flutter/material.dart';
import 'package:lahma/theme/theme.dart';
import 'package:lahma/utils/size_config.dart';

class CustomRoundBorderButtonWidget extends StatelessWidget{
  final String title;
  final GestureTapCallback callback;
  final double buttonWidth;
  CustomRoundBorderButtonWidget({ @required this.title, @required this.callback, @required this.buttonWidth,});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: new BoxDecoration(
        color: AppTheme.primaryColor,
      //  border: Border.all(color: AppTheme.primaryColor,width: 3),
        borderRadius: BorderRadius.all(Radius.circular(AppSize.extraSmall)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey,
            offset: Offset(1.0, 6.0),
            blurRadius: 10.0,
          ),

        ],
      ),

      child: MaterialButton(
          highlightColor: Colors.transparent,
          splashColor: AppTheme.colors.loginGradientEnd,
          //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 10.0, horizontal: 10.0),
            child: Text(
              title,
              style:AppTheme.textStyle.buttonText.copyWith(color: Colors.white,fontSize: 20.0),
            ),
          ),
          onPressed: () {
            callback();
          }
      ),
    );
  }
}