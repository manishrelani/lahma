import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lahma/component/display_alert_widget.dart';
import 'package:lahma/model/language_model.dart';
import 'package:lahma/screens/otp.dart';
import 'package:lahma/styles/dimensions.dart';
import 'package:lahma/styles/strings.dart';
import 'package:lahma/theme/theme.dart';
import 'package:lahma/utils/ShareManager.dart';
import 'package:lahma/utils/app_routes.dart';
import 'package:lahma/utils/app_translations.dart';
import 'package:lahma/utils/application.dart';
import 'package:lahma/utils/size_config.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController controller = TextEditingController();
  AppTranslations _localization;
  static final List<String> langList = application.supportedLanguages;
  static final List<String> langCodesList = application.supportedLanguagesCodes;
  List<LanguageModel> listLangauge = new List();
  String languageName = "", languageCode = "en";
  String phoneCode = "+966";
  bool isLoading = false;
  AuthCredential _phoneAuthCredential;
  String _status;
  String _verificationId;
  int _code;

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
      //  islogin = value['login'];
      print(languageName);
      loadLangaugeList(value["language"]);
    });

    setState(() {});
  }

  Widget _dropdown() {
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(right: DIMENSION_04),
      child: DropdownButton<String>(
        items: <String>["+966", "+91", "+20"].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Container(
              child: Text(
                value,
              ),
            ),
          );
        }).toList(),
        onChanged: (code) {
          phoneCode = code;
          setState(() {});
        },
        value: phoneCode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    _localization = AppTranslations.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: true,
        body: Stack(
      children: <Widget>[
        _body(context),
        isLoading
            ? showProgress(context)
            : SizedBox(
                height: 0.0,
              ),
      ],
    ));
  }

  Widget _body(context) {
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
              //mainAxisAlignment: MainAxisAlignment.center,
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
                _login(context)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _login(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _localization.localeString("login_register"),
          style: AppTheme.textStyle.fieldText,
        ),
        SizedBox(
          height: AppSize.medium,
        ),
        Container(
          height: 35,
          width: SizeConfig.widthMultiplier * 65,
          child: Row(
            children: [
              _dropdown(),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: controller,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                      top: AppSize.extraSmall,
                      right: AppSize.extraSmall,
                      left: AppSize.extraSmall,
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    /* prefix: _dropdown() */
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: AppSize.medium,
        ),
        MaterialButton(
            height: SizeConfig.heightMultiplier * 3.5,
            minWidth: SizeConfig.widthMultiplier * 35,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            color: AppTheme.primaryColor,
            child: Text(_localization.localeString("login_register"),
                style: TextStyle(color: Colors.white)),
            onPressed: () {
              if (phoneCode != null && controller.text.isNotEmpty) {
                _submitPhoneNumber(context);
              } else
                showDisplayAllert(
                    context: context,
                    isSucces: false,
                    message: _localization.localeString("enter_all_fields"));
              // check(context);
            })
      ],
    );
  }

  /* check(context) {
    loadProgress();
    Map<String, String> args = Map<String, String>();
    args["countrycode"] = phoneCode;
    args['mobileNo'] = controller.text.trim();
    args['type'] = "register";
    API.otpApi(args).then((value) {
      loadProgress();
      final data = json.decode(value.body);
      if (value.statusCode == 200) {
        if (data["code"] == 1) {
          if (data["firebase"] == 1) {
            _submitPhoneNumber(context);
            if (_code != null) {
              
             
            }
          }
        } else
          showDisplayAllert(
              context: context, isSucces: false, message: data["message"]);
      }
      print(data);
    });
  } */

  Future<void> _submitPhoneNumber(context) async {
    String phoneNumber = phoneCode + controller.text;
    print(phoneNumber);

    void verificationCompleted(AuthCredential phoneAuthCredential) {
      print('verificationCompleted');
      this._phoneAuthCredential = phoneAuthCredential;
      print(phoneAuthCredential);
    }

    void verificationFailed(AuthException error) {
      print('verificationFailed');
      setState(() {
        showDisplayAllert(
            context: context,
            isSucces: false,
            message: error.message.toString());
        _status += '$error\n';
      });
      print(error);
    }

    void codeSent(String verificationId, [int code]) {
      print('codeSent');
      this._verificationId = verificationId;
      print(verificationId);
      this._code = code;
      print(code.toString());
      setState(() {
        AppRoutes.goto(
            context,
            Otp(_verificationId, _phoneAuthCredential, phoneCode,
                controller.text));
      });
    }

    void codeAutoRetrievalTimeout(String verificationId) {
      print('codeAutoRetrievalTimeout');
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,

      timeout: Duration(milliseconds: 10000),

      verificationCompleted: verificationCompleted,

      /// Called when the verification is failed
      verificationFailed: verificationFailed,

      /// This is called after the OTP is sent. Gives a `verificationId` and `code`
      codeSent: codeSent,

      /// After automatic code retrival `tmeout` this function is called
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    ); // All the callbacks are above
  }

  loadProgress() {
    isLoading = !isLoading;
    setState(() {});
  }
}
