import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:lahma/screens/splash_screen.dart';
import 'package:lahma/theme/theme.dart';
import 'package:lahma/utils/ShareManager.dart';
import 'package:lahma/utils/app_translations_delegate.dart';
import 'package:lahma/utils/application.dart';
import 'package:lahma/utils/size_config.dart';
import 'package:sqflite/sqflite.dart';

import 'api/Database.dart';

void main() => runApp(Phoenix(child: MyApp()));

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>new _MyApp();
  // This widget is the root of your application.

}


class _MyApp extends State<MyApp> {
  Locale locale;
  AppTranslationsDelegate _newLocaleDelegate;
  String languageCode="";



  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return languageCode!=""? MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Lahma",
              theme: ThemeData(
                primaryColor: AppTheme.primaryColor,
                accentColor: AppTheme.accentColor
              ),
              localizationsDelegates: [
                _newLocaleDelegate,
                //provides localised strings
                GlobalMaterialLocalizations.delegate,
                //provides RTL support
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: application.supportedLocales(),
           //   theme: CustomTheme.customTheme(context),
              home: SplashScreen(),
            ):Container(color: Colors.white,);
          },
        );
      },
    );
  }



  onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }

  @override
  void initState() {
    super.initState();

    SQLiteDbProvider.db.initDB();

    ShareMananer.getLanguageSetting().then((onValue)
    {
      languageCode=onValue["language"].toString();
      print("1");
      print(languageCode);
      setState(() {

      });

      if(languageCode==""||languageCode=="null")
      {
        ShareMananer.setLanguageSetting("ar");
        print("2");
        print(languageCode);
        languageCode="ar";

        setState(() {

        });
      }

      _newLocaleDelegate = AppTranslationsDelegate(newLocale: Locale(languageCode));
      application.onLocaleChanged = onLocaleChange;
    });




  }


}


