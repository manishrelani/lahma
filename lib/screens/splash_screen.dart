import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lahma/api/API.dart';
import 'package:lahma/screens/bottom_navigation.dart';
import 'package:lahma/screens/login.dart';
import 'package:lahma/screens/product.dart';
import 'package:lahma/styles/colors.dart';
import 'package:lahma/styles/strings.dart';
import 'package:lahma/utils/ShareManager.dart';
import 'package:lahma/utils/app_routes.dart';
import 'package:lahma/utils/size_config.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    refreshPermission();
   // callScreen();
  }

  //Call screen based on conditions
  callScreen() async {
    ShareMananer.getUserDetails().then((userDetails) {
      String isLogin = userDetails["login"].toString();

      print(isLogin);

      if (isLogin == "null") {
        print("1");
        Future.delayed(Duration(seconds: 3), () {
          AppRoutes.makeFirst(context, Login());
        });
      } else {
        Future.delayed(Duration(seconds: 3), () {
          AppRoutes.makeFirst(context, NavigationScreen(0));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    //  appSizeInit(context);
    return SafeArea(
      right: false,
      bottom: false,
      left: false,
      top: false,
      child: Scaffold(
          body: Container(
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
                Positioned(
                  bottom: 0.0,
                  child: Image(
                    // color:Colors.white,
                      width: SizeConfig.widthMultiplier * 100,
                      fit: BoxFit.fill,
                      image: new AssetImage(ICON_MEET_PORTAIT)),
                ),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  child: Image(
                    // color:Colors.white,
                      width: SizeConfig.widthMultiplier * 50,
                      fit: BoxFit.fitHeight,
                      image: new AssetImage(ICON_CORNAR_LEFT)),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        // color:Colors.white,
                          width: SizeConfig.widthMultiplier * 50,
                          height: 100.0,
                          fit: BoxFit.contain,
                          image: new AssetImage(ICON_LOGO)),
                      Text(
                        "Fresh Meat Made in Jeddah",
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }


  refreshPermission() async {
    if (await Permission.location.request().isDenied) {


      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.locationWhenInUse,
        Permission.locationAlways
      ].request();
      print(statuses[Permission.location]);
      // Either the permission was already granted before or the user just granted it.
    }


//
//    await _getCameraPermission();
//    await _getContactPermission();
//    await _getLocationPermission();
    callScreen();
  }


//  Future<PermissionStatus> _getContactPermission() async {
//    PermissionStatus permission = await PermissionHandler()
//        .checkPermissionStatus(PermissionGroup.contacts);
//    if (permission != PermissionStatus.granted) {
//      Map<PermissionGroup, PermissionStatus> permissionStatus =
//      await PermissionHandler()
//          .requestPermissions([PermissionGroup.contacts]);
//      return permissionStatus[PermissionGroup.contacts] ??
//          PermissionStatus.unknown;
//    } else {
//      return permission;
//    }
//  }
//
//  Future<PermissionStatus> _getCameraPermission() async {
//    PermissionStatus permission = await PermissionHandler()
//        .checkPermissionStatus(PermissionGroup.camera);
//    if (permission != PermissionStatus.granted) {
//      Map<PermissionGroup, PermissionStatus> permissionStatus =
//      await PermissionHandler()
//          .requestPermissions([PermissionGroup.camera]);
//      return permissionStatus[PermissionGroup.camera] ??
//          PermissionStatus.unknown;
//    } else {
//      return permission;
//    }
//  }
//
//
//  Future<PermissionStatus> _getLocationPermission() async {
//    PermissionStatus permission = await PermissionHandler()
//        .checkPermissionStatus(PermissionGroup.location);
//    if (permission != PermissionStatus.granted) {
//      Map<PermissionGroup, PermissionStatus> permissionStatus =
//      await PermissionHandler()
//          .requestPermissions([PermissionGroup.location]);
//      return permissionStatus[PermissionGroup.location] ??
//          PermissionStatus.unknown;
//    } else {
//      return permission;
//    }
//  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      throw new PlatformException(
        code: "PERMISSION_DENIED",
        message: "Access to location data denied",
      );
    }
  }




  @override
  void dispose() {
    super.dispose();
  }
}
