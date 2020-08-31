import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lahma/styles/colors.dart';
import 'package:lahma/styles/strings.dart';
import 'package:lahma/theme/theme.dart';
import 'package:lahma/utils/size_config.dart';

class AddressWidget extends StatelessWidget {
  String address;
  bool isSelected;
  GestureTapCallback onTab,onDeleteTab;
  AddressWidget({this.address, this.isSelected, this.onTab,this.onDeleteTab});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        onTab();
      },
      child: Container(
          // width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: AppSize.small, vertical: AppSize.small),
            color: AppTheme.primaryColor.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Flexible(
                    child: GestureDetector(
                      onTap: (){
                        onTab();
                      },
                      child: Image.asset(
                  isSelected ? CHECKBOX_ACTIVE : CHECKBOX_NOT_ACTIVE,
                        height: AppSize.medium,
                ),
                    )),
                SizedBox(
                  width: AppSize.small,
                ),
                Container(
                    width: SizeConfig.widthMultiplier * 80,
                    child: Text(
                      address,
                      style: AppTheme.textStyle.lightText
                          .copyWith(color: Colors.black),
                    )),
                isSelected
                    ? Flexible(
                        child: GestureDetector(
                          onTap: (){
                            onDeleteTab();
                          },
                          child: Image.asset(
                          DELETE_ICON,
                          width: AppSize.smallMedium,
                      ),
                        ))
                    : SizedBox(
                        width: 0.0,
                      ),
              ],
            ),
          ),

          // red line
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: AppSize.small, vertical: AppSize.small),
            // color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Flexible(
                    child: Image.asset(
                  LOCATION_COLOR_ICON,
                  width: AppSize.smallMedium,
                )),
                SizedBox(
                  width: AppSize.small,
                ),
                Container(
                    width: SizeConfig.widthMultiplier * 80,
                    child: Text(
                      address,
                      style: AppTheme.textStyle.lightText
                          .copyWith(color: Colors.black),
                    )),
              ],
            ),
          )
        ],
      )),
    );
  }
}
