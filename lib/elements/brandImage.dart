import 'package:flutter/material.dart';

/*
BrandImage(
  isLarge: true,
)
*/
class BrandImage extends StatelessWidget {
  BrandImage({
    Key key,
    this.isLarge = false,
  }) : super(key: key);
  final bool isLarge;
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/golak@3x.png',
      width: isLarge ? 168.21 : 103.36,
      height: isLarge ? 113.2 : 69.56,
      fit: BoxFit.contain,
    );
  }
}
