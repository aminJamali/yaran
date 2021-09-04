import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:moordak/data/dataproviders/mourdak_api.dart';
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
import 'package:moordak/data/exceptions.dart';
import 'package:moordak/data/models/dashboard_model.dart';
import 'package:moordak/data/models/loan_model.dart';
import 'package:moordak/data/models/transaction_model.dart';
import 'package:moordak/data/models/user_model.dart';

class MourdakRepository {
  MourdakApi _mourdakApi = new MourdakApi();

  //user repository

  Future<Either<Exceptions, String>> userLogin(
      UserLoginDto userLoginDto) async {
    try {
      final response = await _mourdakApi.userLogin(userLoginDto);
      String _apiToken;
      if (response.statusCode == 200)
        _apiToken = response.body;
      else if (response.statusCode == 500)
        _apiToken = "WrongUserOrPassword";
      else
        _apiToken = null;
      return Right(_apiToken);
    } catch (e) {
      return Left(
        Exceptions(
          message: e.toString(),
        ),
      );
    }
  }

  Future<Either<Exceptions, bool>> userRegister(
      UserRegisterDto userRegisterDto) async {
    try {
      final response = await _mourdakApi.userRegister(userRegisterDto);
      bool _isSuccesed;
      if (response.statusCode == 200)
        _isSuccesed = true;
      else {
        _isSuccesed = false;
      }
      return Right(_isSuccesed);
    } catch (e) {
      return Left(
        Exceptions(
          message: e.toString(),
        ),
      );
    }
  }

  Future<dynamic> getUserInfo(GetUserInfoDto getUserInfoDto) async {
    try {
      final response = await _mourdakApi.getUserInfo(getUserInfoDto);
      print(response.body);
      final responseBody = json.decode(response.body)['elements'];
      return responseBody;
    } catch (e) {
      return Exceptions(message: e.toString());
    }
  }

  Future<Either<Exceptions, List<UserModel>>> getAllUsers(
      GetUserInfoDto getUserInfoDto) async {
    List<UserModel> _users = [];
    try {
      final response = await _mourdakApi.getAllUsers(getUserInfoDto);

      var responseBody = List.from(json.decode(response.body)['elements']);
      responseBody.forEach((element) {
        _users.add(UserModel.fromJson(element));
      });

      return Right(
        _users,
      );
    } catch (e) {
      return Left(
        Exceptions(
          message: e.toString(),
        ),
      );
    }
  }

  Future<Either<Exceptions, List<UserModel>>> getAllUsersBySearch(
      GetUserInfoDto getUserInfoDto) async {
    List<UserModel> _users = [];
    try {
      final response = await _mourdakApi.getAllUsersBySearch(getUserInfoDto);

      var responseBody = List.from(json.decode(response.body)['elements']);
      responseBody.forEach((element) {
        _users.add(UserModel.fromJson(element));
      });

      return Right(
        _users,
      );
    } catch (e) {
      return Left(
        Exceptions(
          message: e.toString(),
        ),
      );
    }
  }

  Future<Either<Exceptions, bool>> userChangePassword(FormData formData) async {
    try {
      final response = await _mourdakApi.userChangePassword(formData);

      return Right(
        json.decode(response),
      );
    } catch (e) {
      return Left(
        Exceptions(
          message: e.toString(),
        ),
      );
    }
  }

  //transaction repository

  Future<Either<Exceptions, bool>> transactionInsert(
      TransactionAddDto transactionAddDto) async {
    bool _isSuccessed;
    try {
      final response = await _mourdakApi.transactionInsert(transactionAddDto);
      if (response.statusCode == 200) {
        _isSuccessed = true;
      } else {
        _isSuccessed = false;
      }
      return Right(
        _isSuccessed,
      );
    } catch (e) {
      return Left(
        Exceptions(
          message: e.toString(),
        ),
      );
    }
  }

  Future<Either<Exceptions, bool>> transactionEdit(
      TransactionAddDto transactionAddDto) async {
    bool _isSuccessed;
    try {
      final response = await _mourdakApi.transactionEdit(transactionAddDto);
      if (response.statusCode == 200) {
        _isSuccessed = true;
      } else {
        _isSuccessed = false;
      }
      return Right(
        _isSuccessed,
      );
    } catch (e) {
      return Left(
        Exceptions(
          message: e.toString(),
        ),
      );
    }
  }

  Future<Either<Exceptions, bool>> transactionDelete(
      TransactionDeleteDto transactionDeleteDto) async {
    bool _isSuccessed;
    try {
      final response =
          await _mourdakApi.transactionDelete(transactionDeleteDto);
      if (response.statusCode == 200) {
        _isSuccessed = true;
      } else {
        _isSuccessed = false;
      }
      return Right(
        _isSuccessed,
      );
    } catch (e) {
      return Left(
        Exceptions(
          message: e.toString(),
        ),
      );
    }
  }

