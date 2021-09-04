class DashBoardModel {
  final int memberCount, charityPrice, totalPrice, thisMonthPayments;

  DashBoardModel(
      {this.memberCount,
      this.charityPrice,
      this.totalPrice,
      this.thisMonthPayments});

  factory DashBoardModel.fromJson(Map<String, dynamic> json) {
    return DashBoardModel(
      memberCount: json['memberCount'],
      charityPrice: json['charityPrice'],
      totalPrice: json['totalPrice'],
      thisMonthPayments: json['thisMonthPayments'],
    );
  }
}
