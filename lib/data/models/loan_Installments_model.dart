import 'package:flutter/material.dart';

class LoanInstallmentsModel {
  final int id, payVal, loanId;
  final String installmentDate, payDate, name;
  final List<dynamic> installmentImages;

  LoanInstallmentsModel(
      {this.id,
      this.name,
      this.payVal,
      this.loanId,
      this.installmentDate,
      this.payDate,
      this.installmentImages});

  // static LoanInstallmentsModel fromMap(Map<String, dynamic> map) {
  //   return LoanInstallmentsModel(
  //       map['id'],
  //       map['payVal'],
  //       map['payDate'],
  //       map['isCharity'],
  //       map['imgFileUrls'],
  //       map['firstName'],
  //       map['lastName'],
  //       map['nationalCode'],
  //       map['applicationUserId']);
  // }

  factory LoanInstallmentsModel.fromJson(Map<String, dynamic> json) {
    return LoanInstallmentsModel(
      id: json['id'],
      payDate: json['payDate'],
      payVal: json['payVal'],
      installmentDate: json['installmentDate'],
      installmentImages: json['installmentImages'],
      loanId: json['loanId'],
    );
  }
}
