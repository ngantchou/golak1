import 'package:pdf/widgets.dart';

class LightRichLedger extends StatelessWidget {
  @override
  Widget build(context) {
    final headers = [
      'User Name',
      'Draw Date',
      'Paid',
      'Outstanding Amount',
      'Late fees',
      'Credit Score',
    ];
    // final footers = [
    //   'Total',
    //   '',
    //   '',
    //   '',
    //   '',
    //   '\n',
    // ];
    final articles = [
      [
        'Alia',
        '07-06-2019',
        '\$100',
        '\$0',
        '\$2',
        '\$100',
      ],
      [
        'John',
        '07-06-2019',
        '\$100',
        '\$0',
        '\$2',
        '\$100',
      ],
      [
        'Noa',
        '07-06-2019',
        '\$100',
        '\$0',
        '\$2',
        '\$100',
      ],
    ];
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            for (final header in headers)
              Container(
                width: 99.78,
                height: 39.88,
                margin: EdgeInsets.all(3),
                alignment: Alignment.center,
                child: Text(
                  header,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    // fontWeight: FontWeight.w700,
                    // color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        for (final article in articles)
          Row(
            children: <Widget>[
              for (final value in article)
                Container(
                  width: 99.78,
                  height: 28.43,
                  margin: EdgeInsets.all(3),
                  alignment: Alignment.center,
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
