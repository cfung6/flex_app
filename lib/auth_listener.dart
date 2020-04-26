import 'package:flex/screens/continue_with.dart';
import 'package:flex/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

class AuthListener extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user == null) {
      return ContinueWith();
    } else {
      return Home();
    }
  }
}
