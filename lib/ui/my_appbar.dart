import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;

  MyAppBar({this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      elevation: 0.0,
      textTheme: Theme.of(context).textTheme,
      title: Text(title),
      actions: <Widget>[],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
