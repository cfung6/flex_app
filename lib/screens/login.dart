import 'package:flex/screens/sign_up.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _username = '';
  String _password = '';

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _red = const Color(0xFFC13F4D);

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
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Username',
                    ),
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15.0),
                  TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'Password',
                      ),
                      obscureText: true,
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      }
                  ),
                ],
              ),
            ),
            ButtonBar(
              children: <Widget>[
                Text("Don't have an account?"),
                FlatButton(
                  textColor: _red,
                  child: Text('Sign up'),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => SignUp()));
                  },
                ),
              ],
            ),
            const SizedBox(height: 100.0),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            setState(() {
              _username = _usernameController.text;
              _password = _passwordController.text;
            });
          }
        },
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
