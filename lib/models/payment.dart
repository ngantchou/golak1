// /payments/upcoming_payments/5d3597dc4dcd3f0017594901

class Payment {
  final String circleName;
  final double amount;
  final DateTime upcomingDate;

  const Payment({
    this.circleName,
    this.amount,
    this.upcomingDate,
  });

  Payment.fromJson(Map<String, dynamic> json)
      : circleName = json['circleName'],
        amount = double.parse(json['amount'].toString()),
        upcomingDate = DateTime.parse(json['upcoming_date']);

  Map<String, dynamic> toJson() => {
        'circleName': circleName,
        'amount': amount,
        'upcoming_date': upcomingDate?.toString(),
      };
}
