import 'package:flutter/material.dart';

class AddLoanDto {
  final int loanVal,
      installmentCount,
      installmentMonthPeriod,
      installmentVal,
      id;
  final String getDate, applicationUserId, apiToken, firstName, lastName;
  final bool isFinished;

  AddLoanDto(
      {this.loanVal,
      this.firstName,
      this.lastName,
      this.id,
      this.installmentCount,
      this.installmentMonthPeriod,
      this.installmentVal,
      this.apiToken,
      this.getDate,
      this.isFinished,
      this.applicationUserId});
}
