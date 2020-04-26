import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _username = '';
  String _password = '';
  Color _red = const Color(0xFFC13F4D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
            const SizedBox(height: 60.0),
            Form(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Username',
                    ),
                    onChanged: (str) {
                      setState(() {
                        _username = str;
                      });
                    },
                  ),
                  const SizedBox(height: 15.0),
                  TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Password',
                    ),
                    onChanged: (str) {
                      setState(() {
                        _password = str;
                      });
                    },
                    obscureText: true,
                  )
                ],
              ),
            ),
            ButtonBar(
              children: <Widget>[
                Text("Don't have an account?"),
                FlatButton(
                  textColor: _red,
                  child: Text('Sign up'),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 100.0),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Sign in'),
        icon: Image.asset(
          'assets/images/login.png',
          width: 25.0,
          height: 25.0,
        ),
        backgroundColor: _red,
      ),
    );
  }
}
