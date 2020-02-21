import 'dart:math';

import 'package:flutter/material.dart';
import 'package:golak/elements/golakIcons.dart';

/*
Header(
  title: 'Create New Circle',
)
*/
class Header extends StatelessWidget {
  Header({Key key, @required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomRect(),
      child: Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(
          bottom: 21,
          left: 16,
          right: 16,
        ),
        height: 130,
        decoration: BoxDecoration(
          color: Color(0xFF76D0B7),
        ),
        child: Row(
          children: <Widget>[
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GolakIcon(GolakIcons.backArrow),
              ),
            ),
            Spacer(),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

class CustomRect extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // path.lineTo(0.0, size.height);
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.arcTo(
      Rect.fromLTRB(
        -size.width,
        -size.height * 2.5,
        size.width * 2,
        size.height * 1,
      ),
      0,
      pi,
      false,
    );
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomRect oldClipper) => false;
}
