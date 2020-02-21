import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StyledLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.black12,
      child: Center(
        child: CupertinoActivityIndicator(radius: 12),
      ),
    );
  }
}
