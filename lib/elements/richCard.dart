import 'package:flutter/material.dart';

/*
RichCard(
  title: 'Vacation',
  subTitle: '23  July, 2019',
  trailing: '\$1000',
),
*/
class RichCard extends StatelessWidget {
  RichCard({
    Key key,
    @required this.title,
    @required this.subTitle,
    @required this.trailing,
    this.isLightTitle: false,
  }) : super(key: key);
  final String title;
  final String subTitle;
  final String trailing;
  final bool isLightTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 70,
      padding: EdgeInsets.only(top: 12, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 4),
            color: Colors.black.withOpacity(.1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width - 150,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          isLightTitle ? FontWeight.w500 : FontWeight.w700,
                      height: 1,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  subTitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFFAAA9AE),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Text(
            '\$${trailing ?? '0'}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF76D0B7),
            ),
          ),
          SizedBox(width: 8 * 3.0),
        ],
      ),
    );
  }
}
