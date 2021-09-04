part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashBoardGetInfoState extends DashboardState {
  final DashBoardModel dashBoardModel;

  DashBoardGetInfoState(this.dashBoardModel);
}

class DashBoardExceptionState extends DashboardState {
  final String message;

  DashBoardExceptionState(this.message);
}

class DashBoardLoadingState extends DashboardState {}
