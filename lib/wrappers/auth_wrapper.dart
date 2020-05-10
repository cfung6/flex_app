import 'package:flex/screens/continue_with.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import 'display_name_wrapper.dart';

//Values that this screen consumes:
//  -current user

//Parent: Main
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user == null) {
      return ContinueWith();
    } else {
      return DisplayNameWrapper();
    }
  }
}
