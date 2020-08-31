import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:lahma/api/API.dart';
import 'package:lahma/component/address_widget.dart';
import 'package:lahma/component/custom_round_border_button.dart';
import 'package:lahma/component/display_alert_widget.dart';
import 'package:lahma/component/language_widget.dart';
import 'package:lahma/model/language_model.dart';
import 'package:lahma/screens/address.dart';
import 'package:lahma/screens/address_modify.dart';
import 'package:lahma/styles/strings.dart';
import 'package:lahma/theme/theme.dart';
import 'package:lahma/utils/ShareManager.dart';
import 'package:lahma/utils/app_routes.dart';
import 'package:lahma/utils/app_translations.dart';
import 'package:lahma/utils/application.dart';
import 'package:lahma/utils/size_config.dart';
import 'package:google_maps_webservice/places.dart';

class LocationScreen extends StatefulWidget {
  final bool flag;
  LocationScreen(this.flag);
  _LocationScreen createState() => _LocationScreen();
}

class _LocationScreen extends State<LocationScreen> {
  AppTranslations _localization;
  static final List<String> langList = application.supportedLanguages;
  static final List<String> langCodesList = application.supportedLanguagesCodes;
  String languageName = "", languageCode = "en";
  int counter = 0;
  String token;
  double lat = 0.0, long = 0.0;
  bool isLoading = false;
  bool hasLocation = false;
  Position position = null;
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController addressController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController areaController = new TextEditingController();
  Set<Marker> markers = Set();
  GoogleMapsPlaces _places =
      GoogleMapsPlaces(apiKey: "AIzaSyBLA37Y9eeJWlERuOYOMPFlIXeHHqHWIDk");
//
//  static final CameraPosition _kGooglePlex = CameraPosition(
//    target: LatLng(lat, long),
//    zoom: 14.4746,
//  );

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


