import 'package:flutter/material.dart';
import 'package:lahma/styles/strings.dart';
import 'package:lahma/theme/theme.dart';
import 'package:lahma/utils/app_translations.dart';
import 'package:lahma/utils/size_config.dart';

class CustomRadio extends StatefulWidget {
  final String fName;
  final String sName;
  final String tName;
  final String defName;
  final Function onchanged;
  CustomRadio(this.fName, this.sName, this.tName, this.defName,
      {@required this.onchanged});
  @override
  _CustomRadioState createState() => _CustomRadioState();
}

class _CustomRadioState extends State<CustomRadio> {
  static String _selectedValue = "";
  AppTranslations _localization;
    @override
  void initState() {
    setState(() {
      _selectedValue = widget.defName;
    });
    super.initState();
  }  

  @override
  Widget build(BuildContext context) {
    _localization = AppTranslations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        IconButton(
          icon: Image.asset(
              _selectedValue == widget.fName
                  ? CHECKBOX_ACTIVE
                  : CHECKBOX_NOT_ACTIVE,
              height: AppSize.smallMedium),
          onPressed: () {
            setState(() {
              _selectedValue = widget.fName;
              widget.onchanged(widget.fName);
            });
          },
        ),
        Text(
          _localization.localeString(widget.fName),
          style: AppTheme.textStyle.fieldTitle,
        ),
        IconButton(
          icon: Image.asset(
              _selectedValue == widget.sName
                  ? CHECKBOX_ACTIVE
                  : CHECKBOX_NOT_ACTIVE,
              height: AppSize.smallMedium),
          onPressed: () {
            setState(() {
              _selectedValue = widget.sName;
              widget.onchanged(widget.sName);
            });
          },
        ),
        Text(
          _localization.localeString(widget.sName),
          style: AppTheme.textStyle.fieldTitle,
        ),
        IconButton(
          icon: Image.asset(
              _selectedValue == widget.tName
                  ? CHECKBOX_ACTIVE
                  : CHECKBOX_NOT_ACTIVE,
              height: AppSize.smallMedium),
          onPressed: () {
            setState(() {
              _selectedValue = widget.tName;
              widget.onchanged(widget.tName);
            });
          },
        ),
        Text(
          _localization.localeString(widget.tName),
          style: AppTheme.textStyle.fieldTitle,
        ),
      ],
    );
  }
}
