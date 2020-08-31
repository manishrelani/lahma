import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lahma/api/API.dart';
import 'package:lahma/component/display_alert_widget.dart';
import 'package:lahma/model/language_model.dart';
import 'package:lahma/screens/bottom_navigation.dart';
import 'package:lahma/styles/strings.dart';
import 'package:lahma/theme/theme.dart';
import 'package:lahma/utils/ShareManager.dart';
import 'package:lahma/utils/app_routes.dart';
import 'package:lahma/utils/app_translations.dart';
import 'package:lahma/utils/application.dart';
import 'package:lahma/utils/size_config.dart';

class Otp extends StatefulWidget {
  String verificationId;
  AuthCredential phoneAuthCredential;
  String phoneCode;
  String number;
  Otp(this.verificationId, this.phoneAuthCredential, this.phoneCode,
      this.number);
  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  TextEditingController controller = TextEditingController();
  AppTranslations _localization;
  static final List<String> langList = application.supportedLanguages;
  static final List<String> langCodesList = application.supportedLanguagesCodes;

  bool isLoading = false;
  List<LanguageModel> listLangauge = new List();
  String languageName = "", languageCode = "en";
  String token = "";
  FirebaseUser _firebaseUser;
  String _status;

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
      print(languageName);
      loadLangaugeList(value["language"]);
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _localization = AppTranslations.of(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: true,
        body: Stack(
      children: <Widget>[
        _body(),
        isLoading
            ? showProgress(context)
            : SizedBox(
                height: 0.0,
              ),
      ],
    ));
  }

  Widget _body() {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(BACKGROUND_IMAGE), fit: BoxFit.fill)),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0.0,
            right: 0.0,
            child: Image(
                width: SizeConfig.widthMultiplier * 50,
                fit: BoxFit.fitHeight,
                image: new AssetImage(ICON_CORNAR_RIGHT)),
          ),
          Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: SizeConfig.heightMultiplier * 10,
                ),
                Image(
                    // color:Colors.white,
                    width: SizeConfig.widthMultiplier * 50,
                    height: 100.0,
                    fit: BoxFit.contain,
                    image: new AssetImage(ICON_LOGO)),
                Text(
                  "Fresh Meat Made in Jeddah",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 15,
                ),
                _otp(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _otp() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: SizeConfig.widthMultiplier * 75,
            child: TextField(
              keyboardType: TextInputType.number,
              controller: controller,
              maxLength: 6,
              decoration: InputDecoration(
                counter: SizedBox(height: 0.0,),
                  contentPadding: EdgeInsets.only(
                    top: AppSize.extraSmall,
                    right: AppSize.extraSmall,
                    left: AppSize.extraSmall,
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  hintText: "Otp"),
            ),
          ),
          SizedBox(
            height: AppSize.medium,
          ),
          MaterialButton(
              height: SizeConfig.heightMultiplier * 3.5,
              minWidth: SizeConfig.widthMultiplier * 35,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              color: AppTheme.primaryColor,
              child: Text(_localization.localeString("verify"),
                  style: TextStyle(color: Colors.white)),
              onPressed: () {
                if (controller.text.isNotEmpty)
                  _submitOTP();
                else {
                  showDisplayAllert(
                      context: context,
                      isSucces: false,
                      message: _localization.localeString("enter_all_fields"));
                }
              })
        ],
      ),
    );
  }

  void _submitOTP() {
    loadProgress();

    /// get the `smsCode` from the user
    String smsCode = controller.text.toString().trim();

    widget.phoneAuthCredential = PhoneAuthProvider.getCredential(
        verificationId: widget.verificationId, smsCode: smsCode);


    _login();
  }

  Future<void> _login() async {
    /// This method is used to login the user
    /// `AuthCredential`(`_phoneAuthCredential`) is needed for the signIn method
    /// After the signIn method from `AuthResult` we can get `FirebaserUser`(`_firebaseUser`)
    try {
      await FirebaseAuth.instance
          .signInWithCredential(widget.phoneAuthCredential)
          .then((AuthResult authRes) {
        _firebaseUser = authRes.user;

        if(_firebaseUser==null)
          {
            loadProgress();
          }

        print("token456 =  " + _firebaseUser.uid);

        _firebaseUser.getIdToken().then((value) {
          loadProgress();
          print("tokent123 =  " + value.token);
          token = value.token;
          getDetails();
          // ShareMananer.setToken(value.token);
        });
     //   print(_firebaseUser.toString());
        
      });
    } on PlatformException catch  ( e) {
      print("adadadasdad "+e.toString());
      loadProgress();

      if(e.code=="ERROR_INVALID_VERIFICATION_CODE")
        {
          showDisplayAllert(context: context, isSucces: false, message: "verification code invalid");
        }
      else {
        _status = e.toString() + '\n';
        showDisplayAllert(context: context, isSucces: false, message: e.message);
      }

      setState(() {

      });
      print(e.toString());
    }
  }

  getDetails() {
    loadProgress();
    Map<String, String> args = Map<String, String>();
    args["countrycode"] = widget.phoneCode;
    args['mobileNo'] = widget.number;
    args['otp'] = controller.text.trim();
    args["ftoken"] = token;
    API.post(API.oneStep,args).then((value) {
      loadProgress();
      final data = json.decode(value.body);
      print(data);
      if (value.statusCode == 200) {
        loadProgress();
        ShareMananer.setDetails(data["data"]["user_id"],
            data["data"]["access_token"], data["data"]["token_type"], true);
        loadProgress();
        Future.delayed(Duration(seconds: 1), () {
          AppRoutes.makeFirst(context, NavigationScreen(0));
        });
      } else {
        showDisplayAllert(context: context, isSucces: false, message: "error");
      }
    });
  }

  loadProgress() {
    isLoading = !isLoading;
    setState(() {});
  }
}
