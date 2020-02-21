import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:golak/elements/brandImage.dart';
import 'package:golak/elements/centeredTitle.dart';
import 'package:golak/elements/golakIcons.dart';
import 'package:golak/elements/roundedButton.dart';
import 'package:golak/elements/roundedTextFormField.dart';
import 'package:golak/elements/styledAlertDialog.dart';
import 'package:golak/elements/styledLoader.dart';
import 'package:golak/models/country.dart';
import 'package:golak/screens/createCircle.dart';
import 'package:golak/store/notifiers/authenticationNotifier.dart';
import 'package:golak/store/notifiers/i18nNotifier.dart';
import 'package:provider/provider.dart';
import 'package:regexed_validator/regexed_validator.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  bool validated = false;

  String _emailValidator(_) {
    if (_emailController.text.length < 1) {
      return 'Email is required';
    } else if (!validator.email(_emailController.text)) {
      return 'Enter a valide email address';
    }
    return null;
  }

  String _passwordValidator(_) {
    if (_passwordController.text.length < 1) {
      return 'Password is required';
    } else if (!validator.password(_passwordController.text)) {
      return 'Enter a valide password';
    }
    return null;
  }

  String _usernameValidator(_) {
    if (_usernameController.text.length < 1) {
      return 'Username is required';
    }
    return null;
  }

  String _phoneValidator(_) {
    if (_phoneController.text.length < 1) {
      return 'Phone is required';
    } else if (!validator.phone(_phoneController.text)) {
      return 'Enter a valide phone';
    }
    return null;
  }

  List<Country> countries = [];
  String _country;
  void _pickCountry(String country) {
    setState(() {
      _country = country;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authenticationNotifier = Provider.of<AuthenticationNotifier>(context);
    final i18nNotifier = Provider.of<I18nNotifier>(context);
    if (countries.length == 0) {
      Timer.run(() async {
        String $countriesString = await DefaultAssetBundle.of(context)
            .loadString("countries/countries.json");
        final $countriesJson = json.decode($countriesString);
        for (final $countryJson in $countriesJson)
          countries.add(Country.fromJson($countryJson));
        _country = countries.first.code;
        setState(() {});
      });
    }
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ListView(
            padding: EdgeInsets.symmetric(horizontal: 25),
            children: <Widget>[
              SizedBox(height: 45),
              BrandImage(isLarge: true),
              SizedBox(height: 42),
              CentredTitle(text: FlutterI18n.translate(context, 'sign_up')),
              SizedBox(height: 4),
              RoundedTextFormField(
                controller: _usernameController,
                label: FlutterI18n.translate(context, 'name'),
                icon: GolakIcons.person,
                validated: validated,
                validator: _usernameValidator,
              ),
              SizedBox(height: 10),
              RoundedTextFormField(
                controller: _passwordController,
                label: FlutterI18n.translate(context, 'password'),
                icon: GolakIcons.lock,
                obscureText: true,
                validated: validated,
                validator: _passwordValidator,
              ),
              SizedBox(height: 10),
              RoundedTextFormField(
                controller: _emailController,
                label: FlutterI18n.translate(context, 'email'),
                icon: GolakIcons.email,
                validated: validated,
                validator: _emailValidator,
              ),
              SizedBox(height: 10),
              RoundedTextFormField(
                controller: _phoneController,
                label: FlutterI18n.translate(context, 'phone'),
                icon: GolakIcons.phone,
                validated: validated,
                validator: _phoneValidator,
              ),
              SizedBox(height: 10),
              StyledRichDropdown(
                callback: _pickCountry,
                label: FlutterI18n.translate(context, 'country'),
                icon: GolakIcons.country,
                options: <Option>[
                  for (final country in countries)
                    Option(
                      value: country.code,
                      text: country.name,
                    ),
                ],
              ),
              SizedBox(height: 40),
              RoundedButton(
                label: FlutterI18n.translate(context, 'submit'),
                labelSize: 22,
                onPressed: () async {
                  if (_usernameValidator(null) == null &&
                      _phoneValidator(null) == null &&
                      _passwordValidator(null) == null &&
                      _emailValidator(null) == null &&
                      _country != null) {
                    final $user = await authenticationNotifier.signup(
                      email: _emailController.text,
                      password: _passwordController.text,
                      username: _usernameController.text,
                      phone: _phoneController.text,
                      country: _country,
                    );
                    if ($user != null) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login',
                        (_) => false,
                      );
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StyledAlertDialog(
                              label: FlutterI18n.translate(context, 'ok'),
                              title: FlutterI18n.translate(
                                  context, 'connection_error'),
                              content: '',
                              cancel: false,
                              callback: () async {
                                Navigator.pop(context);
                              },
                            );
                          });
                    }
                  } else {
                    validated = true;
                    setState(() {});
                  }
                },
              ),
              SizedBox(height: 30),
            ],
          ),
          if (Provider.of<AuthenticationNotifier>(context).loading)
            StyledLoader(),
        ],
      ),
    );
  }
}
