part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardEvent {}

class DashBoardGetInfoEvent extends DashboardEvent {
  final DashBoradDto dashBoradDto;

  DashBoardGetInfoEvent(this.dashBoradDto);
}
