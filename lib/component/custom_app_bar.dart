import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final GestureTapCallback callback;
  final icon;
  CustomAppBar({@required this.title, @required this.callback,@required this.icon});
  @override
  Widget build(BuildContext context) {
    return AppBar(
        centerTitle: true,
        title: Text(title),
        actions: [
    SizedBox(
      width: 10,
    ),
    IconButton(
      color: Colors.blue,
      iconSize: 15.0, 
      icon: new Image.asset(icon, color: Colors.white,height: 20,),
      onPressed: () {
        callback();
      },
    ),
    SizedBox(
      width: 10,
    ),
        ],
      );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize =>  Size.fromHeight(kToolbarHeight);
}
