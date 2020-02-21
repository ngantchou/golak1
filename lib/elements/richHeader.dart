import 'dart:math';

import 'package:flutter/material.dart';
import 'package:golak/elements/brandImage.dart';
import 'package:golak/store/notifiers/i18nNotifier.dart';
import 'package:provider/provider.dart';

/*
RichHeader(
  title: '',
)
 */
class RichHeader extends StatelessWidget {
  RichHeader({Key key, @required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    final i18nNotifier = Provider.of<I18nNotifier>(context);

    return Container(
      height: 236,
      child: Stack(
        children: <Widget>[
          Align(
            alignment:
                i18nNotifier.rtl ? Alignment.topRight : Alignment.topRight,
            child: Container(
              //child: Transform(
                //transform: Matrix4.rotationY(180),
                child: Image.asset(
                  'images/people@3x.png',
                  width: 276,
                  height: 236,
                ),
             // ),
            ),
          ),
          Align(
            alignment:
                i18nNotifier.rtl ? Alignment.centerRight : Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 32,
              ),
              child: BrandImage(),
            ),
          ),
          if (title != null)
            Positioned(
              bottom: 0,
              left: i18nNotifier.rtl ? 0 : 16,
              right: !i18nNotifier.rtl ? 0 : 16,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 21,
                  height: 1,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
