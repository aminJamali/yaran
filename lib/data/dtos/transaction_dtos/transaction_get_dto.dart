import 'package:flutter/material.dart';

class TransactionGetDto {
  final String apiToken;
  final int pageNumber;
  final String sort, search;

  TransactionGetDto({this.apiToken, this.pageNumber, this.search, this.sort});
}
