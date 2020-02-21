import 'package:flutter/material.dart';

class RichStat extends StatelessWidget {
  RichStat({
    Key key,
    this.title,
    this.image,
    this.value,
  });
  final String title;
  final String image;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 8 * 2.0) * .3,
      height: 176,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Color(0xFF76D0B7),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '$title',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1,
            ),
          ),
          Image.asset(
            image,
            width: 62,
            height: 62,
            fit: BoxFit.contain,
          ),
          Text(
            '$value',
            style: TextStyle(
              fontSize: 14,
            ),
          ),

        ],
      ),
    );
  }
}
