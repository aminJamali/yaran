import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:moordak/data/dtos/dashboard_dtos/dashborad_dto.dart';
import 'package:moordak/data/dtos/installment_dtos/do_installment.dart';
import 'package:moordak/data/dtos/installment_dtos/paid_installment.dart';
import 'package:moordak/data/dtos/loan_dtos/add_loan_dto.dart';
import 'package:moordak/data/dtos/loan_dtos/delete_loan_dto.dart';
import 'package:moordak/data/dtos/loan_dtos/get_loan_dto.dart';
import 'package:moordak/data/dtos/transaction_dtos/transaction_add_dto.dart';
import 'package:moordak/data/dtos/transaction_dtos/transaction_delete_dto.dart';
import 'package:moordak/data/dtos/transaction_dtos/transaction_get_dto.dart';
import 'package:moordak/data/dtos/user_dtos/get_user_info_dto.dart';
import 'package:moordak/data/dtos/user_dtos/user_login_dto.dart';
import 'package:moordak/data/dtos/user_dtos/user_register_dto.dart';
import 'package:moordak/presentation/consts/strings.dart';

class MourdakApi {
  Dio _dio = new Dio();
  // user api
  Future<http.Response> getUserInfo(GetUserInfoDto getUserInfoDto) async {
    Map<String, String> requestHeaders = {
      //'Content-type': 'application/json',
      'Authorization': 'bearer ${getUserInfoDto.apiToken}'
    };
    try {
      final response = await http.get(
        '${mainApi}/user-management?limit=${10}&search=${getUserInfoDto.searchText}',
        headers: requestHeaders,
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 401) {
        throw '401';
      } else {
        throw "operation failed";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<http.Response> getAllUsers(GetUserInfoDto getUserInfoDto) async {
    Map<String, String> requestHeaders = {
      //'Content-type': 'application/json',
      'Authorization': 'bearer ${getUserInfoDto.apiToken}'
    };
    try {
      final response = await http.get(
        '${mainApi}/user-management?limit=${20}&offset=${getUserInfoDto.pageNumber}',
        headers: requestHeaders,
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 401) {
        throw '401';
      } else {
        throw "operation failed";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<http.Response> getAllUsersBySearch(
      GetUserInfoDto getUserInfoDto) async {
    Map<String, String> requestHeaders = {
      //'Content-type': 'application/json',
      'Authorization': 'bearer ${getUserInfoDto.apiToken}'
    };
    try {
      final response = await http.get(
        '${mainApi}/user-management?limit=${20}&offset=${getUserInfoDto.pageNumber}&search=${getUserInfoDto.searchText}',
        headers: requestHeaders,
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 401) {
        throw '401';
      } else {
        throw "operation failed";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<http.Response> userLogin(UserLoginDto userLoginDto) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
    };

    final response = await http.post(
      '${mainApi}user-management/login',
      body: jsonEncode(
        {
          "username": userLoginDto.userName,
          "password": userLoginDto.password,
        },
      ),
      headers: requestHeaders,
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 500) {
      return response;
    } else
      throw 'operation failed';
  }

  Future<http.Response> userRegister(UserRegisterDto userRegisterDto) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': 'bearer ${userRegisterDto.apiToken}'
    };
    try {
      final response = await http.post(
        '${mainApi}user-management/register-user',
        body: jsonEncode(
          {
            "nationalCode": userRegisterDto.nationalCode,
            "mobileNumber": userRegisterDto.mobileNumber,
            "roleName": userRegisterDto.roleName,
            "firstName": userRegisterDto.firstName,
            "lastName": userRegisterDto.lastName,
            "fatherName": userRegisterDto.fatherName,
            "email": userRegisterDto.email,
          },
        ),
        headers: requestHeaders,
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 401) {
        throw '401';
      } else {
        throw "operation failed";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> userChangePassword(FormData formData) async {
    final response = await http.put('${mainApi}user-management/change-password',
        body: formData);

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      return responseBody;
    } else
      throw 'operation failed';
  }

  // transaction api
  Future<Response> transactionInsert(
      TransactionAddDto transactionAddDto) async {
    _dio.options.headers["Authorization"] =
        "bearer ${transactionAddDto.apiToken}";
    FormData _transactionInsertDio = FormData.fromMap(
      {
        'PayVal': transactionAddDto.payVal,
        'PayDate': transactionAddDto.payDate,
        'IsCharity': transactionAddDto.isCharity,
        'ImgFiles': transactionAddDto.imageArray.length > 0
            ? transactionAddDto.imageArray
            : null,
        'ApplicationUserId': transactionAddDto.userId,
      },
    );
    try {
      final response = await _dio.post(
        '${mainApi}routine-payments',
        data: _transactionInsertDio,
        options: Options(
          followRedirects: false,
          // will not throw errors
          validateStatus: (status) => true,
        ),
      );
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200 || response.statusCode == 500) {
        return response;
      } else if (response.statusCode == 401) {
        throw '401';
      } else {
        throw "operation failed";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> transactionEdit(TransactionAddDto transactionAddDto) async {
    _dio.options.headers["Authorization"] =
        "bearer ${transactionAddDto.apiToken}";
    FormData _transactionInsertDio = FormData.fromMap(
      {
        'PayVal': transactionAddDto.payVal,
        'PayDate': transactionAddDto.payDate,
        'IsCharity': transactionAddDto.isCharity,
        'ImgFiles': transactionAddDto.imageArray.length > 0
            ? transactionAddDto.imageArray
            : null,
      },
    );
    try {
      final response = await _dio.put(
        '${mainApi}routine-payments/${transactionAddDto.id}',
        data: _transactionInsertDio,
        options: Options(
          followRedirects: false,
          // will not throw errors
          validateStatus: (status) => true,
        ),
      );
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200 || response.statusCode == 500) {
        return response;
      } else if (response.statusCode == 401) {
        throw '401';
      } else {
        throw "operation failed";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<http.Response> getAllTransactions(
      TransactionGetDto transactionGetDto) async {
    Map<String, String> requestHeaders = {
      'Authorization': 'bearer ${transactionGetDto.apiToken}'
    };
    try {
      final response = await http.get(
        '${mainApi}routine-payments?limit=${20}&offset=${transactionGetDto.pageNumber}',
        headers: requestHeaders,
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 401) {
        throw '401';
      } else {
        throw "operation failed";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<http.Response> getAllTransactionsBySearch(
      TransactionGetDto transactionGetDto) async {
    Map<String, String> requestHeaders = {
      'Authorization': 'bearer ${transactionGetDto.apiToken}'
    };
    try {
      final response = await http.get(
        '${mainApi}routine-payments?limit=${20}&offset=${transactionGetDto.pageNumber}&search=${transactionGetDto.search}',
        headers: requestHeaders,
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 401) {
        throw '401';
      } else {
        throw "operation failed";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> getTransactionById(id) async {
    final response = await http.get('${mainApi}routine-payments/${id}');

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      return responseBody;
    } else
      throw 'operation failed';
  }

  Future<http.Response> transactionDelete(
      TransactionDeleteDto transactionDeleteDto) async {
    Map<String, String> requestHeaders = {
      'Authorization': 'bearer ${transactionDeleteDto.apiToken}'
    };
    try {
      final response = await http.delete(
          '${mainApi}routine-payments/${transactionDeleteDto.id}',
          headers: requestHeaders);
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 401) {
        throw '401';
      } else {
        throw "operation failed";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // loan api
  Future<http.Response> loanEdit(AddLoanDto loanAddDto) async {
    Map<String, String> requestHeaders = {
      'Authorization': 'bearer ${loanAddDto.apiToken}',
      'Content-type': 'application/json',
    };

    try {
      final response = await http.put(
        '${mainApi}loans/${loanAddDto.id}',
        body: json.encode(
          {
            "loanVal": loanAddDto.loanVal,
            "installmentCount": loanAddDto.installmentCount,
            "installmentMonthPeriod": loanAddDto.installmentMonthPeriod,
            "installmentVal": loanAddDto.installmentVal,
            "getDate": loanAddDto.getDate,
            "isFinished": loanAddDto.isFinished,
            "applicationUserId": loanAddDto.applicationUserId
          },
        ),
        headers: requestHeaders,
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 401) {
        throw '401';
      } else {
        throw "operation failed";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<http.Response> loanInsert(AddLoanDto loanAddDto) async {
    Map<String, String> requestHeaders = {
      'Authorization': 'bearer ${loanAddDto.apiToken}',
      'Content-type': 'application/json',
    };

    try {
      final response = await http.post(
        '${mainApi}loans',
        body: json.encode(
          {
            "loanVal": loanAddDto.loanVal,
            "installmentCount": loanAddDto.installmentCount,
            "installmentMonthPeriod": loanAddDto.installmentMonthPeriod,
            "installmentVal": loanAddDto.installmentVal,
            "getDate": loanAddDto.getDate,
            "isFinished": loanAddDto.isFinished,
            "applicationUserId": loanAddDto.applicationUserId
          },
        ),
        headers: requestHeaders,
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 401) {
        throw '401';
      } else {
        throw "operation failed";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<http.Response> getAllloans(GetLoanDto getLoanDto) async {
    Map<String, String> requestHeaders = {
      'Authorization': 'bearer ${getLoanDto.apiToken}'
    };
    try {
      final response = await http.get(
        '${mainApi}loans?limit=${20}&offset=${getLoanDto.pageNumber}',
        headers: requestHeaders,
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 401) {
        throw '401';
      } else {
        throw "operation failed";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<http.Response> getAllloansBySearch(GetLoanDto getLoanDto) async {
    Map<String, String> requestHeaders = {
      'Authorization': 'bearer ${getLoanDto.apiToken}'
    };
    try {
      final response = await http.get(
        '${mainApi}loans?limit=${20}&offset=${getLoanDto.pageNumber}&search=${getLoanDto.search}',
        headers: requestHeaders,
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 401) {
        throw '401';
      } else {
        throw "operation failed";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> getLoanById(id) async {
    final response = await http.get('${mainApi}loans/${id}');

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      return responseBody;
    } else
      throw 'operation failed';
  }

  Future<http.Response> loanDelete(DeleteLoanDto loanDeleteDto) async {
    Map<String, String> requestHeaders = {
      'Authorization': 'bearer ${loanDeleteDto.apiToken}'
    };
    try {
      final response = await http.delete('${mainApi}loans/${loanDeleteDto.id}',
          headers: requestHeaders);
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 401) {
        throw '401';
      } else {
        throw "operation failed";
      }
    } catch (e) {
      throw e.toString();
    }
  }

// installment apis
  Future<http.Response> doInstallment(DoInstallmentDto doInstallment) async {
    Map<String, String> requestHeaders = {
      'Authorization': 'bearer ${doInstallment.apiToken}'
    };
    final response = await http.post(
        '${mainApi}loan-installments/${doInstallment.id}/do-installment',
        headers: requestHeaders);
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 401) {
      throw '401';
    } else {
      throw "operation failed";
    }
  }

  Future<Response> paidInstallment(PaidInstallmentDto paidInstallment) async {
    _dio.options.headers["Authorization"] =
        "bearer ${paidInstallment.apiToken}";
    FormData _paidInstallmentDio = FormData.fromMap(
      {
        'PayDate': paidInstallment.payDate,
        'Images': paidInstallment.imageArray.length > 0
            ? paidInstallment.imageArray
            : null,
      },
    );
    try {
      final response = await _dio.patch(
        '${mainApi}loan-installments/${paidInstallment.installmentId}/paid',
        data: _paidInstallmentDio,
        options: Options(
          followRedirects: false,
          // will not throw errors
          validateStatus: (status) => true,
        ),
      );
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 401) {
        throw '401';
      } else {
        throw "operation failed";
      }
    } catch (e) {
      throw e.toString();
    }
  }
  // dashboard apis

  Future<http.Response> getDashBoardInfo(DashBoradDto dashBoradDto) async {
    Map<String, String> requestHeaders = {
      'Authorization': 'bearer ${dashBoradDto.apiToken}'
    };
    try {
      final response = await http.get(
        '${mainApi}dashboards/admin',
        headers: requestHeaders,
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 401) {
        throw '401';
      } else {
        throw "operation failed";
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
