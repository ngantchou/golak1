import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  NotificationCard({
    @required this.text,
    @required this.date,
    @required this.seen,
  });
  final String text;
  final String date;
  final bool seen;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          ListTile(
              title:Text(
            date,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade400,
            ),
          ),trailing: Icon(Icons.mail,color: seen?Colors.black12:Colors.lightBlueAccent,),)
        ],
      ),
    );
  }
}
