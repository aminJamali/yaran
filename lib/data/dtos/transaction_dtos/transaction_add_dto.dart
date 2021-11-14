import 'dart:io';

class TransactionAddDto {
  final int id;
  final int payVal;
  final String payDate, userId;
  final bool isCharity;
  final List<dynamic> imageArray;
  final String apiToken;

  TransactionAddDto({
    this.payVal,
    this.payDate,
    this.userId,
    this.isCharity,
    this.imageArray,
    this.apiToken,
    this.id,
  });
}
