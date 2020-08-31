import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lahma/styles/strings.dart';
import 'package:lahma/utils/app_translations.dart';

class Offers extends StatefulWidget {
  @override
  _OffersState createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  AppTranslations _localization;
  @override
  Widget build(BuildContext context) {
    _localization = AppTranslations.of(context);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return Scaffold(
      appBar: _appBar(),
      body: Stack(
        children: <Widget>[
          Container(
            child: Image.asset(
              BACKGROUND_IMAGE,
              fit: BoxFit.fill,
            ),
          ),
          _body(),
        ],
      ),
    );
  }

  Widget _body() {
    return ListView(
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.28,
          child: Image.asset(
            "",
            fit: BoxFit.fill,
          ),
        ),
      ],
    );
  }

  Widget _appBar() {
    return AppBar(
      centerTitle: true,
      title: Text(_localization.localeString("Offers")),
      leading: IconButton(
        color: Colors.blue,
        iconSize: 15.0,
        icon: new Image.asset(ICON_CART, color: Colors.white),
        onPressed: () {},
      ),
    );
  }
}