import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:golak/elements/brandImage.dart';
import 'package:golak/elements/centeredTitle.dart';
import 'package:golak/elements/golakIcons.dart';
import 'package:golak/elements/inlineButton.dart';
import 'package:golak/elements/richCheckbox.dart';
import 'package:golak/elements/roundedButton.dart';
import 'package:golak/elements/roundedTextFormField.dart';
import 'package:golak/elements/styledAlertDialog.dart';
import 'package:golak/elements/styledLoader.dart';
import 'package:golak/models/user.dart';
import 'package:golak/store/notifiers/authenticationNotifier.dart';
import 'package:golak/store/notifiers/i18nNotifier.dart';
import 'package:golak/store/notifiers/notificationsNotifier.dart';
import 'package:provider/provider.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:golak/elements/agreement.dart' as fullDialog;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final i18nNotifier = Provider.of<I18nNotifier>(context);
    final notificationsNotifier = Provider.of<NotificationsNotifier>(context);

    final _phoneHeight = MediaQuery.of(context).size.height;
    final authenticationNotifier = Provider.of<AuthenticationNotifier>(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ListView(
            padding: EdgeInsets.symmetric(horizontal: 25),
            children: <Widget>[
              SizedBox(height: 45),
              BrandImage(isLarge: true),
              SizedBox(height: 42),
              CentredTitle(
                text: FlutterI18n.translate(context, "login"),
              ),
              SizedBox(height: 4),
              RoundedTextFormField(
                controller: _emailController,
                label: FlutterI18n.translate(context, 'email'),
                icon: GolakIcons.email,
              ),
              SizedBox(height: 10),
              RoundedTextFormField(
                controller: _passwordController,
                obscureText: true,
                label: FlutterI18n.translate(context, 'password'),
                icon: GolakIcons.lock,
              ),
              SizedBox(height: 5),
              RichCheckbox(
                label: FlutterI18n.translate(context, 'remember_me'),
                onChanged: (_) {
                  authenticationNotifier.rememberMe =
                      !authenticationNotifier.rememberMe;
                },
                value: authenticationNotifier.rememberMe,
              ),
              SizedBox(height: 30),
              GestureDetector(
                child: Text("By signing up and logging into this app, you are agreeing and acknowledging to Golak's Privacy Policy",
                  style: TextStyle(color: Colors.blue),
                ),
                onTap: () {
                  _openAgreeDialog(context);
                },
              ),
              SizedBox(height: 40),
              RoundedButton(
                  label: FlutterI18n.translate(context, 'submit'),
                  labelSize: 22,
                  onPressed: () async {
                    if (_emailController.text.length >= 6 &&
                        _passwordController.text.length >= 6) {
                      final User user = await authenticationNotifier.login(
                          email: _emailController.text,
                          password: _passwordController.text);
                      if (user != null) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/',
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
                                content: FlutterI18n.translate(
                                    context, 'incorrect_email_or_password'),
                                cancel: false,
                                callback: () async {
                                  Navigator.pop(context);
                                },
                              );
                            });
                      }
                    }
                  }),

              SizedBox(height: _phoneHeight * .09),
              InlineButton(
                  leadingLabel:
                      FlutterI18n.translate(context, 'dont_have_an_account'),
                  label: FlutterI18n.translate(context, 'sign_up'),
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/signup',
                      (_) => false,
                    );
                  }),
              SizedBox(height: 30),
            ],
          ),
          if (Provider.of<AuthenticationNotifier>(context).loading)
            StyledLoader(),
        ],
      ),
    );
  }
  Future _openAgreeDialog(context) async {
    String result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return fullDialog.Agreement();
        },
        //true to display with a dismiss button rather than a return navigation arrow
        fullscreenDialog: true));
    if (result != null) {
      letsDoSomething(result, context);
    } else {
      print('you could do another action here if they cancel');
    }
  }

  letsDoSomething(String result, context) {
    print(result);//prints 'User Agreed'
  }
}
