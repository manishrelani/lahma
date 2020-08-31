import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:lahma/utils/size_config.dart';




void showDisplayAllert({BuildContext context,bool isSucces,String message}){
  Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
    flushbarStyle: FlushbarStyle.FLOATING,
    backgroundColor:isSucces?Colors.green:Colors.red,
    boxShadows: [BoxShadow(color: Colors.grey, offset: Offset(0.0, 2.0), blurRadius: 10.0)],

    message:  message,
    duration:  Duration(seconds: 3),
  )..show(context);;
}


Future<bool> checkInternet(){

  return DataConnectionChecker().hasConnection;
}


Widget showProgress(BuildContext context)
{
return Container(
  color: Colors.black.withOpacity(0.5),
  width: double.maxFinite,
  height: SizeConfig.heightMultiplier*100,
  child: Center( child: CircularProgressIndicator()),

);
}
