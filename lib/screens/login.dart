import 'package:flex/models/user.dart';
import 'package:flex/screens/sign_up.dart';
import 'package:flex/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
            Center(
              child: Text(
                _error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
                textAlign: TextAlign.center,
              ),
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

            try {
              User user = await _auth.signInWithEmail(_email, _password);

              if (user != null) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => Home()), (r) => false);
              }
            } catch (e) {
              setState(() {
                if (!(e is PlatformException)) {
                  _error = 'Unexpected error has occurred. Try again later.';
                  return;
                }

                switch (e.code) {
                  case 'ERROR_TOO_MANY_REQUESTS':
                    {
                      _error =
                      'Too many unsuccessful login attempts. Please try again later.';
                      return;
                    }
                  default:
                    {
                      _error = 'Incorrect email or password.';
                      return;
                    }
                }
              });
            }
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
