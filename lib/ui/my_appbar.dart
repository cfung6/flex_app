import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;

  MyAppBar({this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme
          .of(context)
          .primaryColor,
      elevation: 0.0,
      textTheme: Theme.of(context).textTheme,
      title: Text(
        title,
        style:
        Theme
            .of(context)
            .textTheme
            .headline6
            .copyWith(color: Colors.white),
      ),
      actions: <Widget>[],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
