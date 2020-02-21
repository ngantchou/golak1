import 'package:flutter/material.dart';
import 'package:golak/elements/golakIcons.dart';
import 'package:golak/store/notifiers/i18nNotifier.dart';
import 'package:provider/provider.dart';

/*
RoundedTextFormField(
  label: 'Username',
  icon: GolakIcons.person,
),
*/
class RoundedTextFormField extends StatelessWidget {
  RoundedTextFormField({
    Key key,
    @required this.label,
    @required this.icon,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.initialValue,
    this.accentColor,
    this.validator,
    this.validated = false,
  }) : super(key: key);
  final String label;
  final String icon;
  final bool obscureText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String initialValue;
  final Color accentColor;
  final validator;
  final bool validated;
  @override
  Widget build(BuildContext context) {
    final i18nNotifier = Provider.of<I18nNotifier>(context);

    return Container(
      height: 52 + 14.0,
      child: Stack(
        alignment: i18nNotifier.rtl ? Alignment.topRight : Alignment.topLeft,
        children: <Widget>[
          Positioned(
            top: 14,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 75,
              child: TextFormField(
                obscureText: obscureText,
                controller: controller,
                initialValue: initialValue,
                keyboardType: keyboardType ?? TextInputType.text,
                style: TextStyle(color: accentColor ?? Color(0xFF111111)),
                decoration: InputDecoration(
                  errorMaxLines: 1,
                  helperText: ' ',
                  fillColor: Color(0xFFFF6464),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: (validated && (validator(controller) != null))
                          ? Color(0xFFFF6464)
                          : (accentColor ?? Color(0xFF686868)),
                    ),
                    borderRadius: BorderRadius.circular(
                      50,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: (validated && validator(controller) != null)
                          ? Color(0xFFFF6464)
                          : (accentColor ?? Color(0xFF686868)),
                    ),
                    borderRadius: BorderRadius.circular(
                      50,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: i18nNotifier.rtl ? null : 32,
            right: !i18nNotifier.rtl ? null : 32,
            child: Container(
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GolakIcon(
                    icon,
                    color: (validated && validator(controller) != null)
                        ? Color(0xFFFF6464)
                        : (accentColor ?? Color(0xFF686868)),
                    size: 21,
                  ),
                  SizedBox(width: 2),
                  Text(
                    label,
                    style: TextStyle(
                      color: (validated && validator(controller) != null)
                          ? Color(0xFFFF6464)
                          : (accentColor ?? Color(0xFF686868)),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
