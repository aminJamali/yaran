import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:moordak/data/dtos/dashboard_dtos/dashborad_dto.dart';
import 'package:moordak/data/models/dashboard_model.dart';
import 'package:moordak/data/repositories/mourdak_repository.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  MourdakRepository _mourdakRepository = new MourdakRepository();
  DashboardBloc() : super(DashboardInitial());

  @override
  Stream<DashboardState> mapEventToState(
    DashboardEvent event,
  ) async* {
    if (event is DashBoardGetInfoEvent) {
      yield DashBoardLoadingState();
      final failedOrResult =
          await _mourdakRepository.getDashboardInfo(event.dashBoradDto);

      yield failedOrResult.fold(
          (exception) => DashBoardExceptionState(exception.message),
          (dashboard) => DashBoardGetInfoState(dashboard));
    }
  }
}