  createMarker(){
    Marker resultMarker = Marker(
      markerId: MarkerId("CurrentLocation"),

      position: LatLng(lat,long),
    );
// Add it to Set
    markers.clear();
    markers.add(resultMarker);

    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    getLocation();
    ShareMananer.getUserDetails().then((value) {
      languageName = value["language"];
      token = value["access_token"];
      print(languageName);
      loadLangaugeList(value["language"]);
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

  getLocation() async {
   // loadProgress();
    Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;

    GeolocationStatus geolocationStatus =
        await geolocator.checkGeolocationPermissionStatus();
    print(geolocationStatus.value);
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    lat = position.latitude;
    long = position.longitude;
    hasLocation = true;
    setState(() {

    });
    createMarker();
    getAddress();

    setState(() {});
  }

  getAddress() async {
    List<Placemark> placemark =
        await Geolocator().placemarkFromCoordinates(lat, long);

    print(placemark[0].name);

    print(
       "adda "+ placemark[0].toJson().toString());

    areaController.text = placemark[0].subLocality+" "+placemark[0].postalCode;
    cityController.text = placemark[0].locality;
    addressController.text = placemark[0].name;
   // loadProgress();

//    final GoogleMapController controller = await _controller.future;
//    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat,long))));
//
//
//    _controller.complete(controller);
    hasLocation = true;
    setState(() {});
  }

  Widget _body() {
    return Directionality(
      textDirection:
          languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            Container(
              height: SizeConfig.heightMultiplier * 40,
              child: hasLocation
                  ? GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(lat ?? 0, long ?? 0),
                  zoom: 14.4746,
                ),
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
              new Factory<OneSequenceGestureRecognizer>(() => new EagerGestureRecognizer(),),
              ].toSet(),
                trafficEnabled: true,
                buildingsEnabled: true,
                markers: markers,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              )
                  : SizedBox(
                height: SizeConfig.heightMultiplier * 40,
              ),
            ),

            SizedBox(height: AppSize.medium,),

            GestureDetector(
              onTap: (){

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlacePicker(
                      apiKey: API.GOOGLE_API,   // Put YOUR OWN KEY here.
                      onPlacePicked: (result) {
                        hasLocation=false;
                        setState(() {

                        });
                        result.toString();

                        lat = result.geometry.location.lat;
                        long=result.geometry.location.lng;
                        createMarker();
                        setState(() {

                        });

                        hasLocation=true;
                        getAddress();
                        Navigator.of(context).pop();
                      },
                      initialPosition: LatLng(lat ?? 0, long ?? 0),
                      useCurrentLocation: true,
                    ),
                  ),
                );
              },
              child: Container(
                width: SizeConfig.widthMultiplier*60,
                height: SizeConfig.heightMultiplier*5,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                Icon(Icons.location_searching,color: Colors.white,),
                  SizedBox(width: AppSize.smallMedium,),
                  Text("Choose Location",style: AppTheme.textStyle.heading1.copyWith(color: Colors.white,fontSize: AppFontSize.s16),)
              ],),),
            ),


            SizedBox(height: AppSize.medium,),

            textFeild(_localization.localeString("addressDetails"),
                addressController),
            textFeild(_localization.localeString("city"), cityController),
            textFeild(_localization.localeString("area"), areaController),

            //  submit button
            Container(
              margin: EdgeInsets.symmetric(vertical: AppSize.mediumLarge),
              child: CustomRoundBorderButtonWidget(
                buttonWidth: SizeConfig.widthMultiplier * 80,
                title: _localization.localeString("submit"),
                callback: () {
                  addAddress();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showSearch() async {
    hasLocation = false;
    setState(() {});
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction p = await PlacesAutocomplete.show(
        //components: [new Component(Component.country, "co")],
        hint: "Search Location",
        context: context,
        apiKey: "AIzaSyBLA37Y9eeJWlERuOYOMPFlIXeHHqHWIDk",
        logo: SizedBox(
          width: AppSize.extraLarge,
        ));

    displayPrediction(p, false);
  }

  Future<Null> displayPrediction(Prediction p, bool clickType) async {
   // loadProgress();
    if (p != null) {
      // progressLoad();
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);

      var placeId = p.placeId;
      lat = detail.result.geometry.location.lat;
      long = detail.result.geometry.location.lng;

      setState(() {});

      getAddress();
    }
    else{
      hasLocation = true;
      setState(() {});
    }
  }

  Widget textFeild(String title, TextEditingController controller) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                title,
                style: AppTheme.textStyle.heading1.copyWith(
                    fontSize: AppFontSize.s16, color: AppTheme.primaryColor),
              ),
              Text(
                "*",
                style: AppTheme.textStyle.heading1.copyWith(
                    fontSize: AppFontSize.s16, color: AppTheme.primaryColor),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5.0),
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            width: double.maxFinite,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 1.0),
                borderRadius: BorderRadius.circular(10.0)),
            child: TextField(
              controller: controller,
              decoration: InputDecoration.collapsed(
                hintText: "",
                border: InputBorder.none,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      centerTitle: true,
      title: Text(_localization.localeString("Address")),
      leading: IconButton(
        padding: EdgeInsets.only(left: 10.0),
        color: Colors.blue,
        iconSize: 15.0,
        icon: new Image.asset(SEARCH_ICON, color: Colors.white),
        onPressed: () {
          _showSearch();
        },
      ),
    );
  }

  addAddress() {
    loadProgress();
    Map<String, String> args = Map<String, String>();
    args["lat"] = position.latitude.toString();
    args['long'] = position.longitude.toString();
    args['address'] = addressController.text;
    args["city"] = cityController.text;
    args["area"] = areaController.text;
    API.post1(API.address, args, token).then((value) {
      loadProgress();
      final data = json.decode(value.body);
      print(data);
      if (value.statusCode == 200) {
        if (data["message"] == "success") {
          if (!widget.flag)
            AppRoutes.replace(context, AddressScreen());
          else {
            AppRoutes.replace(context, AddressModifyScreen());
          }
        }
      }
    });
  }

  loadProgress() {
    isLoading = !isLoading;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }
}
