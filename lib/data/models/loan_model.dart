import 'package:flutter/material.dart';
import 'package:moordak/data/models/loan_Installments_model.dart';

class LoanModel {
  final int id,
      loanVal,
      installmentCount,
      installmentMonthPeriod,
      loanValueSortField,
      installmentVal;
  final String getDate, applicationUserId, firstName, lastName, nationalCode;
  final bool isFinished;
  final List<LoanInstallmentsModel> loanInstallments;

  LoanModel({
    this.loanInstallments,
    this.id,
    this.loanVal,
    this.installmentCount,
    this.installmentMonthPeriod,
    this.loanValueSortField,
    this.installmentVal,
    this.getDate,
    this.applicationUserId,
    this.firstName,
    this.lastName,
    this.nationalCode,
    this.isFinished,
  });

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    return LoanModel(
      id: json['id'],
      loanVal: json['loanVal'],
      applicationUserId: json['applicationUserId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      getDate: json['getDate'],
      installmentCount: json['installmentCount'],
      installmentMonthPeriod: json['installmentMonthPeriod'],
      installmentVal: json['installmentVal'],
      isFinished: json['isFinished'],
      loanValueSortField: json['loanValueSortField'],
      nationalCode: json['nationalCode'],
      loanInstallments: json['loanInstallments'] != null
          ? json['loanInstallments']
              .map<LoanInstallmentsModel>(
                  (json) => LoanInstallmentsModel.fromJson(json))
              .toList()
          : null,
    );
  }
}
