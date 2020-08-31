import 'package:flutter/material.dart';
import 'package:lahma/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_routes.dart';

class ShareMananer {


  static Future<String> isLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool loginState = prefs.get("login") ?? false;

    if (loginState) {
      String user = prefs.get("user_type");

      if (user == "viewer") {
        return user;
      } else {
        return user;
      }
    }

    return "null";
  }

  static logOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    AppRoutes.makeFirst(context, Login());
  }

  static Future<Map<String, String>> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> user = new Map<String, String>();
    user["user_id"] = prefs.get("user_id");
    user["notificationId"] = prefs.get("notificationId");
    user["language"] = prefs.get("language");
    user["login"] = prefs.get("login");
    user["access_token"]=prefs.get("access_token");
    user["token_type"]=prefs.get("token_type");
    user["name"]=prefs.get("name");
    return user;
  }

  static void setLanguageSetting(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
  }

  static void setDetails(
      String user_id, String access_token, String token_type,bool islogin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', user_id);
    await prefs.setString('access_token', access_token);
    await prefs.setString('token_type', token_type);
    await prefs.setString('login', islogin.toString());
  }

  static Future<Map<String, String>> getLanguageSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> user = new Map<String, String>();
    user["language"] = prefs.get("language");

    return user;
  }

  static void setUserName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
  }


  static void setDefaultAddress(
      // String user_id,
      String id,
      String lat,
      String long,
      String city,
      String area,
      String address,) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setString('user_id', user_id);
    await prefs.setString('id', id);
    await prefs.setString('lat', lat);
    await prefs.setString('long', long);
    await prefs.setString('city', city);
    await prefs.setString('area', area);
    await prefs.setString('address', address);
    //  await prefs.setString('login', isLogin.toString());
  }



  static Future<Map<String, String>> getDefaultAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> address = new Map<String, String>();
    address["id"] = prefs.get("id");
    address["lat"] = prefs.get("lat");
    address["long"] = prefs.get("long");
    address["city"] = prefs.get("city");
    address["area"] = prefs.get("area");
    address["address"] = prefs.get("address");
    return address;
  }
}
