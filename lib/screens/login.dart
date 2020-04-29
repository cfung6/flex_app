import 'package:flex/screens/sign_up.dart';
import 'package:flex/services/auth.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _email = '';
  String _password = '';
  String _error = '';

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final Auth _auth = Auth();

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
                    controller: _emailController,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Email',
                    ),
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'Please enter your email';
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
                      }),
                ],
              ),
            ),
            ButtonBar(
              children: <Widget>[
                Text("Don't have an account?"),
                FlatButton(
                  textColor: Theme
                      .of(context)
                      .buttonTheme
                      .colorScheme
                      .primary,
                  child: Text('Sign up'),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => SignUp()));
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 12.0,
            ),
            Text(
              _error,
              style: TextStyle(color: Colors.red, fontSize: 14.0),
            ),
            const SizedBox(height: 100.0),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            setState(() {
              _email = _emailController.text;
              _password = _passwordController.text;
            });

            dynamic result = await _auth.signInWithEmail(_email, _password);
            if (result == null) {
              setState(() {
                _error = 'Incorrect email or password';
              });
            }

            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (_) => Home()));
          }
        },
        label: const Text('Sign in'),
        icon: Image.asset(
          'assets/images/login.png',
          width: 25.0,
          height: 25.0,
        ),
        backgroundColor: Theme
            .of(context)
            .buttonTheme
            .colorScheme
            .primary,
      ),
    );
  }
}
