// /payouts/upcoming_payouts/5d3597dc4dcd3f0017594901

class Payout {
  final String circleName;
  final double amount;
  final DateTime upcomingDate;

  const Payout({
    this.circleName,
    this.amount,
    this.upcomingDate,
  });

  Payout.fromJson(Map<String, dynamic> json)
      : circleName = json['circleName'],
        amount = json['amount'].toString()==null?0:json['amount'].toDouble(),
        upcomingDate = DateTime.parse(json['upcoming_date']);

  Map<String, dynamic> toJson() => {
        'circleName': circleName,
        'amount': amount,
        'upcoming_date': upcomingDate?.toString(),
      };
}
