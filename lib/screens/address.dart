import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lahma/api/API.dart';
import 'package:lahma/component/address_widget.dart';
import 'package:lahma/component/custom_round_border_button.dart';
import 'package:lahma/component/display_alert_widget.dart';
import 'package:lahma/model/address_model.dart';
import 'package:lahma/screens/location.dart';
import 'package:lahma/styles/strings.dart';
import 'package:lahma/theme/theme.dart';
import 'package:lahma/utils/ShareManager.dart';
import 'package:lahma/utils/app_routes.dart';
import 'package:lahma/utils/app_translations.dart';
import 'package:lahma/utils/application.dart';
import 'package:lahma/utils/size_config.dart';
import 'package:permission_handler/permission_handler.dart';

class AddressScreen extends StatefulWidget {
  _AddressScreen createState() => _AddressScreen();
}

class _AddressScreen extends State<AddressScreen> {
  AppTranslations _localization;
  static final List<String> langList = application.supportedLanguages;
  static final List<String> langCodesList = application.supportedLanguagesCodes;
  String languageName = "", languageCode = "en";
  var data;
  List<AddressModel> listAddress = new List();
  int counter = 0;
  bool isLoading = false;
  String token;

  loadLangaugeList(String setCode) {
    for (int i = 0; i < langList.length; i++) {
      String name = langList[i];
      String code = langCodesList[i];

      if (code == setCode) {
        languageName = name;
        languageCode = code;
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadProgress();
    ShareMananer.getUserDetails().then((value) {
      languageName = value["language"];
      token = value["access_token"];
      print(languageName);
      loadLangaugeList(value["language"]);

      API.get1(API.address, token).then((value) {
        loadProgress();
        data = json.decode(value.body);
        print("address $data");
        if (value.statusCode == 200) {
          List list = data;

          for (int i = 0; i < list.length; i++) {
            String id = list[i]["id"].toString();
            String lat = list[i]["lat"].toString();
            String long = list[i]["long"].toString();
            String city = list[i]["city"].toString();
            String area = list[i]["area"].toString();
            String address = list[i]["address"].toString();

            listAddress.add(
                new AddressModel(id, lat, long, city, area, address, false));
          }
        }
        setState(() {});
      });
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _localization = AppTranslations.of(context);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    //  appSizeInit(context);
    return Directionality(
      textDirection:
          languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
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
          )),
    );
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

  addNewAddress() async {
//    Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
//    GeolocationStatus geolocationStatus  = await geolocator.checkGeolocationPermissionStatus();

    if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
      // Use location.
      AppRoutes.replace(context, LocationScreen(false));
    } else {
      showDisplayAllert(
          isSucces: false,
          message: _localization.localeString("locationInfo"),
          context: context);
    }
  }

  Widget _body() {
    return Directionality(
      textDirection:
          languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: AppSize.mediumLarge),
            child: CustomRoundBorderButtonWidget(
              buttonWidth: SizeConfig.widthMultiplier * 80,
              title: _localization.localeString("addAddress"),
              callback: () {
                addNewAddress();
              },
            ),
          ),
          data == null
              ? Container()
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: listAddress.length,
                  itemBuilder: (context, int index) {
                    ShareMananer.getDefaultAddress().then((value) {
                      if (listAddress[index].id == value["id"]) {
                        listAddress[index].isSelected = true;
                        setState(() {});
                      }
                    });

                    return AddressWidget(
                      isSelected: listAddress[index].isSelected,
                      address: listAddress[index].address,
                      onDeleteTab: () {
                        delete(index);
                      },
                      onTab: () {
                        for (int i = 0; i < listAddress.length; i++) {
                          listAddress[i].isSelected = false;
                        }
                        listAddress[index].isSelected = true;
                        ShareMananer.setDefaultAddress(
                            listAddress[index].id,
                            listAddress[index].lat,
                            listAddress[index].long,
                            listAddress[index].city,
                            listAddress[index].area,
                            listAddress[index].address);
                        setState(() {});
                      },
                    );
                  },
                ),
        ],
      ),
    );
  }

  delete(int index) {
    if (listAddress.length == 1) {
      showDisplayAllert(
          context: context,
          isSucces: false,
          message: "Default address cant be deleted");
    } else {
      loadProgress();
      API.delete(data[index]["id"], token).then((value) {
        loadProgress();
        final data = json.decode(value.body);
        if (value.statusCode == 200) {
          if (data["message"] == "success") {
            listAddress.removeAt(index);
            setState(() {});
            // AppRoutes.replace(context, AddressScreen());
          }
        }
        print(data);
      });
    }
  }

  Widget _appBar() {
    return AppBar(
      centerTitle: true,
      title: Text(_localization.localeString("Address")),
      leading: IconButton(
        color: Colors.blue,
        iconSize: 15.0,
        icon: RotatedBox(
            quarterTurns: languageCode == "en" ? 2 : 0,
            child: new Image.asset(BACK_ICON, color: Colors.white)),
        onPressed: () {
          AppRoutes.dismiss(context);
        },
      ),
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
