import 'package:flutter/cupertino.dart';

class MenuPage extends StatelessWidget {
  final List<MenuCategory> categories = [];

  MenuPage() {

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class MenuCategory {
  final String name;
  final ValueChanged<MenuCategory> onTap;

  const MenuCategory({this.name, this.onTap});
}
