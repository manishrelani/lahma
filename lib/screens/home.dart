import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lahma/styles/strings.dart';
import 'package:lahma/utils/app_translations.dart';


class HomeScreen extends StatefulWidget {
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  AppTranslations _localization;
  int counter = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _localization = AppTranslations.of(context);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    //  appSizeInit(context);
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
            HOME_BANNER,
            fit: BoxFit.fill,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _product(),
             SizedBox(
              width: 10,
            ), 
            _product(),
          ],
        ),
      ],
    );
  }

  Widget _appBar() {
    return AppBar(
      centerTitle: true,
      title: Text(_localization.localeString("Product")),
      leading: IconButton(
        color: Colors.blue,
        iconSize: 15.0,
        icon: new Image.asset(ICON_CART, color: Colors.white),
        onPressed: () {},
      ),
    );
  }

  Widget _product() {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 20, bottom: 20),
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width * 0.44,
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              borderRadius: BorderRadius.circular(8)),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(PRO1),
                SizedBox(
                  height:10,
                ),
                Divider(
                  color: Colors.black,
                  height: 1,
                  indent: 5,
                  endIndent: 5,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.red),
              margin: EdgeInsets.only(top: 20),
              width: 50,
              height: 20,
              child: Text(
                "70SR",
                style: TextStyle(
                  color: Colors.white,
                ),
              )),
        ),
        _counter()
      ],
    );
  }

  Widget _counter() {
    return Positioned(
      bottom: 0,
      child: Container(
        height: 40,
        width: MediaQuery.of(context).size.width * 0.23,
        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.11),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.red),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              child: Container(
                alignment: Alignment.center,
                height: double.infinity,
                child: Text(
                  "+",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              onTap: () {
                setState(() {
                  counter++;
                });
              },
            ),
            Container(
              height: 39,
              width: 45,
              alignment: Alignment.center,
              color: Colors.white,
              child: Text(
                "$counter",
                style: TextStyle(fontSize: 20),
              ),
            ),
            GestureDetector(
              child: Container(
                alignment: Alignment.center,
                height: double.infinity,
                child: Text(
                  "-",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
              onTap: () {
                setState(() {
                  if (counter == 0)
                    counter = 0;
                  else
                    counter--;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
