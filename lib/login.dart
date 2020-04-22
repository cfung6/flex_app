import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 60.0),
            Column(
              children: <Widget>[
                Image.asset(
                  'assets/images/jordan_one_icon.png',
                  width: 100.0,
                  height: 100.0,
                ),
                Text(
                  'FLEX',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 60.0),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 15.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  textColor: Color(0xFFC13F4D),
                  child: Text('Clear'),
                  onPressed: () {
                    _usernameController.clear();
                    _passwordController.clear();
                  },
                ),
                RaisedButton(
                  color: Color(0xFFC13F4D),
                  child: Text('Sign up'),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 100.0),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text('Login'),
        icon: Image.asset(
          'assets/images/login.png',
          width: 25.0,
          height: 25.0,
        ),
        backgroundColor: Color(0xFFC13F4D),
      ),
    );
  }
}
