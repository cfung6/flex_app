import 'package:flex/screens/home.dart';
import 'package:flex/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DisplayNameWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureProvider<String>.value(
      value: Auth().getDisplayNameFromFirebase(),
      child: Home(),
    );
  }
}