  Future<Either<Exceptions, List<TransactionModel>>> getAllTransactions(
      TransactionGetDto transactionGetDto) async {
    List<TransactionModel> _transactions = [];
    try {
      final response = await _mourdakApi.getAllTransactions(transactionGetDto);

      var responseBody = List.from(json.decode(response.body)['elements']);
      responseBody.forEach((element) {
        _transactions.add(TransactionModel.fromJson(element));
      });

      //  _transactions = readJson(responseBody);
      return Right(
        _transactions,
      );
    } catch (e) {
      return Left(
        Exceptions(
          message: e.toString(),
        ),
      );
    }
  }

  Future<Either<Exceptions, List<TransactionModel>>> getAllTransactionsBySearch(
      TransactionGetDto transactionGetDto) async {
    List<TransactionModel> _transactions = [];
    try {
      final response =
          await _mourdakApi.getAllTransactionsBySearch(transactionGetDto);

      var responseBody = List.from(json.decode(response.body)['elements']);
      responseBody.forEach((element) {
        _transactions.add(TransactionModel.fromJson(element));
      });

      //  _transactions = readJson(responseBody);
      return Right(
        _transactions,
      );
    } catch (e) {
      return Left(
        Exceptions(
          message: e.toString(),
        ),
      );
    }
  }

  Future<Either<Exceptions, bool>> loanInsert(AddLoanDto addLoanDto) async {
    try {
      final response = await _mourdakApi.loanInsert(addLoanDto);
      bool _isSuccesed;
      if (response.statusCode == 200)
        _isSuccesed = true;
      else
        _isSuccesed = false;
      return Right(_isSuccesed);
    } catch (e) {
      return Left(
        Exceptions(
          message: e.toString(),
        ),
      );
    }
  }

  Future<Either<Exceptions, List<LoanModel>>> getAllLoans(
      GetLoanDto getLoanDto) async {
    List<LoanModel> _loans = [];
    try {
      final response = await _mourdakApi.getAllloans(getLoanDto);

      var responseBody = List.from(json.decode(response.body)['elements']);
      responseBody.forEach((element) {
        _loans.add(LoanModel.fromJson(element));
      });

      return Right(
        _loans,
      );
    } catch (e) {
      return Left(
        Exceptions(
          message: e.toString(),
        ),
      );
    }
  }

  Future<Either<Exceptions, List<LoanModel>>> getAllLoansBySearch(
      GetLoanDto getLoanDto) async {
    List<LoanModel> _loans = [];
    try {
      final response = await _mourdakApi.getAllloansBySearch(getLoanDto);

      var responseBody = List.from(json.decode(response.body)['elements']);
      responseBody.forEach((element) {
        _loans.add(LoanModel.fromJson(element));
      });

      return Right(
        _loans,
      );
    } catch (e) {
      return Left(
        Exceptions(
          message: e.toString(),
        ),
      );
    }
  }

  Future<Either<Exceptions, bool>> loanEdit(AddLoanDto addLoanDto) async {
    try {
      final response = await _mourdakApi.loanEdit(addLoanDto);
      bool _isSuccesed;
      if (response.statusCode == 200)
        _isSuccesed = true;
      else
        _isSuccesed = false;
      return Right(_isSuccesed);
    } catch (e) {
      return Left(
        Exceptions(
          message: e.toString(),
        ),
      );
    }
  }

  Future<Either<Exceptions, bool>> loanDelete(
      DeleteLoanDto deleteLoanDto) async {
    try {
      final response = await _mourdakApi.loanDelete(deleteLoanDto);
      bool _isSuccesed;
      if (response.statusCode == 200)
        _isSuccesed = true;
      else
        _isSuccesed = false;
      return Right(_isSuccesed);
    } catch (e) {
      return Left(
        Exceptions(
          message: e.toString(),
        ),
      );
    }
  }

  // installment apis

  Future<Either<Exceptions, bool>> doInstallment(
      DoInstallmentDto doInstallment) async {
    try {
      final response = await _mourdakApi.doInstallment(doInstallment);
      bool _isSuccesed;
      if (response.statusCode == 200)
        _isSuccesed = true;
      else
        _isSuccesed = false;
      return Right(_isSuccesed);
    } catch (e) {
      return Left(
        Exceptions(
          message: e.toString(),
        ),
      );
    }
  }

  Future<Either<Exceptions, bool>> paidInstallment(
      PaidInstallmentDto paidInstallment) async {
    try {
      final response = await _mourdakApi.paidInstallment(paidInstallment);
      bool _isSuccesed;
      if (response.statusCode == 200)
        _isSuccesed = true;
      else
        _isSuccesed = false;
      return Right(_isSuccesed);
    } catch (e) {
      return Left(
        Exceptions(
          message: e.toString(),
        ),
      );
    }
  }

  // dashboard repository

  Future<Either<Exceptions, DashBoardModel>> getDashboardInfo(
      DashBoradDto dashBoradDto) async {
    DashBoardModel dashBoardModel;
    try {
      final response = await _mourdakApi.getDashBoardInfo(dashBoradDto);

      var responseBody = json.decode(response.body);

      dashBoardModel = DashBoardModel.fromJson(responseBody);

      return Right(
        dashBoardModel,
      );
    } catch (e) {
      return Left(
        Exceptions(
          message: e.toString(),
        ),
      );
    }
  }
}
