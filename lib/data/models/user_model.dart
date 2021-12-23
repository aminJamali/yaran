import 'package:flutter/material.dart';

class UserModel {
  int totalPayment;
  String id,
      nationalCode,
      mobileNumber,
      countryCallingCode,
      userName,
      firstName,
      lastName;

  UserModel(
      {this.id,
      this.nationalCode,
      this.mobileNumber,
      this.countryCallingCode,
      this.userName,
      this.totalPayment,
      this.firstName,
      this.lastName});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nationalCode: json['nationalCode'],
      mobileNumber: json['mobileNumber'],
      countryCallingCode: json['countryCallingCode'],
      userName: json['userName'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      totalPayment: json['totalPayment'],
    );
  }
}
