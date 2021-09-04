import 'package:flutter/material.dart';

class GetUserInfoDto {
  final String apiToken;
  final String searchText;
  final int pageNumber;

  GetUserInfoDto({this.apiToken, this.searchText, this.pageNumber});
}
