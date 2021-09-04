import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:moordak/data/dtos/user_dtos/get_user_info_dto.dart';
import 'package:moordak/data/dtos/user_dtos/user_login_dto.dart';
import 'package:moordak/data/dtos/user_dtos/user_register_dto.dart';
import 'package:moordak/data/models/user_model.dart';
import 'package:moordak/data/repositories/mourdak_repository.dart';
import 'package:dartz/dartz.dart';
part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(null);
  MourdakRepository _mourdakRepository = new MourdakRepository();
  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is UserRegisterEvent) {
      yield UserLoadingState();
      final failedOrResult =
          await _mourdakRepository.userRegister(event.userRegisterDto);

      yield failedOrResult.fold(
          (exception) => UserExceptionState(exception.message),
          (isSuccesed) => UserRegisterState(isSuccesed));
    } else if (event is UserChangePasswordEvent) {
      yield UserLoadingState();
    } else if (event is UserLoginEvent) {
      yield UserLoadingState();
      final failedOrResult =
          await _mourdakRepository.userLogin(event.userLoginDto);

      yield failedOrResult.fold(
          (exception) => UserExceptionState(exception.message),
          (apiToken) => UserLoginState(apiToken));
    } else if (event is GetAllUsersEvent) {
      yield UserLoadingState();
      final failedOrResult =
          await _mourdakRepository.getAllUsers(event.getUserInfoDto);

      yield failedOrResult.fold(
          (exception) => UserExceptionState(exception.message),
          (users) => GetAllUsersState(users));
    } else if (event is GetAllUsersBySearchEvent) {
      yield UserLoadingState();
      final failedOrResult =
          await _mourdakRepository.getAllUsersBySearch(event.getUserInfoDto);

      yield failedOrResult.fold(
          (exception) => UserExceptionState(exception.message),
          (users) => GetAllUsersBySearchState(users));
    } else if (event is GetUserByIdEvent) {
      yield UserLoadingState();
    } else if (event is CheckConnectionEvent) {
      yield UserLoadingState();
      bool isConnected;
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        isConnected = true;
      } else {
        isConnected = false;
      }
      yield CheckConnectionState(isConnected);
    }
  }
}
