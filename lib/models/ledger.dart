class Ledger {
  final String userName;
  final DateTime drawDate;
  final double paid;
  final String outstandingAmount;
  final String lateFees;
  final String creditScore;

  const Ledger({
    this.userName,
    this.drawDate,
    this.paid,
    this.outstandingAmount,
    this.lateFees,
    this.creditScore,
  });

  Ledger.fromJson(Map<String, dynamic> json)
      : userName = json['from_user']['name'],
        creditScore = json['credit_score'],
        paid = double.parse(json['paid'].toString()),
        outstandingAmount = json['outstanding_amount'],
        lateFees = json['late_fees'],
        drawDate = DateTime.parse(json['draw_date']);
}
