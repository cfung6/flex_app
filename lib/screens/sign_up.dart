import 'dart:developer';

import 'package:flex/models/user.dart';
import 'package:flex/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _loading = false;

  String _displayName = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  String _displayNameError; //to ensure uniqueness of display names
  String _emailError; //to ensure no malformed or duplicate emails
  String _passwordError; //to ensure strong enough password

  final _formKey = GlobalKey<FormState>();

  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            children: <Widget>[
              const SizedBox(height: 30.0),
              Center(
                child: Text(
                  'Register a FLEX account',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              const SizedBox(height: 50.0),
              TextFormField(
                controller: _displayNameController,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Display name (what other users see)',
                  filled: true,
                ),
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Please enter a display name';
                  }
                  return _displayNameError;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _emailController,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Email',
                  filled: true,
                ),
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Please enter your email';
                  }
                  return _emailError;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _passwordController,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                ),
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Please enter your password';
                  }
                  return _passwordError;
                },
                obscureText: true,
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _confirmPasswordController,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  filled: true,
                ),
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Please confirm your password';
                  }
                  return _passwordError;
                },
                obscureText: true,
              ),
              const SizedBox(height: 40.0),
              Center(
                child: RaisedButton(
                  color: Theme
                      .of(context)
                      .buttonTheme
                      .colorScheme
                      .primary,
                  textTheme: Theme
                      .of(context)
                      .buttonTheme
                      .textTheme,
                  child: Text('Register'),
                  onPressed: () async {
                    _validateAllFields();
                    if (_formKey.currentState.validate()) {
                      setState(() => _loading = true);
                      User user = await _tryToRegister();
                      setState(() => _loading = false);
                      if (_formKey.currentState.validate() && user != null) {
//                        log('current ${Provider
//                            .of<User>(context, listen: false)
//                            .userInfo
//                            .displayName}');
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => Home()),
                                (r) => false);
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //local validation
  void _validateAllFields() {
    //TODO: Validate uniqueness of display name
    setState(() {
      _displayName = _displayNameController.text.trim();
      _email = _emailController.text.trim();
      _password = _passwordController.text;
      _confirmPassword = _confirmPasswordController.text;

      _displayNameError = null;
      _emailError = null;
      _passwordError = null;

      if (_password != _confirmPassword) {
        _passwordError = 'Passwords do not match up';
        return;
      }
    });
  }

  //validation from firebase
  Future<User> _tryToRegister() async {
    try {
      User user = await _auth.register(_email, _password, _displayName);
      user = await _auth.updateDisplayName(_displayName);
      return user;
    } catch (e) {
      if (!(e is PlatformException)) {
        log(e.toString());
        return null;
      }
      setState(() {
        _loading = false;
        switch (e.code) {
          case "ERROR_INVALID_EMAIL":
            {
              _emailError = 'This email is invalid';
              break;
            }
          case "ERROR_EMAIL_ALREADY_IN_USE":
            {
              _emailError = 'This email is already in use';
              break;
            }
          case "ERROR_WEAK_PASSWORD":
            {
              _passwordError = 'This password is too weak';
              break;
            }
          default:
            break;
        }
      });
      return null;
    }
  }
}
