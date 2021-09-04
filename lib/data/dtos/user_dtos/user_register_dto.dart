import 'package:flutter/material.dart';

class UserRegisterDto {
  final String nationalCode,
      mobileNumber,
      roleName,
      firstName,
      lastName,
      id,
      fatherName,
      email,
      apiToken;

  UserRegisterDto(
      {this.nationalCode,
      this.mobileNumber,
      this.roleName,
      this.firstName,
      this.id,
      this.lastName,
      this.fatherName,
      this.email,
      this.apiToken});
}
