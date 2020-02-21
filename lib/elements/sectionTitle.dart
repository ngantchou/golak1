import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class SectionTitle extends StatelessWidget {
  SectionTitle({
    Key key,
    @required this.text,
    this.fontSize,
    this.isExpandable = false,
    this.onPressed,
    this.color,
    this.length,
  }) : super(key: key);
  final String text;
  final bool isExpandable;
  final onPressed;
  final double fontSize;
  final color;
  final int length;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          Text(
            text,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: fontSize ?? 18,
              fontWeight: FontWeight.w700,
              color: color ?? Colors.black,
              height: 1,
            ),
          ),
          if (isExpandable) ...[
            Spacer(),
            RawMaterialButton(
              onPressed: onPressed ?? () {},
              child: Text(
                '${FlutterI18n.translate(context, "see_all")} ($length)',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF76D0B7),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
