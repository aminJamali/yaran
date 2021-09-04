import 'package:flutter/material.dart';

class GetLoanDto {
  final String apiToken;
  final int pageNumber;
  final String sort, search, getDate;

  GetLoanDto(
      {this.apiToken, this.pageNumber, this.sort, this.search, this.getDate});
}
