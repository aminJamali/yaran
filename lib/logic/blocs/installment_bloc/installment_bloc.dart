import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:moordak/data/dtos/installment_dtos/do_installment.dart';
import 'package:moordak/data/dtos/installment_dtos/paid_installment.dart';
import 'package:moordak/data/repositories/mourdak_repository.dart';

part 'installment_event.dart';
part 'installment_state.dart';

class InstallmentBloc extends Bloc<InstallmentEvent, InstallmentState> {
  MourdakRepository _mourdakRepository = new MourdakRepository();
  InstallmentBloc() : super(InstallmentInitial());

  @override
  Stream<InstallmentState> mapEventToState(
    InstallmentEvent event,
  ) async* {
    if (event is DoInstallmentEvent) {
      yield InstallmentLoadingState();
      final failedOrResult =
          await _mourdakRepository.doInstallment(event.doInstallment);

      yield failedOrResult.fold(
          (exception) => InstallmentExceptionState(exception.message),
          (isSuccessed) => DoInstallmentState(isSuccessed));
    } else if (event is PaidInstallmentEvent) {
      yield InstallmentLoadingState();
      final failedOrResult =
          await _mourdakRepository.paidInstallment(event.paidInstallment);

      yield failedOrResult.fold(
          (exception) => InstallmentExceptionState(exception.message),
          (isSuccessed) => PaidInstallmentState(isSuccessed));
    }
  }
}
