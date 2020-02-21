class RecentActivity {
  final String title;
  final double amount;
  final DateTime paymentDate;

  const RecentActivity({
    this.title,
    this.amount,
    this.paymentDate,
  });

  RecentActivity.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        amount = double.parse(json['amount']),
        paymentDate = DateTime.parse(json['paymentDate']);

  Map<String, dynamic> toJson() => {
        'title': title,
        'amount': amount?.toString(),
        'paymentDate': paymentDate?.toString(),
      };
}
