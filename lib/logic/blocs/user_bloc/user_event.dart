part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class UserRegisterEvent extends UserEvent {
  final UserRegisterDto userRegisterDto;

  UserRegisterEvent(this.userRegisterDto);
}

class UserChangePasswordEvent extends UserEvent {
  final FormData formData;

  UserChangePasswordEvent(this.formData);
}

class GetAllUsersEvent extends UserEvent {
  final GetUserInfoDto getUserInfoDto;

  GetAllUsersEvent(this.getUserInfoDto);
}

class GetAllUsersBySearchEvent extends UserEvent {
  final GetUserInfoDto getUserInfoDto;

  GetAllUsersBySearchEvent(this.getUserInfoDto);
}

class GetUserByIdEvent extends UserEvent {
  final int id;

  GetUserByIdEvent(this.id);
}

class UserLoginEvent extends UserEvent {
  final UserLoginDto userLoginDto;

  UserLoginEvent(this.userLoginDto);
}

class UserExceptionEvent extends UserEvent {
  final String message;

  UserExceptionEvent(this.message);
}

class CheckConnectionEvent extends UserEvent {}
