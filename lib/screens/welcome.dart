import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:golak/elements/brandImage.dart';
import 'package:golak/elements/language.dart';
import 'package:golak/elements/roundedButton.dart';
import 'package:golak/store/notifiers/authenticationNotifier.dart';
import 'package:golak/store/notifiers/i18nNotifier.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool isLangInitialized = false;
  bool navigated = false;

  @override
  Widget build(BuildContext context) {
    final _phoneHeight = MediaQuery.of(context).size.height;
    final authenticationNotifier = Provider.of<AuthenticationNotifier>(context);
    final i18nNotifier = Provider.of<I18nNotifier>(context);
    print(authenticationNotifier.accessToken );
   /* if (!navigated &&
        authenticationNotifier.accessToken != null &&
        authenticationNotifier.user != null)
      Timer.run(() {
        navigated = true;
        setState(() {});
        i18nNotifier.changeLanguage(context, null);
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/',
          (_) => false,
        );
      });
    else if (!isLangInitialized) {
      Timer.run(() {
        i18nNotifier.changeLanguage(context, null);
        setState(() {
          isLangInitialized = true;
        });
      });

    }*/
    Timer.run(() {
      i18nNotifier.changeLanguage(context, null);
      setState(() {
        isLangInitialized = true;
      });
    });

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 25),
        children: <Widget>[
          SizedBox(height: _phoneHeight * .14),
          BrandImage(isLarge: true),
          SizedBox(height: _phoneHeight * .10),
          RoundedButton(
            label: FlutterI18n.translate(context, "login"),
            labelSize: 22,
            onPressed: () => Navigator.of(context).pushNamed('/login'),
          ),
          SizedBox(height: 25),
          RoundedButton(
            label: FlutterI18n.translate(context, "sign_up"),
            labelSize: 22,
            onPressed: () => Navigator.of(context).pushNamed('/signup'),
          ),
          SizedBox(height: _phoneHeight * .10),
          Language(initialLang: i18nNotifier.currentLang),
        ],
      ),
    );
  }
}

class RichCheckBox {}
