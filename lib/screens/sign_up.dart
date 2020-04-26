import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
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
                decoration: InputDecoration(
                  labelText: 'Display name',
                  filled: true,
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  filled: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
