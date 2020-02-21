import 'package:flutter/material.dart';

/*
CentredTitle(
  text: 'Login',
)
*/
class CentredTitle extends StatelessWidget {
  CentredTitle({Key key, @required this.text}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF76D0B7),
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
