import 'dart:developer';

import 'package:flex/models/user.dart';
import 'package:flex/screens/login.dart';
import 'package:flex/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'loading.dart';

//Parent: AuthWrapper
class ContinueWith extends StatefulWidget {
  @override
  _ContinueWithState createState() => _ContinueWithState();
}

class _ContinueWithState extends State<ContinueWith> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    Auth auth = Auth();

    return _loading
        ? Loading()
        : Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 60.0),
            Column(
              children: <Widget>[
                Image.asset(
                  'assets/images/jordan_one_icon.png',
                  width: 100.0,
                  height: 100.0,
                ),
                const Text(
                  'FLEX',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100.0),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SignInButtonBuilder(
                  icon: Icons.email,
                  text: 'Continue with email',
                  backgroundColor: Color(0xFF455964),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => Login()));
                  },
                  fontSize: 18.0,
                  padding: const EdgeInsets.all(14.0),
                  width: 250.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SignInButtonBuilder(
                  image: Image.asset(
                    'assets/images/anon.jpg',
                    height: 20.0,
                  ),
                  text: 'Continue anonymously',
                  backgroundColor: Colors.white,
                  splashColor: Colors.grey,
                  onPressed: () async {
                    setState(() => _loading = true);
                    User res = await auth.signInAnon();

                    if (res != null) {
                      log(res.userInfo.toString());
                    } else {
                      log('error signing in anon');
                    }
                  },
                  fontSize: 18.0,
                  textColor: Colors.black,
                  padding: const EdgeInsets.all(14.0),
                  width: 250.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
