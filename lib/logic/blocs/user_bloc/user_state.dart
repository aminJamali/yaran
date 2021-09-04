part of 'user_bloc.dart';

@immutable
abstract class UserState {}

class UserRegisterState extends UserState {
  final bool isInserted;

  UserRegisterState(this.isInserted);
}

class UserChangePasswordState extends UserState {
  final bool isEdited;

  UserChangePasswordState(this.isEdited);
}

class GetAllUsersState extends UserState {
  final List<UserModel> users;

  GetAllUsersState(this.users);
}

class GetAllUsersBySearchState extends UserState {
  final List<UserModel> users;

  GetAllUsersBySearchState(this.users);
}

class GetUserByIdState extends UserState {
  final UserModel _userModel;

  GetUserByIdState(this._userModel);
}

class UserLoginState extends UserState {
  final String apiToken;

  UserLoginState(this.apiToken);
}

class UserLoadingState extends UserState {}

class UserExceptionState extends UserState {
  final String text;

  UserExceptionState(this.text);
}

class CheckConnectionState extends UserState {
  final bool isConnected;

  CheckConnectionState(this.isConnected);
}
