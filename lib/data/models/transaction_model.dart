import 'package:flutter/material.dart';

class TransactionModel {
  String payDate, applicationUserId, firstName, lastName, nationalCode;
  bool isCharity;
  int payVal;
  int id;
  List<dynamic> imgFileUrls;
  TransactionModel(
      {this.id,
      this.payVal,
      this.payDate,
      this.isCharity,
      this.imgFileUrls,
      this.nationalCode,
      this.applicationUserId,
      this.firstName,
      this.lastName});
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      payVal: json['payVal'],
      payDate: json['payDate'],
      firstName: json['firstName'],
      nationalCode: json['nationalCode'],
      lastName: json['lastName'],
      isCharity: json['isCharity'],
      imgFileUrls: json['imgFileUrls'],
      applicationUserId: json['applicationUserId'],
    );
  }
}
